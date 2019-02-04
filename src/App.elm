module App exposing (Model, Msg(..), filterImages, init, pickImage, subscriptions, update, view)

import Array
import Countdown
import Html exposing (..)
import Html.Attributes exposing (style)
import Http
import Image
import Imgur
import Input
import Process
import String
import Style
import Task
import Time
import Video


type alias Model =
    { images : Imgur.Model
    , visibleId : Int
    , visibleImage : Imgur.Image
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
    | Tick Time.Posix
    | InputMsg Input.Msg
    | CountdownMsg Countdown.Msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- (toFloat (Time.toMillis Time.utc (Time.millisToPosix 0) * 200))


init : String -> Model
init query =
    { images = []
    , visibleId = 0
    , visibleImage = Imgur.defaultImage
    , inputModel = Input.Model query
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


countdownMsg : Countdown.Msg -> Model -> ( Model, Cmd Msg )
countdownMsg msg model =
    case msg of
        Countdown.Click ->
            ( { model | isPlaying = not model.isPlaying }, Cmd.none )

        Countdown.Change count ->
            case String.toInt count of
                Just value ->
                    ( { model | slideshowInterval = value }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )


inputMsg : Input.Msg -> Model -> ( Model, Cmd Msg )
inputMsg msg model =
    case msg of
        Input.Submit ->
            ( { model | isLoading = True }
            , Imgur.request (Imgur.api model.inputModel.value "0") SetImages
            )

        _ ->
            let
                ( inputModel, inputM ) =
                    Input.update msg model.inputModel
            in
            ( { model | inputModel = inputModel }, Cmd.map InputMsg inputM )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CountdownMsg m ->
            countdownMsg m model

        Tick _ ->
            let
                tick =
                    modBy model.slideshowInterval (model.tick + 1)

                model_ =
                    if model.isPlaying then
                        { model | tick = tick }

                    else
                        model
            in
            if tick == 0 && model.isPlaying then
                update PrepareNext model_

            else
                ( model_, Cmd.none )

        InputMsg m ->
            inputMsg m model

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

        SetImages _ ->
            ( model, Cmd.none )

        ShowNext ->
            let
                listLength =
                    List.length model.images

                newId =
                    modBy
                        (if listLength == 0 then
                            1

                         else
                            listLength
                        )
                        (model.visibleId + 1)
            in
            ( { model
                | isLoading = False
                , visibleId = newId
                , visibleImage = pickImage newId model.images
              }
            , Cmd.none
            )

        PrepareNext ->
            ( { model
                | isLoading = True
              }
            , Task.perform (\_ -> ShowNext) <|
                Process.sleep
                    (toFloat (Time.toMillis Time.utc (Time.millisToPosix 0) * 200))
            )


view : Model -> Html Msg
view model =
    let
        player =
            if Maybe.withDefault False model.visibleImage.animated then
                Video.view model.visibleImage

            else
                Image.view model.visibleImage

        loader =
            div (Style.styler Style.loader) [ text "..." ]
    in
    div
        (Style.styler Style.root)
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
