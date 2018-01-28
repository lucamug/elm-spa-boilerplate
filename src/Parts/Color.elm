module Parts.Color
    exposing
        ( background
        , black
        , elmOrange
        , font
        , introspection
        , lightGray
        , lightOrange
        , onBackground
        , red
        , white
        )

import Color
import Color.Accessibility
import Color.Convert
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Styleguide


-- INTROSPECTION


introspection : Styleguide.Data msg
introspection =
    { name = "Color"
    , signature = "Color.Color"
    , description = "List of colors used in the app."
    , usage = "elmOrange"
    , usageResult = usageWrapper elmOrange
    , boxed = True
    , types =
        [ ( "Colors"
          , [ ( usageWrapper black, "black" )
            , ( usageWrapper elmOrange, "elmOrange" )
            , ( usageWrapper font, "font" )
            , ( usageWrapper background, "background" )
            , ( usageWrapper lightGray, "lightGray" )
            , ( usageWrapper lightOrange, "lightOrange" )
            , ( usageWrapper red, "red" )
            , ( usageWrapper white, "white" )
            ]
          )
        ]
    }


usageWrapper : Color.Color -> Element.Element msg
usageWrapper color =
    Element.el
        [ Background.color color
        , width <| px 100
        , height <| px 100
        , padding 10
        , Border.rounded 5
        , Font.color <| Maybe.withDefault Color.black <| Color.Accessibility.maximumContrast color [ Color.white, Color.black ]
        ]
    <|
        Element.text <|
            Color.Convert.colorToHex color



-- TYPES


maximumContrast : Color.Color -> Color.Color
maximumContrast color =
    Maybe.withDefault font <| Color.Accessibility.maximumContrast color [ white, font ]


elmOrange : Color.Color
elmOrange =
    Color.rgb 0xF0 0xAD 0x00


lightOrange : Color.Color
lightOrange =
    Color.rgb 0xF8 0xCA 0x83


lightGray : Color.Color
lightGray =
    Color.rgb 0xEE 0xEE 0xEE


font : Color.Color
font =
    Color.rgb 0x33 0x33 0x33


background : Color.Color
background =
    Color.rgb 0x65 0x8D 0xB5


onBackground : Color.Color
onBackground =
    maximumContrast font


black : Color.Color
black =
    Color.rgb 0x00 0x00 0x00


white : Color.Color
white =
    Color.rgb 0xFF 0xFF 0xFF


red : Color.Color
red =
    Color.rgb 0xDD 0x00 0x00
