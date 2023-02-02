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
import Users.New exposing (..)



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
    | SignUpPage Users.New.Model


type alias Model =
    { key : Nav.Key
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model key HomePage |> changeRouteTo (Route.fromUrl url)



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | SignUpMsg Users.New.Msg


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
            changeRouteTo (Route.fromUrl url) model

        SignUpMsg toMsg ->
            case model.page of
                SignUpPage toModel ->
                    let
                        ( newModel, topCmd ) =
                            Users.New.update toMsg toModel
                    in
                    ( { model | page = SignUpPage newModel }, Cmd.map SignUpMsg topCmd )

                _ ->
                    ( model, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = HomePage }, Cmd.none )

        Just Home ->
            ( { model | page = HomePage }, Cmd.none )

        Just About ->
            ( { model | page = AboutPage }, Cmd.none )

        Just Help ->
            ( { model | page = HelpPage }, Cmd.none )

        Just Contact ->
            ( { model | page = ContactPage }, Cmd.none )

        Just SignUp ->
            updateWith SignUpPage SignUpMsg Users.New.init model


updateWith : (toPage -> Page) -> (toMsg -> Msg) -> ( toPage, Cmd toMsg ) -> { model | page : Page } -> ( { model | page : Page }, Cmd Msg )
updateWith toPage toMsg toInit model =
    let
        ( toModel, toCmd ) =
            toInit
    in
    ( { model | page = toPage toModel }
    , Cmd.map toMsg toCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        HomePage ->
            viewContent "Home" StaticPages.Home.view

        AboutPage ->
            viewContent "About" StaticPages.About.view

        HelpPage ->
            viewContent "Help" StaticPages.Help.view

        ContactPage ->
            viewContent "Contact" StaticPages.Contact.view

        SignUpPage signupModel ->
            viewModel "SignUp" Users.New.view signupModel SignUpMsg


viewLink : String -> String -> Html msg
viewLink path name =
    a [ class "navbar-item", href path ] [ text name ]


headerView : Html msg
headerView =
    nav [ attribute "aria-label" "main navigation", class "navbar is-black  is-fixed-top", attribute "role" "navigation" ]
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


footerView : Html msg
footerView =
    footer []
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


viewContent : String -> Html msg -> { title : String, body : List (Html msg) }
viewContent title content =
    { title = title ++ " | Ruby on Rails Tutorial Sample App"
    , body =
        [ headerView
        , content
        , footerView
        ]
    }


viewModel : String -> (content -> Html toMsg) -> content -> (toMsg -> msg) -> { title : String, body : List (Html msg) }
viewModel title content model toMsg =
    { title = title ++ " | Ruby on Rails Tutorial Sample App"
    , body =
        [ headerView
        , content model |> Html.map toMsg
        , footerView
        ]
    }
