module App exposing (..)

import Http
import Html.Attributes exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Image
import Imgur
import Array


type alias Model =
    { images : Imgur.Model
    , visibleId : Int
    , visibleImage : Imgur.Image
    , error : String
    }


type Msg
    = GetImages
    | SetImage (Result Http.Error Imgur.Model)
    | ShowNext


initialModel : Model
initialModel =
    { images = []
    , visibleId = 0
    , visibleImage = Imgur.defaultImage
    , error = ""
    }


pickImage : Int -> Imgur.Model -> Imgur.Image
pickImage index images =
    let
        item =
            Array.fromList images
                |> Array.get index
    in
        case item of
            Just image ->
                image

            Nothing ->
                Imgur.defaultImage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetImages ->
            model ! [ getImages ]

        SetImage (Ok images) ->
            { model | images = images, visibleImage = pickImage model.visibleId images } ! []

        SetImage (Err error) ->
            { model | error = toString error } ! []

        ShowNext ->
            let
                newId =
                    model.visibleId + 1
            in
                { model | visibleId = newId, visibleImage = pickImage newId model.images } ! []


getImages : Cmd Msg
getImages =
    Http.send SetImage Imgur.request


view : Model -> Html Msg
view model =
    div
        []
        [ Image.view model.visibleImage ShowNext
        ]
