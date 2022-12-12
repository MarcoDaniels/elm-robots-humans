module Rule exposing (Rule(..), ruleToFile)


type Rule
    = Entry
    | Section


ruleToFile : Rule -> List String -> String
ruleToFile =
    \rule list ->
        list
            |> List.filter (\item -> item /= "")
            |> (case rule of
                    Entry ->
                        String.join "\n"

                    Section ->
                        String.join "\n\n"
               )
