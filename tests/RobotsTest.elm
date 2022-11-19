module RobotsTest exposing (..)

import Expect exposing (equal)
import Robots exposing (robots)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "robots"
        [ test "simple-concat" <|
            \() ->
                robots [ "a", "b" ]
                    |> equal "ab"
        ]
