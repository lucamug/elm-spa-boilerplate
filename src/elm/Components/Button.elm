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
        { size, bgColor, textColor, class } =
            case type_ of
                Small ->
                    { size = SmallSize
                    , bgColor = Regular
                    , textColor = TextOnRegular
                    , class = ""
                    }

                Small_Important ->
                    { size = SmallSize
                    , bgColor = Important
                    , textColor = TextOnImportant
                    , class = ""
                    }

                Large ->
                    { size = LargeSize
                    , bgColor = Regular
                    , textColor = TextOnRegular
                    , class = ""
                    }

                Large_Important ->
                    { size = LargeSize
                    , bgColor = Important
                    , textColor = TextOnImportant
                    , class = ""
                    }

                Large_With_Spinner ->
                    { size = LargeSize
                    , bgColor = Regular
                    , textColor = TextOnRegular
                    , class = "spinner"
                    }

                Large_Important_With_Spinner ->
                    { size = LargeSize
                    , bgColor = Important
                    , textColor = TextOnImportant
                    , class = "spinner spinner-white"
                    }
    in
    Html.button
        ([ Html.Attributes.class class
         , Html.Attributes.style
            [ ( "background-color", colorToString bgColor )
            , ( "height", sizeToString size )
            , ( "color", colorToString textColor )
            ]
         ]
            ++ msgs
        )
        [ Html.text string ]
