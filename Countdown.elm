module Countdown exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Style


type alias Model =
    { count : Int
    , isPlaying : Bool
    }


type Msg
    = Click
    | Change String


view : Model -> Html Msg
view model =
    div
        [ style Style.countdown ]
        [ input
            [ style Style.countdownRange
            , type_ "range"
            , Html.Attributes.min "3"
            , Html.Attributes.max "60"
            , onInput Change
            ]
            []
        , button
            [ style Style.countdownButton
            , onClick Click
            ]
            [ text <|
                if model.isPlaying then
                    toString model.count
                else
                    "▮▮"
            ]
        ]
