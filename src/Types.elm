module Types exposing (Flags, Model, Msg(..))

import Browser
import Browser.Navigation as Nav
import Url exposing (Url)


type alias Flags =
    {}


type Msg
    = NoOp
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest


type alias Model =
    { base : Url
    , nav : Nav.Key
    , flags : Flags
    }
