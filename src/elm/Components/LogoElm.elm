module Components.LogoElm exposing (Color(..), Type(..), component, introspection)

import Html
import Introspection
import Svg
import Svg.Attributes


-- Original SVG: https://github.com/elm-lang/svg/blob/master/examples/Logo.elm


introspection : Introspection.Introspection msg Type
introspection =
    { name = "Logo Elm"
    , signature = "Size -> Type -> Html.Html msg"
    , description = ""
    , usage = "128 (Color Orange)"
    , usageResult = component 128 (Color Orange)
    , types = [ Colorful, Color Orange, Color Green, Color Light_Blue, Color Blue, Color White, Color Black ]
    , example = component 64
    }


type Type
    = Color Color
    | Colorful


type alias Size =
    Int


type Color
    = Orange
    | Green
    | Light_Blue
    | Blue
    | White
    | Black


ratio : Float
ratio =
    -- Width / Height
    1


cssRgb : Color -> String
cssRgb color =
    case color of
        Orange ->
            "#f0ad00"

        Green ->
            "#7fd13b"

        Light_Blue ->
            "#60b5cc"

        Blue ->
            "#5a6378"

        White ->
            "#fff"

        Black ->
            "#000"


component : Size -> Type -> Html.Html msg
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
                    , c3 = cssRgb Light_Blue
                    , c4 = cssRgb Blue
                    }

                Color c ->
                    { c1 = cssRgb c
                    , c2 = cssRgb c
                    , c3 = cssRgb c
                    , c4 = cssRgb c
                    }
    in
    Svg.svg
        [ Svg.Attributes.version "1"
        , Svg.Attributes.viewBox "0 0 323 323"
        , Svg.Attributes.height <| toString height
        , Svg.Attributes.width <| toString <| floor <| toFloat height * ratio
        ]
        [ p [ f c.c1, d "M162 153l70-70H92zm94 94l67 67V179z" ] []
        , p [ f c.c2, d "M9 0l70 70h153L162 0zm238 85l77 76-77 77-76-77z" ] []
        , p [ f c.c3, d "M323 144V0H180zm-161 27L9 323h305z" ] []
        , p [ f c.c4, d "M153 162L0 9v305z" ] []
        ]
