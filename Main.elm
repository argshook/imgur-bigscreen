module Main exposing (..)

import Html exposing (..)
import App
import Imgur


main : Program Never App.Model App.Msg
main =
    Html.program
        { init = App.initialModel ! [ App.getImages (Imgur.request <| Imgur.api "birdswitharms" "0"), App.nextTimer ]
        , view = App.view
        , update = App.update
        , subscriptions = \_ -> Sub.none
        }
