module Imgur exposing (..)

import Http
import Json.Decode as Decode


type alias Model =
    List Image


type alias Image =
    { title : Maybe String
    , link : Maybe String
    }


defaultImage : Image
defaultImage =
    { title = Just "", link = Just "" }



-- https://api.imgur.com/3/gallery/r/{{subreddit}}/{{sort}}/{{window}}/{{page}}


api : String -> String -> String
api subreddit page =
    "https://api.imgur.com/3/gallery/r/" ++ subreddit ++ "/top/month/" ++ page


responseDecoder : Decode.Decoder Model
responseDecoder =
    let
        imageDecoder =
            Decode.map2 Image
                (Decode.maybe (Decode.field "title" Decode.string))
                (Decode.maybe (Decode.field "link" Decode.string))
    in
        Decode.field "data" (Decode.list imageDecoder)


request : String -> Http.Request Model
request url =
    Http.request
        { method = "GET"
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers =
            [ Http.header "Authorization" "Client-ID f09bccbd2f1c97f"
            ]
        }
