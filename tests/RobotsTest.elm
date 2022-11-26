module RobotsTest exposing (..)

import Expect exposing (equal)
import Robots exposing (Value, policy, robots, withCrawlDelay)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "robots"
        [ test "one policy & single paths" <|
            \() ->
                robots
                    { sitemap = Robots.SingleValue "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ policy
                            { userAgent = Robots.SingleValue "*"
                            , allow = Just (Robots.SingleValue "*")
                            , disallow = Nothing
                            }
                        ]
                    }
                    |> equal
                        """User-agent: *
Allow: *

Sitemap: /sitemap.xml

Host: https://marcodaniels.com"""
        , test "multiple policies & disallow" <|
            \() ->
                robots
                    { sitemap = Robots.SingleValue "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ policy { userAgent = Robots.SingleValue "Googlebot", allow = Nothing, disallow = Just (Robots.SingleValue "/not-here-bot") }
                        , policy { userAgent = Robots.SingleValue "*", allow = Just (Robots.SingleValue "/"), disallow = Nothing }
                        ]
                    }
                    |> equal
                        """User-agent: Googlebot
Disallow: /not-here-bot

User-agent: *
Allow: /

Sitemap: /sitemap.xml

Host: https://marcodaniels.com"""
        , test "multiple paths" <|
            \() ->
                robots
                    { sitemap = Robots.MultiValue [ "/en/sitemap.xml", "/pt/sitemap.xml" ]
                    , host = "https://marcodaniels.com"
                    , policies = []
                    }
                    |> equal
                        """Sitemap: /en/sitemap.xml
Sitemap: /pt/sitemap.xml

Host: https://marcodaniels.com"""
        , test "multiple user agent" <|
            \() ->
                robots
                    { sitemap = Robots.SingleValue "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ policy
                            { userAgent = Robots.MultiValue [ "Googlebot", "AdsBot-Google" ]
                            , allow = Nothing
                            , disallow = Just (Robots.SingleValue "/")
                            }
                        ]
                    }
                    |> equal
                        """User-agent: Googlebot
User-agent: AdsBot-Google
Disallow: /

Sitemap: /sitemap.xml

Host: https://marcodaniels.com"""
        , test "multiple disallow items" <|
            \() ->
                robots
                    { sitemap = Robots.SingleValue "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ policy
                            { userAgent = Robots.SingleValue "*"
                            , allow = Nothing
                            , disallow = Just (Robots.MultiValue [ "/admin", "/not-allow" ])
                            }
                        ]
                    }
                    |> equal
                        """User-agent: *
Disallow: /admin
Disallow: /not-allow

Sitemap: /sitemap.xml

Host: https://marcodaniels.com"""
        , test "policy with crawl delay" <|
            \() ->
                robots
                    { sitemap = Robots.SingleValue "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ policy
                            { userAgent = Robots.SingleValue "*"
                            , allow = Just (Robots.SingleValue "*")
                            , disallow = Nothing
                            } |> withCrawlDelay 10
                        ]
                    }
                    |> equal
                        """User-agent: *
Allow: *
Crawl-delay: 10

Sitemap: /sitemap.xml

Host: https://marcodaniels.com"""
        ]
