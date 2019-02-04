module Main exposing (Model, Msg(..), init, main, update, view)

import App
import Browser
import Browser.Navigation
import Html exposing (Html, div, text)
import Imgur
import Input
import Url


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        }


type alias Model =
    { query : String
    , app : App.Model
    }


type Msg
    = UrlChanged Url.Url
    | AppMsg App.Msg
    | LinkClicked Browser.UrlRequest


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        query =
            Maybe.withDefault "programmerhumor" url.fragment
    in
    ( Model "programmerhumor" (App.init query)
    , Cmd.map AppMsg
        (Imgur.request (Imgur.api query "0") App.SetImages)
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map AppMsg (App.subscriptions model.app)


view : Model -> Browser.Document Msg
view model =
    { title = "dank memes melt steel beams"
    , body = [ Html.map AppMsg (App.view model.app) ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChanged url ->
            let
                query =
                    Maybe.withDefault "programmerhumor" url.fragment
            in
            ( Model query model.app
            , Cmd.map AppMsg
                (Imgur.request (Imgur.api query "0") App.SetImages)
            )

        AppMsg appMsg ->
            let
                ( appModel, appCmd ) =
                    App.update appMsg model.app
            in
            ( { model | app = appModel }, Cmd.map AppMsg appCmd )

        _ ->
            ( model, Cmd.none )
