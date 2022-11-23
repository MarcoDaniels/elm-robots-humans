module RobotsTest exposing (..)

import Expect exposing (equal)
import Robots exposing (Path, robots)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "robots"
        [ test "one policy & single paths" <|
            \() ->
                robots
                    { sitemap = Robots.SinglePath "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ { userAgent = "*"
                          , allow = Just (Robots.SinglePath "*")
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
                    { sitemap = Robots.SinglePath "/sitemap.xml"
                    , host = "https://marcodaniels.com"
                    , policies =
                        [ { userAgent = "Googlebot", allow = Nothing, disallow = Just (Robots.SinglePath "/not-here-bot") }
                        , { userAgent = "*", allow = Just (Robots.SinglePath "/"), disallow = Nothing }
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
                    { sitemap = Robots.MultiPath [ "/en/sitemap.xml", "/pt/sitemap.xml" ]
                    , host = "https://marcodaniels.com"
                    , policies = []
                    }
                    |> equal
                        """Sitemap: /en/sitemap.xml
Sitemap: /pt/sitemap.xml
Host: https://marcodaniels.com"""
        ]
