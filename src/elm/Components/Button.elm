module Components.Button exposing (Type(..), component, introspection)

import Components.Color
import Html
import Html.Attributes
import Introspection


type Msg
    = NoOp


introspection : Introspection.Introspection msg Type
introspection =
    let
        example type_ =
            component type_ (Html.Attributes.attribute "data" "") "I'm a button"
    in
    { types = [ Small, SmallImportant, Large, LargeImportant, LargeWithSpinner, LargeImportantWithSpinner ]
    , signature = "Type -> Html.Attribute msg -> String -> Html.Html msg"
    , description = "Button accept a type, an Html.Attribute msg that can be attribute that return a messages, such as onClick, and a string that is used inside the button."
    , usage = """Large (Html.Attributes.attribute "data" "") "I'm a button\""""
    , usageResult = example Large
    , name = "Buttons"
    , example = example
    }


type Type
    = Small
    | SmallImportant
    | Large
    | LargeImportant
    | LargeWithSpinner
    | LargeImportantWithSpinner


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
            Components.Color.component Components.Color.ElmOrange

        TextOnRegular ->
            Components.Color.component Components.Color.FontColor

        TextOnImportant ->
            "white"


sizeToString : Size -> String
sizeToString size =
    case size of
        SmallSize ->
            "32px"

        LargeSize ->
            "64px"


component : Type -> Html.Attribute msg -> String -> Html.Html msg
component type_ msg string =
    let
        { size, color, textColor, extraClass } =
            case type_ of
                Small ->
                    { size = sizeToString SmallSize
                    , color = colorToString Regular
                    , textColor = colorToString TextOnRegular
                    , extraClass = ""
                    }

                SmallImportant ->
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

                LargeImportant ->
                    { size = sizeToString LargeSize
                    , color = colorToString Important
                    , textColor = colorToString TextOnImportant
                    , extraClass = ""
                    }

                LargeWithSpinner ->
                    { size = sizeToString LargeSize
                    , color = colorToString Regular
                    , textColor = colorToString TextOnRegular
                    , extraClass = "spinner"
                    }

                LargeImportantWithSpinner ->
                    { size = sizeToString LargeSize
                    , color = colorToString Important
                    , textColor = colorToString TextOnImportant
                    , extraClass = "spinner spinner-white"
                    }
    in
    Html.button
        [ Html.Attributes.class extraClass
        , Html.Attributes.style
            [ ( "background-color", color )
            , ( "height", size )
            , ( "color", textColor )
            ]
        , msg
        ]
        [ Html.text string ]
