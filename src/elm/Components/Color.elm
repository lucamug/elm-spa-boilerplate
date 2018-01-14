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
                    , ( "text-align", "left" )
                    , ( "font-family", "monospace" )
                    , ( "font-size", "18px" )
                    ]
                ]
                [ Html.text <| component type_ ]
    in
    { name = "Colors"
    , signature = "Type -> String"
    , description = "List of colors used in the app."
    , usage = "Elm_Orange"
    , usageResult = example Elm_Orange
    , types = [ Elm_Orange, Light_Orange, Font_Color ]
    , example = example
    }


type Type
    = Elm_Orange
    | Light_Orange
    | Font_Color


component : Type -> String
component type_ =
    case type_ of
        Elm_Orange ->
            "#f0ad00"

        Light_Orange ->
            "#f8ca83"

        Font_Color ->
            "#777"
