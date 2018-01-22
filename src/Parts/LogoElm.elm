module Parts.LogoElm
    exposing
        ( black
        , blue
        , colorful
        , green
        , introspection
        , lightBlue
        , orange
        , white
        )

import Color
import Color.Convert
import Element
import Introspection
import Svg
import Svg.Attributes


-- INTROSPECTION


introspection : Introspection.Introspection2 msg
introspection =
    { name = "LogoElm"
    , signature = "Size -> Type -> Html.Html msg"
    , description = ""
    , usage = "colorOrange 128"
    , usageResult = orange 128
    , types = types
    , example = identity
    }


types : List ( Element.Element msg, String )
types =
    [ ( orange 64, "orange" )
    , ( green 64, "green" )
    , ( lightBlue 64, "lightBlue" )
    , ( blue 64, "blue" )
    , ( white 64, "white" )
    , ( black 64, "black" )
    , ( colorful 64, "colorful" )
    ]



-- TYPES


orange : Int -> Element.Element msg
orange size =
    component size (Color Orange)


green : Int -> Element.Element msg
green size =
    component size (Color Green)


lightBlue : Int -> Element.Element msg
lightBlue size =
    component size (Color LightBlue)


blue : Int -> Element.Element msg
blue size =
    component size (Color Blue)


white : Int -> Element.Element msg
white size =
    component size (Color White)


black : Int -> Element.Element msg
black size =
    component size (Color Black)


colorful : Int -> Element.Element msg
colorful size =
    component size Colorful



-- TYPES


type Type
    = Color Color
    | Colorful


type alias Size =
    Int


type Color
    = Orange
    | Green
    | LightBlue
    | Blue
    | White
    | Black



-- INTERNAL


ratio : Float
ratio =
    -- Width / Height
    1


cssRgb : Color -> Color.Color
cssRgb color =
    case color of
        Orange ->
            Color.rgb 0xF0 0xAD 0x00

        Green ->
            Color.rgb 0x7F 0xD1 0x3B

        LightBlue ->
            Color.rgb 0x60 0xB5 0xCC

        Blue ->
            Color.rgb 0x5A 0x63 0x78

        White ->
            Color.rgb 0xFF 0xFF 0xFF

        Black ->
            Color.rgb 0x00 0x00 0x00


component : Size -> Type -> Element.Element msg
component height type_ =
    let
        f =
            Svg.Attributes.fill

        d =
            Svg.Attributes.d

        p =
            Svg.path

        c =
            case type_ of
                Colorful ->
                    { c1 = cssRgb Orange
                    , c2 = cssRgb Green
                    , c3 = cssRgb LightBlue
                    , c4 = cssRgb Blue
                    }

                Color c ->
                    { c1 = cssRgb c
                    , c2 = cssRgb c
                    , c3 = cssRgb c
                    , c4 = cssRgb c
                    }
    in
    Element.html
        (Svg.svg
            [ Svg.Attributes.version "1"
            , Svg.Attributes.viewBox "0 0 323 323"
            , Svg.Attributes.height <| toString height
            , Svg.Attributes.width <| toString <| floor <| toFloat height * ratio
            ]
            [ p [ f (Color.Convert.colorToHex c.c1), d "M162 153l70-70H92zm94 94l67 67V179z" ] []
            , p [ f (Color.Convert.colorToHex c.c2), d "M9 0l70 70h153L162 0zm238 85l77 76-77 77-76-77z" ] []
            , p [ f (Color.Convert.colorToHex c.c3), d "M323 144V0H180zm-161 27L9 323h305z" ] []
            , p [ f (Color.Convert.colorToHex c.c4), d "M153 162L0 9v305z" ] []
            ]
        )
