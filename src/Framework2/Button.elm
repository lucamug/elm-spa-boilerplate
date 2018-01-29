module Framework2.Button
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
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Hack as Hack
import Element.Input as Input
import Framework2.Color
import Framework2.Spinner
import Styleguide


-- INTROSPECTION


introspection : Styleguide.Data msg
introspection =
    { name = "Button"
    , signature = "String -> Maybe msg -> Element msg"
    , description = "Buttons accept a string and a Maybe message."
    , usage = """small "I am an usage example" Nothing"""
    , usageResult = small "I am an usage example" Nothing
    , boxed = False
    , types =
        [ ( "Buttons"
          , [ ( small "Button" Nothing, "small" )
            , ( large "Button" Nothing, "large" )
            , ( largeWithSpinner "Button" Nothing, "largeWithSpinner" )
            , ( smallImportant "Button" Nothing, "smallImportant" )
            , ( largeImportant "Button" Nothing, "largeImportant" )
            , ( largeImportantWithSpinner "Button" Nothing, "largeImportantWithSpinner" )
            ]
          )
        ]
    }



-- TYPES


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
            Framework2.Color.white

        Important ->
            Framework2.Color.elmOrange

        TextOnRegular ->
            Framework2.Color.font

        TextOnImportant ->
            Framework2.Color.white


sizeToInt : Size -> Int
sizeToInt size =
    case size of
        SmallSize ->
            16

        LargeSize ->
            32


small : String -> Maybe msg -> Element.Element msg
small label onPress =
    part label onPress Small


smallImportant : String -> Maybe msg -> Element.Element msg
smallImportant label onPress =
    part label onPress SmallImportant


large : String -> Maybe msg -> Element.Element msg
large label onPress =
    part label onPress Large


largeImportant : String -> Maybe msg -> Element.Element msg
largeImportant label onPress =
    part label onPress LargeImportant


largeWithSpinner : String -> Maybe msg -> Element.Element msg
largeWithSpinner label onPress =
    part label onPress LargeWithSpinner


largeImportantWithSpinner : String -> Maybe msg -> Element.Element msg
largeImportantWithSpinner label onPress =
    part label onPress LargeImportantWithSpinner


part : String -> Maybe msg -> Type -> Element.Element msg
part label onPress type_ =
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
            case bgColor of
                Regular ->
                    Element.paragraph [ Element.padding <| sizeInt - 3 ] [ Framework2.Spinner.black 28 ]

                _ ->
                    Element.paragraph [ Element.padding <| sizeInt - 3 ] [ Framework2.Spinner.white 28 ]
    in
    Input.button
        [ inFront spinner spinnerElement
        , Background.color <| typeToColor bgColor
        , Font.color <| typeToColor textColor
        , Border.rounded 10
        , Border.width 1
        , Border.color <| typeToColor textColor
        , Hack.style [ ( "transition", "all .3s" ) ]
        , centerY
        , if spinner then
            Hack.style [ ( "cursor", "progress" ) ]
          else
            Hack.style [ ( "cursor", "pointer" ) ]
        , if spinner then
            paddingEach
                { top = sizeInt
                , left = sizeInt * 2 + 10
                , bottom = sizeInt
                , right = sizeInt * 2 - 10
                }
          else
            paddingEach
                { top = sizeInt
                , left = sizeInt * 2
                , bottom = sizeInt
                , right = sizeInt * 2
                }
        ]
        { onPress = onPress
        , label = text label
        }
