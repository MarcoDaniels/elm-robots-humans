module Robots exposing (..)


type Path
    = SinglePath String
    | MultiPath (List String)


type PathAttribute
    = Sitemap
    | Allow
    | Disallow


type alias Policy =
    { userAgent : String
    , allow : Maybe Path
    , disallow : Maybe Path

    --    , crawlDelay : Maybe Int -- TODO: make it withCrawlDelay
    --    , cleanParam : Maybe String -- TODO: make is withCleanParam
    }


type alias Robots =
    { policies : List Policy
    , host : String
    , sitemap : Path
    }


pathAttributeToString : PathAttribute -> String
pathAttributeToString att =
    case att of
        Sitemap ->
            "Sitemap: "

        Allow ->
            "Allow: "

        Disallow ->
            "Disallow: "


pathToEntry : Path -> PathAttribute -> String
pathToEntry pathType attr =
    case pathType of
        SinglePath path ->
            pathAttributeToString attr ++ path

        MultiPath multiple ->
            multiple
                |> List.map (\path -> pathAttributeToString attr ++ path)
                |> String.join ", "


robots : Robots -> String
robots { sitemap, host, policies } =
    [ policies
        |> List.map
            (\policy ->
                [ "User-agent: " ++ policy.userAgent
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
                    |> List.filter (\a -> a /= "")
                    |> String.join "\n"
            )
        |> String.join "\n"
    , pathToEntry sitemap Sitemap
    , "Host: " ++ host
    ]
        |> String.join "\n"
