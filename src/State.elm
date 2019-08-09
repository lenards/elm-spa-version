module State exposing (init, subscriptions, update)

import Browser.Navigation as Nav
import Types exposing (Flags, Model, Msg(..))
import Url exposing (Url)



-- Initialization


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        initialModel =
            { base = url
            , nav = navKey
            , flags = flags
            }
    in
    ( initialModel, Cmd.none )



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ChangedUrl url ->
            ( model, Cmd.none )

        ClickedLink urlRequest ->
            ( model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []
