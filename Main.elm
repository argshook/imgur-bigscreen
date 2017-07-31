module Main exposing (..)

import Html exposing (..)
import App


main : Program Never App.Model App.Msg
main =
    Html.program
        { init = App.initialModel ! [ App.getImages ]
        , view = App.view
        , update = App.update
        , subscriptions = \_ -> Sub.none
        }
