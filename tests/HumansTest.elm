module HumansTest exposing (..)

import Expect exposing (equal)
import Humans exposing (humans)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "humans"
        [ test "team building the website" <|
            \() ->
                humans [ { headline = "Team", content = [ "Engineer: Marco Martins" ] } ]
                    |> equal """/* Team */
Engineer: Marco Martins"""
        , test "multiple entries" <|
            \() ->
                humans
                    [ { headline = "Team"
                      , content = [ "Engineer: Marco Martins" ]
                      }
                    , { headline = "Technology"
                      , content = [ "elm, terraform, nix" ]
                      }
                    ]
                    |> equal """/* Team */
Engineer: Marco Martins

/* Technology */
elm, terraform, nix"""
        , test "empty content" <|
            \() ->
                humans [ { headline = "Hey there!", content = [] } ]
                    |> equal """/* Hey there! */"""
        ]
