module Input exposing (Model, Msg(..), init, update, view)

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


init : Model
init =
    { value = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change value ->
            ( Model value, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div
        (List.map
            (\( k, v ) -> style k v)
            Style.input
        )
        [ input
            [ onInput Change
            , value model.value
            ]
            []
        , button [ onClick Submit ] [ text "Show" ]
        ]
