module StaticPages.Help exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "Help" ]
        , p [] [ text "Get help on the Ruby on Rails Tutorial at the" ]
        , a [ href "https://railstutorial.jp/help" ] [ text "Rails Tutorial help page" ]
        , text ". To get help on this sample app, see the "
        , a [ href "https://railstutorial.jp/#ebook" ] [ em [] [ text "Ruby on Rails Tutorial" ], text " book" ]
        ]
