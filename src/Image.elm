module Image exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Imgur
import Style exposing (image)


view : Imgur.Image -> Html msg
view model =
    case model.link of
        Just link ->
            div
                (Style.styler
                    ([ ( "background-image", String.join "" [ "url(", link, ")" ] ) ]
                        ++ image
                    )
                )
                []

        Nothing ->
            div [] [ text "Image link not found :(" ]
