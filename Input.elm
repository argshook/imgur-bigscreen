module Input exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Style


type alias Model =
    { value : String
    }


type Msg
    = Change String
    | Submit


initialModel : Model
initialModel =
    { value = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change value ->
            Model value ! []

        _ ->
            model ! []


view : Model -> Html Msg
view model =
    div
        [ style Style.input ]
        [ input
            [ onInput Change
            , value model.value
            ]
            []
        , button [ onClick Submit ] [ text "Show" ]
        ]
