module Parts.Button
    exposing
        ( introspection
        , large
        , largeImportant
        , largeImportantWithSpinner
        , largeWithSpinner
        , small
        , smallImportant
        )

import Color
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Hack
import Element.Input
import Introspection
import Parts.Color


introspection : Introspection.Introspection2 msg
introspection =
    { name = "Button"
    , signature = "List (Html.Attribute msg) -> String -> Element.Element msg"
    , description = "Button accept a type, an Html.Attribute msg that can be attribute that return a messages, such as onClick, and a string that is used inside the button."
    , usage = "small [] \"I am a button\""
    , usageResult = common small
    , types = types
    , example = identity
    }


common :
    (List (Element.Attribute msg)
     -> Element.Element msg
     -> Maybe msg
     -> Element.Element msg
    )
    -> Element.Element msg
common type_ =
    type_ [] (Element.text "I am a button") Nothing


types : List ( Element.Element msg, String )
types =
    [ ( common small, "small" )
    , ( common smallImportant, "smallImportant" )
    , ( common large, "large" )
    , ( common largeImportant, "largeImportant" )
    , ( common largeWithSpinner, "largeWithSpinner" )
    , ( common largeImportantWithSpinner, "largeImportantWithSpinner" )
    ]


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


typeToColor : Color -> Color.Color
typeToColor color =
    case color of
        Regular ->
            Parts.Color.white

        Important ->
            Parts.Color.elmOrange

        TextOnRegular ->
            Parts.Color.fontColor

        TextOnImportant ->
            Parts.Color.white


sizeToInt : Size -> Int
sizeToInt size =
    case size of
        SmallSize ->
            16

        LargeSize ->
            32


small : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Element.Element msg
small attributes label onPress =
    component attributes label onPress Small


smallImportant : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Element.Element msg
smallImportant attributes label onPress =
    component attributes label onPress SmallImportant


large : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Element.Element msg
large attributes label onPress =
    component attributes label onPress Large


largeImportant : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Element.Element msg
largeImportant attributes label onPress =
    component attributes label onPress LargeImportant


largeWithSpinner : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Element.Element msg
largeWithSpinner attributes label onPress =
    component attributes label onPress LargeWithSpinner


largeImportantWithSpinner : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Element.Element msg
largeImportantWithSpinner attributes label onPress =
    component attributes label onPress LargeImportantWithSpinner


component : List (Element.Attribute msg) -> Element.Element msg -> Maybe msg -> Type -> Element.Element msg
component attributes label onPress type_ =
    let
        { size, bgColor, spinner } =
            case type_ of
                Small ->
                    { size = SmallSize
                    , bgColor = Regular
                    , spinner = False
                    }

                SmallImportant ->
                    { size = SmallSize
                    , bgColor = Important
                    , spinner = False
                    }

                Large ->
                    { size = LargeSize
                    , bgColor = Regular
                    , spinner = False
                    }

                LargeImportant ->
                    { size = LargeSize
                    , bgColor = Important
                    , spinner = False
                    }

                LargeWithSpinner ->
                    { size = LargeSize
                    , bgColor = Regular
                    , spinner = True
                    }

                LargeImportantWithSpinner ->
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

        sizeInt =
            sizeToInt size

        spinnerElement =
            Element.paragraph [ Element.padding sizeInt ]
                [ Element.Hack.styleElement "@keyframes spinner { to { transform: rotate(360deg); } }"
                , Element.el
                    [ Element.center
                    , Element.Hack.style
                        [ ( "animation", "spinner .6s linear infinite" )
                        ]
                    ]
                  <|
                    Element.text "↻"
                ]
    in
    Element.Input.button
        ([ Element.inFront spinner spinnerElement
         , Element.Background.color <| typeToColor bgColor
         , Element.Font.color <| typeToColor textColor
         , Element.Border.rounded 10
         , Element.Border.width 1
         , Element.Border.color <| typeToColor textColor
         , Element.Hack.style [ ( "transition", "all .3s" ) ]
         , Element.centerY
         , if spinner then
            Element.Hack.style [ ( "cursor", "progress" ) ]
           else
            Element.Hack.style [ ( "cursor", "pointer" ) ]
         , if spinner then
            Element.paddingEach
                { top = sizeInt
                , left = sizeInt * 2 + 10
                , bottom = sizeInt
                , right = sizeInt * 2 - 10
                }
           else
            Element.paddingEach
                { top = sizeInt
                , left = sizeInt * 2
                , bottom = sizeInt
                , right = sizeInt * 2
                }
         ]
            ++ attributes
        )
        { onPress = onPress
        , label = label
        }
