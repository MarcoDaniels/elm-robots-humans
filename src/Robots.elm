module Robots exposing (Policy, Robots, Value(..), robots)


type Value
    = SingleValue String
    | MultiValue (List String)


type alias Policy =
    { userAgent : Value
    , allow : Maybe Value
    , disallow : Maybe Value

    --    , crawlDelay : Maybe Int -- TODO: make it withCrawlDelay
    --    , cleanParam : Maybe String -- TODO: make is withCleanParam
    }


type alias Robots =
    { policies : List Policy
    , host : String
    , sitemap : Value
    }


robots : Robots -> String
robots { sitemap, host, policies } =
    [ policies
        |> List.map
            (\policy ->
                [ pathToEntry policy.userAgent UserAgent
                , case policy.allow of
                    Just allow ->
                        pathToEntry allow Allow

                    Nothing ->
                        ""
                , case policy.disallow of
                    Just disallow ->
                        pathToEntry disallow Disallow

                    Nothing ->
                        ""
                ]
                    |> listToSection
            )
        |> listToSection
    , pathToEntry sitemap Sitemap
    , pathToEntry (SingleValue host) Host
    ]
        |> listToSection



--- Internal only


type PathAttribute
    = Sitemap
    | Allow
    | Disallow
    | UserAgent
    | Host


pathAttributeToString : PathAttribute -> String
pathAttributeToString att =
    case att of
        Sitemap ->
            "Sitemap: "

        Allow ->
            "Allow: "

        Disallow ->
            "Disallow: "

        UserAgent ->
            "User-agent: "

        Host ->
            "Host: "


pathToEntry : Value -> PathAttribute -> String
pathToEntry pathType attr =
    case pathType of
        SingleValue path ->
            pathAttributeToString attr ++ path

        MultiValue multiple ->
            multiple
                |> List.map (\path -> pathAttributeToString attr ++ path)
                |> listToSection


listToSection : List String -> String
listToSection list =
    list
        |> List.filter (\a -> a /= "")
        |> String.join "\n"
