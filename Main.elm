module Main exposing (..)

import Html exposing (..)
import App
import Imgur


main : Program Never App.Model App.Msg
main =
    Html.program
        { init = App.initialModel ! [ App.getImages (Imgur.request <| Imgur.api "funny" "0") ]
        , view = App.view
        , update = App.update
        , subscriptions = App.subscriptions
        }
