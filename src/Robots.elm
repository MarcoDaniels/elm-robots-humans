module Robots exposing (Value(..), Policy, Robots, policy, robots, withCrawlDelay, CleanParam, withCleanParam)

{-| <https://moz.com/learn/seo/robotstxt>

Include a Robots.txt file to instruct robots (search engines) how and what pages to crawl in your website.

@docs Value, Policy, Robots, policy, robots, withCrawlDelay, CleanParam, withCleanParam

-}

import Rule exposing (Rule(..), ruleToFile)


{-| The value type used for most entries of robots
-}
type Value
    = SingleValue String
    | MultiValue (List String)


{-| Policy type for robots.txt policies
-}
type alias Policy =
    { userAgent : Value, allow : Maybe Value, disallow : Maybe Value }


{-| Clean-param type for [`withCleanParam`](#withCleanParam)
-}
type alias CleanParam =
    { param : String, path : String }


{-| Create a robots.txt policy entry

    policy
        { userAgent = SingleValue "*"
        , allow = Just (SingleValue "*")
        , disallow = Nothing
        }

-}
policy : Policy -> PolicyExtra Policy
policy { userAgent, allow, disallow } =
    { userAgent = userAgent
    , allow = allow
    , disallow = disallow
    , crawlDelay = Nothing
    , cleanParam = Nothing
    }


{-| Add [crawl-delay](https://moz.com/learn/seo/robotstxt) property to the [`policy`](#policy) entry

    policy
        { userAgent = SingleValue "*"
        , allow = Just (SingleValue "*")
        , disallow = Nothing
        }
        |> withCrawlDelay 10

-}
withCrawlDelay : Int -> PolicyExtra Policy -> PolicyExtra Policy
withCrawlDelay delay extra =
    { extra | crawlDelay = Just delay }


{-| Add [clean param](https://yandex.com/support/webmaster/robot-workings/clean-param.html) property to the [`policy`](#policy) entry

    policy
        { userAgent = SingleValue "*"
        , allow = Just (SingleValue "*")
        , disallow = Nothing
        }
        |> withCleanParam [ { param = "id", path = "/user" } ]

-}
withCleanParam : List CleanParam -> PolicyExtra Policy -> PolicyExtra Policy
withCleanParam param extra =
    { extra | cleanParam = Just param }


{-| Robots.txt input type
-}
type alias Robots =
    { policies : List (PolicyExtra Policy)
    , host : String
    , sitemap : Value
    }


{-| Creates a String with the robots.txt output

    robots
        { sitemap = SingleValue "/sitemap.xml"
        , host = "https://marcodaniels.com"
        , policies =
            [ policy
                { userAgent = SingleValue "*"
                , allow = Just (SingleValue "*")
                , disallow = Nothing
                }
            ]
        }

-}
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


type alias PolicyExtra base =
    { base | crawlDelay : Maybe Int, cleanParam : Maybe (List CleanParam) }


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
