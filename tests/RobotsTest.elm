module RobotsTest exposing (..)

import Expect exposing (equal)
import Robots exposing (Path, robots)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "robots"
        [ test "robots file with one policy & single paths" <|
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
        ]
