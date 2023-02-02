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
    , password : String
    , passwordValidation : PasswordStatus
    , passwordAgain : String
    , passwordAgainValidation : PasswordAgainStatus
    , dataBase : DataBase
    }


type alias DataBase =
    { id : Int
    , name : String
    , email : String
    , password : String
    }


type NameStatus
    = EmptyName
    | LongName
    | ValidName


type EmailStatus
    = EmptyEmail
    | LongEmail
    | InvalidRegexEmail
    | DuplicatedEmail
    | ValidEmail


type PasswordStatus
    = EmptyPassword
    | ShortPassword
    | ValidPassword


type PasswordAgainStatus
    = EmptyPasswordAgain
    | NotMatchPassword
    | ValidPasswordAgain



-- Init


init : ( Model, Cmd msg )
init =
    ( { name = "Tom"
      , nameValidation = ValidName
      , email = "aaa@email.jp"
      , emailValidation = ValidEmail
      , password = "123456a"
      , passwordValidation = ValidPassword
      , passwordAgain = "123456a"
      , passwordAgainValidation = ValidPasswordAgain
      , dataBase = userBot
      }
    , Cmd.none
    )


userBot : DataBase
userBot =
    { id = 1, name = "Tom", email = "sss@email.jp", password = "123456a" }



-- Update


type Msg
    = Name String
    | Email String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Name name ->
            ( validate { model | name = name }, Cmd.none )

        Email email ->
            ( validate { model | email = email }, Cmd.none )

        Password password ->
            ( validate { model | password = password }, Cmd.none )

        PasswordAgain password ->
            ( validate { model | passwordAgain = password }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Sign up" ]
        , p [] [ text "This will be a signup page for new users." ]
        , input [ type_ "text", placeholder "Name", value model.name, onInput Name ] []
        , nameError model.nameValidation
        , input [ type_ "text", placeholder "Email", value model.email, onInput Email ] []
        , emailError model.emailValidation
        , input [ type_ "text", placeholder "Password", value model.password, onInput Password ] []
        , passwordError model.passwordValidation
        , input [ type_ "text", placeholder "Re-enter Password", value model.passwordAgain, onInput PasswordAgain ] []
        , passwordAgainError model.passwordAgainValidation
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

            else if model.email == model.dataBase.email then
                DuplicatedEmail

            else
                ValidEmail

        passwordStatus =
            if model.password == "" then
                EmptyPassword

            else if String.length model.password < 6 then
                ShortPassword

            else
                ValidPassword

        passwordAgainStatus =
            if model.passwordAgain == "" then
                EmptyPasswordAgain

            else if model.passwordAgain /= model.password then
                NotMatchPassword

            else
                ValidPasswordAgain
    in
    { model
        | nameValidation = nameStatus
        , emailValidation = emailStatus
        , passwordValidation = passwordStatus
        , passwordAgainValidation = passwordAgainStatus
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

        DuplicatedEmail ->
            div [ style "color" "red" ] [ text "Email be duplicate" ]


passwordError : PasswordStatus -> Html msg
passwordError status =
    case status of
        ValidPassword ->
            div [ style "color" "green" ] [ text "OK" ]

        EmptyPassword ->
            div [ style "color" "red" ] [ text "Password can't be blank" ]

        ShortPassword ->
            div [ style "color" "red" ] [ text "Password must be at least 6 characters long" ]


passwordAgainError : PasswordAgainStatus -> Html msg
passwordAgainError status =
    case status of
        ValidPasswordAgain ->
            div [ style "color" "green" ] [ text "OK" ]

        EmptyPasswordAgain ->
            div [ style "color" "red" ] [ text "Password can't be blank" ]

        NotMatchPassword ->
            div [ style "color" "red" ] [ text "Password do not match" ]
