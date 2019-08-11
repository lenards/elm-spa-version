module Types exposing (Flags, Model, Msg(..), initSession)

import Browser
import Browser.Navigation as Nav
import Url exposing (Url)


type alias Flags =
    {}


type Msg
    = NoOp
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest


type Token
    = Token String


type Username
    = Username String


type Session
    = Unauthenticated Nav.Key
    | Session Nav.Key Username Token


type alias Model =
    { base : Url
    , flags : Flags
    , session : Session
    }


initSession : Nav.Key -> Session
initSession navKey =
    Unauthenticated navKey
