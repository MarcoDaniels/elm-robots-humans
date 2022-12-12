module Humans exposing (Section, Humans, humans)

{-| <https://humanstxt.org/>

Humans.txt is an initiative for knowing the people behind the website. It's a text file from humans, for humans.

@docs Section, Humans, humans

-}

import Rule exposing (ruleToFile)


{-| Each section of the humans.txt file can be defined by a headline and a list of strings that create the content
-}
type alias Section =
    { headline : String
    , content : List String
    }


{-| The humans type is composed by a list of sections
-}
type alias Humans =
    List Section


{-| Creates a String with the humans.txt output

    humans
        [ { headline = "Team"
          , content = [ "Engineer: Marco Martins" ]
          }
        , { headline = "Technology"
          , content = [ "elm, terraform, nix" ]
          }
        ]

-}
humans : Humans -> String
humans sections =
    sections
        |> List.map
            (\{ headline, content } ->
                [ "/* " ++ headline ++ " */", content |> ruleToFile Rule.Entry ]
                    |> ruleToFile Rule.Entry
            )
        |> ruleToFile Rule.Section
