module Video exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Imgur
import Style


view : Imgur.Image -> Html msg
view model =
    video
        [ preload "auto"
        , style Style.video
        , Html.Attributes.attribute "autoplay" "autoplay"
        , Html.Attributes.attribute "muted" "muted"
        , Html.Attributes.attribute "loop" "loop"
        , Html.Attributes.attribute "data-shim" <| Maybe.withDefault "" model.title
        ]
        [ source
            [ src <| Maybe.withDefault "" model.mp4
            , type_ "video/mp4"
            ]
            []
        ]
