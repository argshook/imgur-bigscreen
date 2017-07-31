module Image exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Imgur
import Style exposing ((=>), image)


view : Imgur.Image -> Html msg
view model =
    case model.link of
        Just link ->
            div
                [ style <| ("background-image" => ("url(" ++ link ++ ")")) :: image
                ]
                []

        Nothing ->
            div [] [ text "Image link not found :(" ]
