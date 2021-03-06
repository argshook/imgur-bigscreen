module Imgur exposing (Image, Model, api, defaultImage, request, responseDecoder)

import Http
import Json.Decode as Decode


type alias Model =
    List Image


type alias Image =
    { title : Maybe String
    , link : Maybe String
    , nsfw : Maybe Bool
    , isAlbum : Maybe Bool
    , animated : Maybe Bool
    , mp4 : Maybe String
    }


defaultImage : Image
defaultImage =
    { title = Just ""
    , link = Just ""
    , nsfw = Just False
    , isAlbum = Just False
    , animated = Just False
    , mp4 = Nothing
    }



-- https://api.imgur.com/3/gallery/r/{{subreddit}}/{{sort}}/{{window}}/{{page}}


api : String -> String -> String
api subreddit page =
    "https://api.imgur.com/3/gallery/r/" ++ subreddit ++ "/time/today/" ++ page


responseDecoder : Decode.Decoder Model
responseDecoder =
    let
        imageDecoder =
            Decode.map6 Image
                (Decode.maybe (Decode.field "title" Decode.string))
                (Decode.maybe (Decode.field "link" Decode.string))
                (Decode.maybe (Decode.field "nsfw" Decode.bool))
                (Decode.maybe (Decode.field "is_album" Decode.bool))
                (Decode.maybe (Decode.field "animated" Decode.bool))
                (Decode.maybe (Decode.field "mp4" Decode.string))
    in
    Decode.field "data" (Decode.list imageDecoder)


request : String -> (Result Http.Error Model -> msg) -> Cmd msg
request url msg =
    Http.request
        { method = "GET"
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson msg responseDecoder
        , timeout = Nothing
        , tracker = Nothing
        , headers =
            [ Http.header "Authorization" "Client-ID f09bccbd2f1c97f"
            ]
        }
