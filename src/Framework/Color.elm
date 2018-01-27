module Framework.Color exposing (Color(..), color, colorToHex)

-- import Element.Hack as Hack
-- import Parts.Color
-- import Parts.Spinner
-- import Color.Accessibility
--import Color.Manipulate
--import Element exposing (..)
--import Element.Background as Background
--import Element.Border as Border
--import Element.Font as Font
--import Element.Input as Input
--import Styleguide

import Color
import Color.Convert


-- INTROSPECTION
{-
   introspection : Styleguide.Styleguide msg
   introspection =
       { name = "Color"
       , signature = "button : List Modifier -> Maybe msg -> String -> Element msg"
       , description = "Buttons accept a list of modifiers, a Maybe msg (for example: \"Just DoSomething\") and the text to display inside the button."

       --
       , usage = "button [ Medium, Success, Outlined ] Nothing \"" ++ buttonText ++ "\""
       , usageResult = button [ Medium, Success, Outlined ] Nothing buttonText
       , boxed = False
       , types =
           [ ( "Sizes"
             , [ ( button [ Small ] Nothing buttonText, "button [ Small ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [] Nothing buttonText, "button [] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Medium ] Nothing buttonText, "button [ Medium ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Large ] Nothing buttonText, "button [ Large ] Nothing \"" ++ buttonText ++ "\"" )
               ]
             )
           , ( "Colors"
             , [ ( button [] Nothing buttonText, "button [] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Primary ] Nothing buttonText, "button [ Primary ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Link ] Nothing buttonText, "button [ Link ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Info ] Nothing buttonText, "button [ Info ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Success ] Nothing buttonText, "button [ Success ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Warning ] Nothing buttonText, "button [ Warning ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Danger ] Nothing buttonText, "button [ Danger ] Nothing \"" ++ buttonText ++ "\"" )
               ]
             )
           , ( "States"
             , [ ( button [ Primary, Outlined ] Nothing buttonText, "button [ Primary, Outlined ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Primary, Loading ] Nothing buttonText, "button [ Primary, Loading ] Nothing \"" ++ buttonText ++ "\"" )
               , ( button [ Primary, Disabled ] Nothing buttonText, "button [ Primary, Disabled ] Nothing \"" ++ buttonText ++ "\"" )
               ]
             )
           ]
       }

-}
-- TYPES


type Color
    = ColorDefault
    | ColorPrimary
    | ColorLink
    | ColorInfo
    | ColorSuccess
    | ColorWarning
    | ColorDanger
    | ColorFontBright
    | ColorFontDark
    | ColorBorderDefault


hexToColor : String -> Color.Color
hexToColor color =
    Result.withDefault Color.gray <| Color.Convert.hexToColor color


colorToHex : Color.Color -> String
colorToHex =
    Color.Convert.colorToHex


color : Color -> Color.Color
color color =
    case color of
        ColorDefault ->
            hexToColor "#ffffff"

        ColorPrimary ->
            hexToColor "#00D1B2"

        ColorLink ->
            hexToColor "#276CDA"

        ColorInfo ->
            hexToColor "#209CEE"

        ColorSuccess ->
            hexToColor "#23D160"

        ColorWarning ->
            hexToColor "#F0DE56"

        ColorDanger ->
            hexToColor "#FF3860"

        ColorFontBright ->
            hexToColor "#fff"

        ColorFontDark ->
            hexToColor "#363636"

        ColorBorderDefault ->
            hexToColor "#dbdbdb"
