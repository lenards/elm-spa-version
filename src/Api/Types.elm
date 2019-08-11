module Api.Types exposing (ArticleDto, ArticlesDto, AuthorDto, CommentDto, CommentsDto)

import Time


type alias AuthorDto =
    { username : String
    , email : String
    , bio : String
    , image : String
    }


type alias CommentsDto =
    List CommentDto


type alias CommentDto =
    { id : Int
    , body : String
    , author : AuthorDto
    , createdAt : Time.Posix -- "2019-08-10T21:24:14.919Z",
    , updatedAt : Time.Posix -- "2019-08-10T21:24:14.919Z"
    }


type alias ArticlesDto =
    { articles : List ArticleDto
    , articlesCount : Int
    }


type alias ArticleDto =
    { slug : String
    , title : String
    , description : String
    , body : String
    , author : AuthorDto
    , favorited : Bool
    , favoritesCount : Int
    , tagList : List String
    , createdAt : Time.Posix -- "2019-08-10T21:24:14.919Z",
    , updatedAt : Time.Posix -- "2019-08-10T21:24:14.919Z"
    }


type alias UserDto =
    { username : String
    , email : String
    , bio : String
    , image : String
    , token : String
    }


type alias UpdateUserDto =
    { username : String
    , email : String
    , password : String
    , bio : String
    , image : String
    }


type alias CreateUserDto =
    { username : String
    , email : String
    , password : String
    }


type alias LoginDto =
    { email : String
    , password : String
    }
