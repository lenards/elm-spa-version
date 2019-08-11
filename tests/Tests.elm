module Tests exposing (decoderSuite)

import Api.Encoding exposing (..)
import Api.Types exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import Json.Decode as Decode exposing (..)
import Json.Decode.Pipeline exposing (required)
import Test exposing (..)
import Time


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
        ]
