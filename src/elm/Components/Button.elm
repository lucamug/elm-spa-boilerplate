module Components.Button exposing (Type(..), component, introspection)

import Components.Color
import Html
import Html.Attributes
import Introspection


type Msg
    = NoOp


introspection : Introspection.Introspection msg Type
introspection =
    { name = "Buttons"
    , signature = "List (Html.Attribute msg) -> String -> Type -> Html.Html msg"
    , description = "Button accept a type, an Html.Attribute msg that can be attribute that return a messages, such as onClick, and a string that is used inside the button."
    , usage = """[] "I am a button" Large"""
    , usageResult = component [] "I am a button" Large
    , types = [ Small, Small_Important, Large, Large_Important, Large_With_Spinner, Large_Important_With_Spinner ]
    , example = component [] "I'm a button"
    }


type Type
    = Small
    | Small_Important
    | Large
    | Large_Important
    | Large_With_Spinner
    | Large_Important_With_Spinner


type Color
    = Regular
    | Important
    | TextOnRegular
    | TextOnImportant


type Size
    = SmallSize
    | LargeSize


colorToString : Color -> String
colorToString color =
    case color of
        Regular ->
            "white"

        Important ->
            Components.Color.component Components.Color.Elm_Orange

        TextOnRegular ->
            Components.Color.component Components.Color.Font_Color

        TextOnImportant ->
            "white"


sizeToString : Size -> String
sizeToString size =
    case size of
        SmallSize ->
            "32px"

        LargeSize ->
            "64px"


component : List (Html.Attribute msg) -> String -> Type -> Html.Html msg
component msgs string type_ =
    let
        { size, color, textColor, extraClass } =
            case type_ of
                Small ->
                    { size = sizeToString SmallSize
                    , color = colorToString Regular
                    , textColor = colorToString TextOnRegular
                    , extraClass = ""
                    }

                Small_Important ->
                    { size = sizeToString SmallSize
                    , color = colorToString Important
                    , textColor = colorToString TextOnImportant
                    , extraClass = ""
                    }

                Large ->
                    { size = sizeToString LargeSize
                    , color = colorToString Regular
                    , textColor = colorToString TextOnRegular
                    , extraClass = ""
                    }

                Large_Important ->
                    { size = sizeToString LargeSize
                    , color = colorToString Important
                    , textColor = colorToString TextOnImportant
                    , extraClass = ""
                    }

                Large_With_Spinner ->
                    { size = sizeToString LargeSize
                    , color = colorToString Regular
                    , textColor = colorToString TextOnRegular
                    , extraClass = "spinner"
                    }

                Large_Important_With_Spinner ->
                    { size = sizeToString LargeSize
                    , color = colorToString Important
                    , textColor = colorToString TextOnImportant
                    , extraClass = "spinner spinner-white"
                    }
    in
    Html.button
        ([ Html.Attributes.class extraClass
         , Html.Attributes.style
            [ ( "background-color", color )
            , ( "height", size )
            , ( "color", textColor )
            ]
         ]
            ++ msgs
        )
        [ Html.text string ]
