module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "URL Interceptor"
    , body =
        -- Header
        [ nav [ attribute "aria-label" "main navigation", class "navbar is-black  is-fixed-top", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", id "logo", href "index.html" ] [ text "Sample App" ]
                , div [ class "navbar-burger", attribute "data-target" "navMenu" ]
                    [ span []
                        []
                    , span []
                        []
                    , span []
                        []
                    ]
                ]
            , div [ class "navbar-menu" ]
                [ div [ class "navbar-start" ] []
                , div [ class "navbar-end" ]
                    [ viewLink "Home"
                    , viewLink "Help"
                    , viewLink "Login"
                    ]
                ]
            ]

        -- Container
        , div [ class "container hero is-medium has-background-light" ]
            [ div [ class "center hero-body" ]
                [ h1 [ class "title is-1" ] [ text "Welcome to the Sample App" ]
                , h2 [ class "subtitle is-3" ]
                    [ text "This is the home page for the "
                    , a [ href "https://railstutorial.jp/" ] [ text "Ruby on Rails Tutorial" ]
                    , text " sample application"
                    ]
                , a [ class "button is-link", href "#" ] [ text "Sign up now!" ]
                ]
            ]
        , a [ href "https://rubyonrails.org/" ] [ img [ src "assets/images/rails.svg", alt "Rails Logo", width 200 ] [] ]

        -- Footer
        , footer []
            [ small []
                [ text "The "
                , a [ href "https://railstutorial.jp/" ] [ text "Ruby on Rails Tutorial" ]
                , text " By "
                , a [ href "https://www.michaelhartl.com/" ] [ text "Michael Hartl" ]
                ]
            , nav []
                [ ul []
                    [ li [] [ a [ href "#" ] [ text "About" ] ]
                    , li [] [ a [ href "#" ] [ text "Contact" ] ]
                    , li [] [ a [ href "https://news.railstutorial.org/" ] [ text "News" ] ]
                    ]
                ]
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    a [ class "navbar-item", href path ] [ text path ]
