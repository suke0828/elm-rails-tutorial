module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (..)
import StaticPages.About exposing (..)
import StaticPages.Contact exposing (..)
import StaticPages.Help exposing (..)
import StaticPages.Home exposing (..)
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


type Page
    = HomePage
    | AboutPage
    | HelpPage
    | ContactPage


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key url HomePage, Cmd.none )



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
                    case Route.toRoute (Url.toString url) of
                        Home ->
                            ( { model | page = HomePage }, Nav.pushUrl model.key (Url.toString url) )

                        About ->
                            ( { model | page = AboutPage }, Nav.pushUrl model.key (Url.toString url) )

                        Help ->
                            ( { model | page = HelpPage }, Nav.pushUrl model.key (Url.toString url) )

                        Contact ->
                            ( { model | page = ContactPage }, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            case Route.toRoute (Url.toString url) of
                Home ->
                    ( { model | url = url, page = HomePage }
                    , Cmd.none
                    )

                About ->
                    ( { model | url = url, page = AboutPage }
                    , Cmd.none
                    )

                Help ->
                    ( { model | url = url, page = HelpPage }
                    , Cmd.none
                    )

                Contact ->
                    ( { model | url = url, page = ContactPage }
                    , Cmd.none
                    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Home | Ruby on Rails Tutorial Sample App"
    , body =
        -- Header
        [ nav [ attribute "aria-label" "main navigation", class "navbar is-black  is-fixed-top", attribute "role" "navigation" ]
            [ div [ class "navbar-brand" ]
                [ a [ class "navbar-item", id "logo", href "/" ] [ text "Sample App" ]
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
                    [ viewLink "home" "Home"
                    , viewLink "help" "Help"
                    , viewLink "login" "Log in"
                    ]
                ]
            ]

        -- Container
        , case model.page of
            HomePage ->
                StaticPages.Home.view

            AboutPage ->
                StaticPages.About.view

            HelpPage ->
                StaticPages.Help.view

            ContactPage ->
                StaticPages.Contact.view

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
                    [ li [] [ a [ href "about" ] [ text "About" ] ]
                    , li [] [ a [ href "contact" ] [ text "Contact" ] ]
                    , li [] [ a [ href "https://news.railstutorial.org/" ] [ text "News" ] ]
                    ]
                ]
            ]
        ]
    }


viewLink : String -> String -> Html msg
viewLink path  name =
    a [ class "navbar-item", href path ] [ text name ]
