module Image exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Imgur


view : Imgur.Image -> msg -> Html msg
view model showNext =
    img [ src model.link, alt model.title, onClick showNext ] []
