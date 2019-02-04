module Countdown exposing (Model, Msg(..), view)

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
        (Style.styler Style.countdown)
        [ input
            (Style.styler Style.countdownRange
                ++ [ type_ "range"
                   , Html.Attributes.min "3"
                   , Html.Attributes.max "60"
                   , onInput Change
                   ]
            )
            []
        , button
            (Style.styler Style.countdownButton
                ++ [ onClick Click ]
            )
            [ text <|
                if model.isPlaying then
                    String.fromInt model.count

                else
                    "▮▮"
            ]
        ]
