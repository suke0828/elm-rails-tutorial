module Route exposing (..)

import Browser.Dom exposing (Error(..))
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, top)


type Route
    = Home
    | About
    | Help
    | Contact
    | SignUp


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map About (s "about")
        , map Help (s "help")
        , map Contact (s "contact")
        , map SignUp (s "signup")
        ]


toRoute : String -> Route
toRoute string =
    case Url.fromString string of
        Nothing ->
            Home

        Just url ->
            Maybe.withDefault Home (parse routeParser url)


fromUrl : Url -> Maybe Route
fromUrl url =
    Url.Parser.parse routeParser url
