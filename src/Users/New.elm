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
        , viewInput "text" "Name" model.name Name
        , nameError model.nameValidation
        , viewInput "text" "Email" model.email Email
        , emailError model.emailValidation
        , viewInput "text" "Password" model.password Password
        , passwordError model.passwordValidation
        , viewInput "text" "Re-enter Password" model.passwordAgain PasswordAgain
        , passwordAgainError model.passwordAgainValidation
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []



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


viewValidMsg : Html msg
viewValidMsg =
    div [ style "color" "green" ] [ text "OK" ]


viewInvalidMsg : String -> Html msg
viewInvalidMsg errorMsg =
    div [ style "color" "red" ] [ text errorMsg ]


viewBlankMsg : String -> Html msg
viewBlankMsg msg =
    div [ style "color" "red" ] [ text (msg ++ " can't be blank") ]


nameError : NameStatus -> Html msg
nameError status =
    case status of
        ValidName ->
            viewValidMsg

        EmptyName ->
            viewBlankMsg "Name"

        LongName ->
            viewInvalidMsg "Name should not be too long"


emailError : EmailStatus -> Html msg
emailError status =
    case status of
        ValidEmail ->
            viewValidMsg

        EmptyEmail ->
            viewBlankMsg "Email"

        LongEmail ->
            viewInvalidMsg "Email should not be too long"

        InvalidRegexEmail ->
            viewInvalidMsg "Email be invalid"

        DuplicatedEmail ->
            viewInvalidMsg "Email be duplicate"


passwordError : PasswordStatus -> Html msg
passwordError status =
    case status of
        ValidPassword ->
            viewValidMsg

        EmptyPassword ->
            viewBlankMsg "Password"

        ShortPassword ->
            viewInvalidMsg "Password must be at least 6 characters long"


passwordAgainError : PasswordAgainStatus -> Html msg
passwordAgainError status =
    case status of
        ValidPasswordAgain ->
            viewValidMsg

        EmptyPasswordAgain ->
            viewBlankMsg "Password confirm"

        NotMatchPassword ->
            viewInvalidMsg "Password do not match"
