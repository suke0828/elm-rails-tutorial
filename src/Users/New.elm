module Users.New exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div []
        [ h1 [] [ text "Sign up" ]
        , p [] [ text "This will be a signup page for new users." ]
        ]
