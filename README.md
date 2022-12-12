# elm-robots-humans

`elm-robots-humans` allows you to write your website's [`robots.txt`](https://moz.com/learn/seo/robotstxt)
and [`humans.txt`](https://humanstxt.org/) files as an output string in a structured and typed manner.

Example for `robots.txt`:

```elm
import Robots

robots: String
robots =
    Robots.robots
        { sitemap = Robots.SingleValue "/sitemap.xml"
        , host = "https://marcodaniels.com"
        , policies =
            [ Robots.policy
                { userAgent = Robots.SingleValue "*"
                , allow = Just (Robots.SingleValue "*")
                , disallow = Nothing
                }
            ]
        }
```

Example for `humans.txt`

```elm
import Humans

humans: String
humans =
    Humans.humans
        [ { headline = "Team"
          , content = [ "Engineer: Marco Martins" ]
          }
        , { headline = "Technology"
          , content = [ "elm, terraform, nix" ]
          }
        ]
```