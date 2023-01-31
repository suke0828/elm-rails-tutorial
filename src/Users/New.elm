module Users.New exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Regex



-- Model


type alias Model =
    { name : String
    , nameValidation : NameStatus
    , email : String
    , emailValidation : EmailStatus
    }


type NameStatus
    = EmptyName
    | LongName
    | ValidName


type EmailStatus
    = EmptyEmail
    | LongEmail
    | InvalidRegexEmail
    | ValidEmail



-- Init


init : ( Model, Cmd msg )
init =
    ( { name = "Tom"
      , nameValidation = ValidName
      , email = "aaa@email.jp"
      , emailValidation = ValidEmail
      }
    , Cmd.none
    )



-- Update


type Msg
    = Name String
    | Email String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Name name ->
            ( validate { model | name = name }, Cmd.none )

        Email email ->
            ( validate { model | email = email }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Sign up" ]
        , p [] [ text "This will be a signup page for new users." ]
        , input [ type_ "text", placeholder "Name", value model.name, onInput Name ] []
        , nameError model.nameValidation
        , input [ type_ "text", placeholder "Email", value model.email, onInput Email ] []
        , emailError model.emailValidation
        ]



-- Validation


validate : Model -> Model
validate model =
    let
        nameStatus =
            if model.name == "" then
                EmptyName

            else if String.length model.name > 50 then
                LongName

            else
                ValidName

        emailStatus =
            if model.email == "" then
                EmptyEmail

            else if String.length model.email > 255 then
                LongEmail

            else if Regex.contains regexValidate model.email == False then
                InvalidRegexEmail

            else
                ValidEmail
    in
    { model
        | nameValidation = nameStatus
        , emailValidation = emailStatus
    }


validAddresses : String
validAddresses =
    "[\\w+\\-.]+@[a-z\\d\\-]+(\\.[a-z\\d\\-]+)*\\.[a-z]+"


regexValidate : Regex.Regex
regexValidate =
    Maybe.withDefault Regex.never <| Regex.fromString validAddresses



-- Error Message


nameError : NameStatus -> Html msg
nameError status =
    case status of
        ValidName ->
            div [ style "color" "green" ] [ text "OK" ]

        EmptyName ->
            div [ style "color" "red" ] [ text "Name can't be blank" ]

        LongName ->
            div [ style "color" "red" ] [ text "Name should not be too long" ]


emailError : EmailStatus -> Html msg
emailError status =
    case status of
        ValidEmail ->
            div [ style "color" "green" ] [ text "OK" ]

        EmptyEmail ->
            div [ style "color" "red" ] [ text "Email can't be blank" ]

        LongEmail ->
            div [ style "color" "red" ] [ text "Email should not be too long" ]

        InvalidRegexEmail ->
            div [ style "color" "red" ] [ text "Email be invalid" ]
