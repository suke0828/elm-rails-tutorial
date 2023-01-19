module StaticPages.About exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)


view : Html msg
view =
    div []
        [ h1 [] [ text "About" ]
        , p []
            [ a [ href "https://railstutorial.jp/" ] [ text "Ruby on Rails Tutorial" ]
            , text " is a "
            , a [ href "https://railstutorial.jp/#ebook" ] [ text "book" ]
            , text " and "
            , a [ href "https://railstutorial.jp/screencast" ] [ text "screencast" ]
            , text " to teach web development with "
            , a [ href "https://rubyonrails.org/" ] [ text "Ruby on Rails" ]
            , text ". This is the sample application for the tutorial."
            ]
        ]
