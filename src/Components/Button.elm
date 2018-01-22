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
        { size, bgColor, spinner } =
            case type_ of
                Small ->
                    { size = SmallSize
                    , bgColor = Regular
                    , spinner = False
                    }

                Small_Important ->
                    { size = SmallSize
                    , bgColor = Important
                    , spinner = False
                    }

                Large ->
                    { size = LargeSize
                    , bgColor = Regular
                    , spinner = False
                    }

                Large_Important ->
                    { size = LargeSize
                    , bgColor = Important
                    , spinner = False
                    }

                Large_With_Spinner ->
                    { size = LargeSize
                    , bgColor = Regular
                    , spinner = True
                    }

                Large_Important_With_Spinner ->
                    { size = LargeSize
                    , bgColor = Important
                    , spinner = True
                    }

        textColor =
            case bgColor of
                Regular ->
                    TextOnRegular

                _ ->
                    TextOnImportant
    in
    Html.button
        ([ Html.Attributes.style
            [ ( "background-color", colorToString bgColor )
            , ( "height", sizeToString size )
            , ( "color", colorToString textColor )
            , ( "border-radius", "10px" )
            , ( "padding", "0 60px" )
            , ( "position", "relative" )
            , ( "transition", "all .3s" )
            , if spinner then
                ( "cursor", "progress" )
              else
                ( "cursor", "pointer" )
            , if spinner then
                ( "padding", "0 80px 0 40px" )
              else
                ( "padding", "0 60px" )
            ]
         ]
            ++ msgs
        )
        [ Html.node "style" [] [ Html.text "@keyframes spinner { to { transform: rotate(360deg);}}" ]
        , Html.text string
        , if spinner then
            -- This is a pure css spinner
            Html.div
                [ Html.Attributes.style
                    [ ( "box-sizing", "border-box" )
                    , ( "position", "absolute" )
                    , ( "top", "50%" )
                    , ( "right", "24px" )
                    , ( "width", "20px" )
                    , ( "height", "20px" )
                    , ( "margin-top", "-10px" )
                    , ( "margin-left", "-10px" )
                    , ( "border-radius", "50%" )
                    , ( "border", "2px solid transparent" )
                    , ( "border-top-color", colorToString textColor )
                    , ( "animation", "spinner .6s linear infinite" )
                    ]
                ]
                [ Html.text "" ]
          else
            Html.text ""
        ]
