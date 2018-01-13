module Components.Color exposing (Type(..), component, introspection)

import Html
import Html.Attributes
import Introspection


introspection : Introspection.Introspection msg Type
introspection =
    let
        example type_ =
            Html.div
                [ Html.Attributes.style
                    [ ( "width", "120px" )
                    , ( "height", "40px" )
                    , ( "background-color", component type_ )
                    , ( "color", "white" )
                    , ( "padding", "10px" )
                    , ( "text-align", "center" )

                    -- , ( "text-align", "left" )
                    , ( "font-family", "monospace" )
                    , ( "font-size", "18px" )
                    ]
                ]
                [ Html.text <| component type_ ]
    in
    { types = [ ElmOrange, LightOrange, FontColor ]
    , signature = "Type -> String"
    , description = ""
    , usage = "ElmOrange"
    , usageResult = example ElmOrange
    , name = "Colors"
    , example = example
    }


type Type
    = ElmOrange
    | LightOrange
    | FontColor


component : Type -> String
component type_ =
    case type_ of
        ElmOrange ->
            "#f0ad00"

        LightOrange ->
            "#f8ca83"

        FontColor ->
            "#777"
