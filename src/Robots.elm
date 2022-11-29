module Robots exposing (CleanParam, Policy, PolicyExtra, Robots, Value(..), policy, robots, withCleanParam, withCrawlDelay)


type Value
    = SingleValue String
    | MultiValue (List String)


type alias Policy =
    { userAgent : Value, allow : Maybe Value, disallow : Maybe Value }


type alias CleanParam =
    { param : String, path : String }


type alias PolicyExtra base =
    { base | crawlDelay : Maybe Int, cleanParam : Maybe (List CleanParam) }


policy : Policy -> PolicyExtra Policy
policy { userAgent, allow, disallow } =
    { userAgent = userAgent
    , allow = allow
    , disallow = disallow
    , crawlDelay = Nothing
    , cleanParam = Nothing
    }


withCrawlDelay : Int -> PolicyExtra Policy -> PolicyExtra Policy
withCrawlDelay delay extra =
    { extra | crawlDelay = Just delay }


withCleanParam : List CleanParam -> PolicyExtra Policy -> PolicyExtra Policy
withCleanParam param extra =
    { extra | cleanParam = Just param }


type alias Robots =
    { policies : List (PolicyExtra Policy)
    , host : String
    , sitemap : Value
    }


robots : Robots -> String
robots { sitemap, host, policies } =
    [ policies
        |> List.map
            (\pol ->
                [ pathToEntry pol.userAgent UserAgent
                , case pol.allow of
                    Just allow ->
                        pathToEntry allow Allow

                    Nothing ->
                        ""
                , case pol.disallow of
                    Just disallow ->
                        pathToEntry disallow Disallow

                    Nothing ->
                        ""
                , case pol.crawlDelay of
                    Just delay ->
                        pathAttributeToString CrawlDelay ++ String.fromInt delay

                    Nothing ->
                        ""
                , case pol.cleanParam of
                    Just cleanParams ->
                        cleanParams
                            |> List.map (\{ param, path } -> pathAttributeToString CleanParamAtt ++ param ++ " " ++ path)
                            |> ruleToFile Entry

                    Nothing ->
                        ""
                ]
                    |> ruleToFile Entry
            )
        |> ruleToFile Section
    , pathToEntry sitemap Sitemap
    , pathToEntry (SingleValue host) Host
    ]
        |> ruleToFile Section



--- Internal only


type PathAttribute
    = Sitemap
    | Allow
    | Disallow
    | UserAgent
    | Host
    | CrawlDelay
    | CleanParamAtt


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

        CrawlDelay ->
            "Crawl-delay: "

        CleanParamAtt ->
            "Clean-param: "


pathToEntry : Value -> PathAttribute -> String
pathToEntry pathType attr =
    case pathType of
        SingleValue path ->
            pathAttributeToString attr ++ path

        MultiValue multiple ->
            multiple
                |> List.map (\path -> pathAttributeToString attr ++ path)
                |> ruleToFile Entry


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
