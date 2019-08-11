module Tests exposing (decoderSuite)

import Api.Encoding exposing (..)
import Api.Types exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Iso8601
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (required)
import Test exposing (..)
import Time


toPosix : String -> Time.Posix
toPosix date =
    Iso8601.toTime date
        |> Result.withDefault (Time.millisToPosix 0)


decoderSuite : Test
decoderSuite =
    describe "The Api.Encoding Module, any Decoders defined by ApiRouting"
        [ describe "decoder for AuthorDto"
            [ test "all values decoded" <|
                \() ->
                    """
                    {
                        "username": "thedude",
                        "email": "el.duderino@aol.com",
                        "bio": "occasional acid flashback",
                        "image": "rug-p336.jpg"
                    }
                    """
                        |> decodeString authorDecoder
                        |> Expect.equal
                            (Ok
                                (AuthorDto
                                    "thedude"
                                    "el.duderino@aol.com"
                                    "occasional acid flashback"
                                    "rug-p336.jpg"
                                )
                            )
            ]
        , describe "decoder for CommentsDto & CommentDto"
            [ test "empty comments decoded" <|
                \() ->
                    """
                    []
                    """
                        |> decodeString commentsDecoder
                        |> Expect.equal (Ok [])
            , test "comment decoded without being in list" <|
                \() ->
                    """
                    {
                        "id": 1968,
                        "body": "far out man",
                        "author": {
                            "username": "thedude",
                            "email": "el.duderino@aol.com",
                            "bio": "occasional acid flashback",
                            "image": "tie-d13.png"
                        },
                        "createdAt": "2019-08-11T01:05:05.979Z",
                        "updatedAt": "2019-08-11T01:05:09.650Z"
                    }
                    """
                        |> decodeString commentDecoder
                        |> Expect.equal
                            (Ok
                                (CommentDto
                                    1968
                                    "far out man"
                                    (AuthorDto "thedude" "el.duderino@aol.com" "occasional acid flashback" "tie-d13.png")
                                    (Time.millisToPosix 1565485505979)
                                    (Time.millisToPosix 1565485509650)
                                )
                            )
            , test "comments in a list" <|
                \() ->
                    """
                    [
                        {
                            "id": 1968,
                            "body": "far out man",
                            "author": {
                                "username": "thedude",
                                "email": "el.duderino@aol.com",
                                "bio": "occasional acid flashback",
                                "image": "tie-d13.png"
                            },
                            "createdAt": "2019-08-11T01:05:05.979Z",
                            "updatedAt": "2019-08-11T01:05:09.650Z"
                        },
                        {
                            "id": 1966,
                            "body": "I'm throwing rock tonight!",
                            "author": {
                                "username": "donnie",
                                "email": "iwont.shutup@aol.com",
                                "bio": "",
                                "image": "bowling.gif"
                            },
                            "createdAt": "2019-08-11T01:05:11.979Z",
                            "updatedAt": "2019-08-11T01:05:11.979Z"
                        }
                    ]
                    """
                        |> decodeString commentsDecoder
                        |> Expect.equal
                            (Ok
                                [ CommentDto
                                    1968
                                    "far out man"
                                    (AuthorDto "thedude" "el.duderino@aol.com" "occasional acid flashback" "tie-d13.png")
                                    (Time.millisToPosix 1565485505979)
                                    (Time.millisToPosix 1565485509650)
                                , CommentDto
                                    1966
                                    "I'm throwing rock tonight!"
                                    (AuthorDto "donnie" "iwont.shutup@aol.com" "" "bowling.gif")
                                    (Time.millisToPosix 1565485511979)
                                    (Time.millisToPosix 1565485511979)
                                ]
                            )
            ]
        , describe "decoder for ArticlesDto and ArticleDto"
            [ test "that an empty articles response is decoded" <|
                \() ->
                    """
                    {
                        "articles": [],
                        "articlesCount": 0
                    }
                    """
                        |> decodeString articlesDecoder
                        |> Expect.equal (Ok (ArticlesDto [] 0))
            , test "article is decoded with minimal author fields" <|
                \() ->
                    """
                    {
                        "slug": "Are you a God?",
                        "title": "Are you a God?",
                        "description": "A Five Minute Introduction to Ghostbusters",
                        "body": "And Winston said, 'Ray…when someone asks you if you are a god, you say yes!'",
                        "author": {
                            "username": "username",
                            "email": "email"
                        },
                        "favorited": false,
                        "favoritesCount": 0,
                        "tagList": [
                            "information",
                            "paranormal",
                            "philosophy"
                        ],
                        "createdAt": "2019-08-11T16:08:25.5322696",
                        "updatedAt": "2019-08-11T16:08:25.5322703"
                    }
                    """
                        |> decodeString articleDecoder
                        |> Expect.equal
                            (Ok
                                (ArticleDto
                                    "Are you a God?"
                                    "Are you a God?"
                                    "A Five Minute Introduction to Ghostbusters"
                                    "And Winston said, 'Ray…when someone asks you if you are a god, you say yes!'"
                                    (AuthorDto "username" "email" "" "")
                                    False
                                    0
                                    [ "information", "paranormal", "philosophy" ]
                                    (toPosix "2019-08-11T16:08:25.5322696")
                                    (toPosix "2019-08-11T16:08:25.5322703")
                                )
                            )
            , test "that articles feed is decoded" <|
                \() ->
                    """
                    {
                        "articles": [
                            {
                                "slug": "Question - Is there a God in Dudeism?",
                                "title": "Question - Is there a God in Dudeism?",
                                "description": "A Five Minute Introduction to Dudeism",
                                "body": "Answer - Like Buddhism, Taoism and Confucianism, Dudeism is a non-theistic religion. That isn’t to say Dudeists necessarily don’t believe in God or a godlike power in the universe, only that passing judgment on this issue is not one of Dudeism’s goals. Like the Eastern religions just mentioned, Dudeism is interested in the here and now, not the there and then. The Dudeist objective is to make our lives more pleasant and meaningful to ourselves and each other.",
                                "author": {
                                    "username": "username",
                                    "email": "email"
                                },
                                "favorited": false,
                                "favoritesCount": 0,
                                "tagList": [
                                    "dudeism",
                                    "information",
                                    "philosophy"
                                ],
                                "createdAt": "2019-08-11T15:49:57.5525053",
                                "updatedAt": "2019-08-11T15:49:57.5525108"
                            },
                            {
                                "slug": "Was the Buddha a God?",
                                "title": "Was the Buddha a God?",
                                "description": "A Five Minute Introduction to Buddhism",
                                "body": "He was not, nor did he claim to be. He was a man who taught a path to enlightenment from his own experience.",
                                "author": {
                                    "username": "username",
                                    "email": "email"
                                },
                                "favorited": false,
                                "favoritesCount": 0,
                                "tagList": [
                                    "buddhism",
                                    "information",
                                    "philosophy"
                                ],
                                "createdAt": "2019-08-11T15:46:56.092803",
                                "updatedAt": "2019-08-11T15:46:56.0928039"
                            }
                        ],
                        "articlesCount": 2
                    }
                    """
                        |> decodeString articlesDecoder
                        |> Expect.equal
                            (Ok
                                (ArticlesDto
                                    [ ArticleDto
                                        "Question - Is there a God in Dudeism?"
                                        "Question - Is there a God in Dudeism?"
                                        "A Five Minute Introduction to Dudeism"
                                        "Answer - Like Buddhism, Taoism and Confucianism, Dudeism is a non-theistic religion. That isn’t to say Dudeists necessarily don’t believe in God or a godlike power in the universe, only that passing judgment on this issue is not one of Dudeism’s goals. Like the Eastern religions just mentioned, Dudeism is interested in the here and now, not the there and then. The Dudeist objective is to make our lives more pleasant and meaningful to ourselves and each other."
                                        (AuthorDto "username" "email" "" "")
                                        False
                                        0
                                        [ "dudeism", "information", "philosophy" ]
                                        (toPosix "2019-08-11T15:49:57.5525053")
                                        (toPosix "2019-08-11T15:49:57.5525108")
                                    , ArticleDto
                                        "Was the Buddha a God?"
                                        "Was the Buddha a God?"
                                        "A Five Minute Introduction to Buddhism"
                                        "He was not, nor did he claim to be. He was a man who taught a path to enlightenment from his own experience."
                                        (AuthorDto "username" "email" "" "")
                                        False
                                        0
                                        [ "buddhism", "information", "philosophy" ]
                                        (toPosix "2019-08-11T15:46:56.092803")
                                        (toPosix "2019-08-11T15:46:56.0928039")
                                    ]
                                    2
                                )
                            )
            ]
        ]
