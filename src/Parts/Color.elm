module Parts.Color
    exposing
        ( black
        , elmOrange
        , fontColor
        , introspection
        , lightGray
        , lightOrange
        , red
        , white
        )

import Color
import Color.Accessibility
import Color.Convert
import Element
import Element.Background
import Element.Border
import Element.Font
import Introspection


-- INTROSPECTION


introspection : Introspection.Introspection msg
introspection =
    { name = "Color"
    , signature = "Color.Color"
    , description = "List of colors used in the app."
    , usage = "elmOrange"
    , usageResult = usageWrapper elmOrange
    , boxed = True
    , types =
        [ ( usageWrapper black, "black" )
        , ( usageWrapper elmOrange, "elmOrange" )
        , ( usageWrapper fontColor, "fontColor" )
        , ( usageWrapper lightGray, "lightGray" )
        , ( usageWrapper lightOrange, "lightOrange" )
        , ( usageWrapper red, "red" )
        , ( usageWrapper white, "white" )
        ]
    }


usageWrapper : Color.Color -> Element.Element msg
usageWrapper color =
    Element.el
        [ Element.Background.color color
        , Element.width <| Element.px 100
        , Element.height <| Element.px 100
        , Element.padding 10
        , Element.Border.rounded 5
        , Element.Font.color <| Maybe.withDefault Color.black <| Color.Accessibility.maximumContrast color [ Color.white, Color.black ]
        ]
    <|
        Element.text <|
            Color.Convert.colorToHex color



-- TYPES


elmOrange : Color.Color
elmOrange =
    Color.rgb 0xF0 0xAD 0x00


lightOrange : Color.Color
lightOrange =
    Color.rgb 0xF8 0xCA 0x83


lightGray : Color.Color
lightGray =
    Color.rgb 0xEE 0xEE 0xEE


fontColor : Color.Color
fontColor =
    Color.rgb 0x33 0x33 0x33


black : Color.Color
black =
    Color.rgb 0x00 0x00 0x00


white : Color.Color
white =
    Color.rgb 0xFF 0xFF 0xFF


red : Color.Color
red =
    Color.rgb 0xDD 0x00 0x00
