module Video exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Imgur
import Style


view : Imgur.Image -> Html msg
view model =
    video
        (Style.styler Style.video
            ++ [ Html.Attributes.preload "auto"
               , Html.Attributes.autoplay True
               , Html.Attributes.controls True
               , Html.Attributes.attribute "muted" "muted"
               , Html.Attributes.loop True
               , Html.Attributes.attribute "data-shim" <| Maybe.withDefault "" model.title
               ]
        )
        [ source
            [ src <| Maybe.withDefault "" model.mp4
            , type_ "video/mp4"
            ]
            []
        ]
