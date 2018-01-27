module Framework.Button exposing (button, introspection)

-- import Element.Hack as Hack
-- import Parts.Color
-- import Parts.Spinner
-- import Color.Accessibility
-- import Color
-- import Color.Convert

import Color.Manipulate
import Element exposing (Element, el, inFront, paddingXY)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Framework.Color as Color
import Framework.Framework exposing (..)
import Framework.Spinner as Spinner
import Styleguide


-- INTROSPECTION


introspection : Styleguide.Data msg
introspection =
    let
        buttonText =
            "Button"
    in
    { name = "Button"
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



-- TYPES


type State
    = StateDefault
    | StateOutlined
    | StateLoading
    | StateDisabled


type alias Conf =
    { fontSize : Int
    , fontColor : Color.Color
    , backgroundColor : Color.Color
    , padding : ( Int, Int )
    , borderRounded : Int
    }


type alias Conf2 =
    { state : State
    , size : Size
    , color : Color.Color
    }


processConf : List Modifier -> Conf2 -> Conf2
processConf modifiers conf =
    let
        _ =
            Debug.log "xxx332343" modifiers
    in
    List.foldl processConf2 conf modifiers


processConf2 : Modifier -> Conf2 -> Conf2
processConf2 modifier conf =
    case modifier of
        Primary ->
            { conf | color = Color.ColorPrimary }

        Link ->
            { conf | color = Color.ColorLink }

        Info ->
            { conf | color = Color.ColorInfo }

        Success ->
            { conf | color = Color.ColorSuccess }

        Warning ->
            { conf | color = Color.ColorWarning }

        Danger ->
            { conf | color = Color.ColorDanger }

        Small ->
            { conf | size = SizeSmall }

        Medium ->
            { conf | size = SizeMedium }

        Large ->
            { conf | size = SizeLarge }

        Outlined ->
            { conf | state = StateOutlined }

        Loading ->
            { conf | state = StateLoading }

        Disabled ->
            { conf | state = StateDisabled }


button : List Modifier -> Maybe msg -> String -> Element msg
button modifiers onPress label =
    let
        conf =
            processConf modifiers
                { color = Color.ColorDefault
                , size = SizeDefault
                , state = StateDefault
                }

        color =
            Color.color conf.color

        fontSize =
            case conf.size of
                SizeSmall ->
                    12

                SizeDefault ->
                    16

                SizeMedium ->
                    20

                SizeLarge ->
                    24

        padding =
            case conf.size of
                SizeSmall ->
                    ( 9, 4 )

                SizeDefault ->
                    ( 12, 5 )

                SizeMedium ->
                    ( 15, 6 )

                SizeLarge ->
                    ( 18, 7 )

        backgroundColor =
            case conf.state of
                StateDefault ->
                    color

                StateOutlined ->
                    case conf.color of
                        Color.ColorDefault ->
                            Color.color Color.ColorBorderDefault

                        _ ->
                            Color.color Color.ColorDefault

                StateLoading ->
                    color

                StateDisabled ->
                    color
                        |> Color.Manipulate.lighten 0.3
                        |> Color.Manipulate.desaturate 0.3

        borderRounded =
            case conf.size of
                SizeSmall ->
                    2

                _ ->
                    3

        borderColor =
            case conf.color of
                Color.ColorDefault ->
                    Color.color Color.ColorBorderDefault

                _ ->
                    case conf.state of
                        StateOutlined ->
                            color

                        _ ->
                            backgroundColor

        fontColor =
            -- Maybe.withDefault (toColor ColorFontDark) <| Color.Accessibility.maximumContrast color [ toColor ColorFontDark, toColor ColorFontBright ]
            case conf.state of
                StateOutlined ->
                    color

                StateLoading ->
                    backgroundColor

                _ ->
                    case conf.color of
                        Color.ColorWarning ->
                            Color.color Color.ColorFontDark

                        Color.ColorDefault ->
                            Color.color Color.ColorFontDark

                        _ ->
                            Color.color Color.ColorFontBright

        spinner =
            el [ Element.centerY ] <| Spinner.spinner conf.size Color.ColorFontBright

        textLabel =
            case conf.state of
                StateLoading ->
                    el [ inFront True spinner ] <| Element.text label

                _ ->
                    Element.text label
    in
    Input.button
        [ Font.size fontSize
        , Font.color fontColor
        , Background.color backgroundColor
        , paddingXY (Tuple.first padding) (Tuple.second padding)
        , Border.rounded borderRounded
        , Border.width 1
        , Border.color borderColor
        ]
        { onPress = onPress
        , label = textLabel
        }
