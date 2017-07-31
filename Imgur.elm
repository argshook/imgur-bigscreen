module Imgur exposing (..)

import Http
import Json.Decode as Decode


type alias Model =
    List Image


type alias Image =
    { title : String
    , link : String
    }


defaultImage : Image
defaultImage =
    { title = "", link = "" }



-- https://api.imgur.com/3/gallery/r/{{subreddit}}/{{sort}}/{{window}}/{{page}}


api : String -> String
api subreddit =
    "https://api.imgur.com/3/gallery/r/" ++ subreddit


responseDecoder : Decode.Decoder Model
responseDecoder =
    let
        imageDecoder =
            Decode.map2 Image
                (Decode.field "title" Decode.string)
                (Decode.field "link" Decode.string)
    in
        Decode.field "data" (Decode.list imageDecoder)


request : Http.Request Model
request =
    Http.request
        { method = "GET"
        , url = api "birdswitharms"
        , body = Http.emptyBody
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        , headers =
            [ Http.header "Authorization" "Client-ID f09bccbd2f1c97f"
            ]
        }
