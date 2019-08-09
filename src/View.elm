module View exposing (view)

import Browser exposing (Document)
import Html exposing (div, text)
import Types exposing (Model, Msg(..))


view : Model -> Document Msg
view model =
    { title = "Conduit"
    , body = [ div [] [ text "Conduit Placeholder" ] ]
    }
