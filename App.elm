module App exposing (..)

import Process
import Task
import Time
import Http
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import String
import Image
import Video
import Imgur
import Array
import Style
import Time
import Input
import Countdown


type alias Model =
    { images : Imgur.Model
    , visibleId : Int
    , visibleImage : Imgur.Image
    , error : String
    , inputModel : Input.Model
    , tick : Int
    , slideshowInterval : Int
    , isPlaying : Bool
    , isLoading : Bool
    }


type Msg
    = SetImages (Result Http.Error Imgur.Model)
    | ShowNext
    | PrepareNext
    | Tick Time.Time
    | InputMsg Input.Msg
    | CountdownMsg Countdown.Msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick


initialModel : Model
initialModel =
    { images = []
    , visibleId = 0
    , visibleImage = Imgur.defaultImage
    , error = ""
    , inputModel = Input.Model "funny"
    , tick = 0
    , slideshowInterval = 30
    , isPlaying = True
    , isLoading = True
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


filterImages : List Imgur.Image -> List Imgur.Image
filterImages images =
    let
        -- all rules must evaluate to True for image to be displayed
        rules : List (Imgur.Image -> Bool)
        rules =
            [ \image -> not (Maybe.withDefault True image.nsfw)
            , \image -> not (Maybe.withDefault True image.isAlbum)
            ]

        filter : Imgur.Image -> Bool
        filter image =
            List.all (\r -> r image) rules
    in
        List.filter filter images


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CountdownMsg msg ->
            case msg of
                Countdown.Click ->
                    { model | isPlaying = not model.isPlaying } ! []

                Countdown.Change count ->
                    case String.toInt count of
                        Ok value ->
                            { model | slideshowInterval = value } ! []

                        Err _ ->
                            model ! []

        Tick _ ->
            let
                tick =
                    (model.tick + 1) % model.slideshowInterval

                model_ =
                    if model.isPlaying then
                        { model | tick = tick }
                    else
                        model
            in
                if tick == 0 && model.isPlaying then
                    update PrepareNext model_
                else
                    model_ ! []

        InputMsg msg ->
            case msg of
                Input.Submit ->
                    { model | isLoading = True } ! [ getImages (Imgur.request <| Imgur.api model.inputModel.value "0") ]

                _ ->
                    let
                        ( inputModel, inputMsg ) =
                            Input.update msg model.inputModel
                    in
                        { model | inputModel = inputModel } ! [ Cmd.map InputMsg inputMsg ]

        SetImages (Ok images) ->
            let
                model_ =
                    if List.length images /= 0 then
                        { model
                            | images = filterImages images
                            , visibleId = 0
                        }
                    else
                        model
            in
                update ShowNext model_

        SetImages (Err error) ->
            { model | error = toString error } ! []

        ShowNext ->
            let
                listLength =
                    List.length model.images

                newId =
                    (model.visibleId + 1)
                        % (if listLength == 0 then
                            1
                           else
                            listLength
                          )
            in
                { model
                    | isLoading = False
                    , visibleId = newId
                    , visibleImage = pickImage newId model.images
                }
                    ! []

        PrepareNext ->
            { model
                | isLoading = True
            }
                ! [ Task.perform (\_ -> ShowNext) <| Process.sleep (Time.millisecond * 200)
                  ]


getImages : Http.Request Imgur.Model -> Cmd Msg
getImages request =
    Http.send SetImages request


view : Model -> Html Msg
view model =
    let
        player =
            if Maybe.withDefault False model.visibleImage.animated then
                Video.view model.visibleImage
            else
                Image.view model.visibleImage

        loader =
            div [ style Style.loader ] [ text "..." ]
    in
        div
            [ style Style.root ]
            [ if model.isLoading then
                loader
              else
                player
            , Html.map CountdownMsg <|
                Countdown.view <|
                    Countdown.Model (model.slideshowInterval - model.tick)
                        model.isPlaying
            , Html.map InputMsg (Input.view model.inputModel)
            ]
