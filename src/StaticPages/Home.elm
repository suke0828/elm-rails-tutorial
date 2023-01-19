module StaticPages.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div [ class "container hero is-medium has-background-light" ]
        [ div [ class "center hero-body" ]
            [ h1 [ class "title is-1" ] [ text "Welcome to the Sample App" ]
            , h2 [ class "subtitle is-3" ]
                [ text "This is the home page for the "
                , a [ href "https://railstutorial.jp/" ] [ text "Ruby on Rails Tutorial" ]
                , text " sample application"
                ]
            , a [ class "button is-link", href "#" ] [ text "Sign up now!" ]
            ]
        , a [ href "https://rubyonrails.org/" ] [ img [ src "assets/images/rails.svg", alt "Rails Logo", width 200 ] [] ]
        ]


viewLink : String -> Html msg
viewLink path =
    a [ class "navbar-item", href path ] [ text path ]
