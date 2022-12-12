module RuleTest exposing (..)

import Expect exposing (equal)
import Rule exposing (Rule(..), ruleToFile)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "rule to file"
        [ test "match list of entries" <|
            \() ->
                ruleToFile Entry [ "one", "", "two" ]
                    |> equal """one
two"""
        , test "match list of section" <|
            \() ->
                ruleToFile Section [ "one", "", "two", "ten", "" ]
                    |> equal """one

two

ten"""
        ]
