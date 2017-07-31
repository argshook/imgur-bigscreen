module App exposing (..)

import Process
import Task
import Http
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Image
import Imgur
import Array
import Style
import Time
import Input


type alias Model =
    { images : Imgur.Model
    , visibleId : Int
    , visibleImage : Imgur.Image
    , error : String
    , inputModel : Input.Model
    }


type Msg
    = SetImages (Result Http.Error Imgur.Model)
    | ShowNext
    | InputMsg Input.Msg


initialModel : Model
initialModel =
    { images = []
    , visibleId = 0
    , visibleImage = Imgur.defaultImage
    , error = ""
    , inputModel = Input.Model "birdswitharms"
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


delay : Time.Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.perform (\_ -> msg)


nextTimer =
    delay (Time.second * 20) <| ShowNext


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputMsg msg ->
            case msg of
                Input.Submit ->
                    model ! [ getImages (Imgur.request <| Imgur.api model.inputModel.value "0") ]

                _ ->
                    let
                        ( inputModel, inputMsg ) =
                            Input.update msg model.inputModel
                    in
                        { model | inputModel = inputModel } ! [ Cmd.map InputMsg inputMsg ]

        SetImages (Ok images) ->
            (if List.length images /= 0 then
                { model
                    | images = images
                    , visibleId = 0
                    , visibleImage = pickImage 0 images
                }
             else
                model
            )
                ! []

        SetImages (Err error) ->
            { model | error = toString error } ! []

        ShowNext ->
            let
                newId =
                    (model.visibleId + 1) % List.length model.images
            in
                { model
                    | visibleId = newId
                    , visibleImage = pickImage newId model.images
                }
                    ! [ nextTimer ]


getImages : Http.Request Imgur.Model -> Cmd Msg
getImages request =
    Http.send SetImages request


view : Model -> Html Msg
view model =
    div
        [ style Style.root ]
        [ Html.map InputMsg (Input.view model.inputModel)
        , Image.view model.visibleImage
        ]
