module StaticPages.Contact exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)


view : Html msg
view =
    div []
        [ h1 [] [ text "Contact" ]
        , p [] [ text "Contact the Ruby on Rails Tutorial about the sample app at the" ]
        , a [ href "https://railstutorial.jp/contact" ] [ text "contact page" ]
        , text "."
        ]
