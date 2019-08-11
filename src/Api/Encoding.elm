module Api.Encoding exposing (articleDecoder, articlesDecoder, authorDecoder, commentDecoder, commentsDecoder)

import Api.Types exposing (..)
import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as DecodeExtra
import Json.Decode.Pipeline exposing (optional, required)
import Json.Encode as Encode exposing (..)
import Json.Encode.Extra as EncodeExtra exposing (maybe)


authorDecoder : Decoder AuthorDto
authorDecoder =
    Decode.succeed AuthorDto
        |> required "username" Decode.string
        |> required "email" Decode.string
        |> optional "bio" Decode.string ""
        |> optional "image" Decode.string ""


commentDecoder : Decoder CommentDto
commentDecoder =
    Decode.succeed CommentDto
        |> required "id" Decode.int
        |> required "body" Decode.string
        |> required "author" authorDecoder
        |> required "createdAt" DecodeExtra.datetime
        |> required "updatedAt" DecodeExtra.datetime


commentsDecoder : Decoder CommentsDto
commentsDecoder =
    Decode.list commentDecoder


articleDecoder : Decoder ArticleDto
articleDecoder =
    Decode.succeed ArticleDto
        |> required "slug" Decode.string
        |> required "title" Decode.string
        |> required "description" Decode.string
        |> required "body" Decode.string
        |> required "author" authorDecoder
        |> required "favorited" Decode.bool
        |> required "favoritesCount" Decode.int
        |> required "tagList" (Decode.list Decode.string)
        |> required "createdAt" DecodeExtra.datetime
        |> required "updatedAt" DecodeExtra.datetime


articlesDecoder : Decoder ArticlesDto
articlesDecoder =
    Decode.succeed ArticlesDto
        |> required "articles" (Decode.list articleDecoder)
        |> required "articlesCount" Decode.int
