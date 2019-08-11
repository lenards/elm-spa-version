module Api.Endpoints exposing
    ( ApiBase(..)
    , Endpoint
    , articles
    , articlesFeed
    , tags
    , toUrl
    , unwrap
    , user
    , users
    , usersLogin
    )

import Url.Builder exposing (QueryParameter)


type Endpoint
    = Endpoint_ String


type ApiBase
    = ApiBase String
    | ApiBaseWithPrefix String String


unwrap : Endpoint -> String
unwrap (Endpoint_ uri) =
    "/" ++ uri


fromApiBase : ApiBase -> Endpoint -> (List QueryParameter -> String)
fromApiBase base endpt =
    case base of
        ApiBase root ->
            Url.Builder.crossOrigin root (unwrap endpt)

        ApiBaseWithPrefix root servicePrefix ->
            Url.Builder.crossOrigin root (servicePrefix :: unwrap endpt)


toUrl : Endpoint -> List QueryParameter -> ApiBase -> String
toUrl endpt params base =
    fromApiBase base endpt params


articles : Endpoint
articles =
    Endpoint_ "articles"


articlesFeed : Endpoint
articlesFeed =
    Endpoint_ "articles/feed"


tags : Endpoint
tags =
    Endpoint_ "tags"


user : Endpoint
user =
    Endpoint_ "user"


users : Endpoint
users =
    Endpoint_ "users"


usersLogin : Endpoint
usersLogin =
    Endpoint_ "users/login"
