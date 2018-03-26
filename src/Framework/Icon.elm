module Framework.Icon
    exposing
        ( Icon(..)
        , icon
        , introspection
        )

{-| Logos generator


# Functions

@docs Logo, spinner, introspection

-}

import Color
import Element
import Element.Background
import Element.Border
import Html exposing (Html)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes as SA exposing (..)


{-| -}
introspection :
    { boxed : Bool
    , description : String
    , name : String
    , signature : String
    , usage : String
    , usageResult : Element.Element msg
    , variations : List ( String, List ( Element.Element msg1, String ) )
    }
introspection =
    { name = "Icons"
    , signature = "logo : Logo -> Int -> Color.Color -> Element.Element msg"
    , description = "List of SVG icons"
    , usage = "icon Pencil 32"
    , usageResult = icon Pencil 32
    , boxed = True
    , variations =
        [ ( "Icons"
          , [ ( icon Pencil 32, "icon Pencil 32" )
            , ( icon ExitFullscreen 32, "icon ExitFullscreen 32" )
            , ( icon Fullscreen 32, "icon Fullscreen 32" )
            , ( icon Points 32, "icon Points 32" )
            , ( icon Home 32, "icon Home 32" )
            , ( icon Hide 32, "icon Hide 32" )
            , ( icon Show 32, "icon Hide 32" )
            , ( icon MobileRinging 32, "icon MobileRinging 32" )
            , ( icon MobileNotification 32, "icon MobileNotification 32" )
            , ( icon MobileNotification2 32, "icon MobileNotification2 32" )
            , ( icon ChevronDown 32, "icon ChevronDown 32" )
            ]
          )
        ]
    }


usageWrapper : Element.Element msg -> Element.Element msg
usageWrapper item =
    Element.el
        [ Element.Background.color <| Color.rgb 0xBB 0xBB 0xBB
        , Element.padding 10
        , Element.Border.rounded 5
        ]
    <|
        item


{-| SVG Logo
-}
icon : Icon -> Int -> Element.Element msg
icon logo size =
    Element.html <|
        case logo of
            Points ->
                points size

            Hide ->
                hide size "#999"

            Show ->
                show size "#999"

            MobileRinging ->
                mobileRinging size "#999"

            MobileNotification ->
                mobileNotification size "#999"

            MobileNotification2 ->
                mobileNotification2 size "#999"

            Home ->
                home size

            Pencil ->
                pencil size

            ExitFullscreen ->
                exitFullscreen size

            Fullscreen ->
                fullscreen size

            ChevronDown ->
                chevronDown size "#333"


{-| Type of logos
-}
type Icon
    = Pencil
    | ExitFullscreen
    | Fullscreen
    | Points
    | Home
    | Hide
    | Show
    | MobileRinging
    | MobileNotification
    | MobileNotification2
    | ChevronDown


home : Int -> Html.Html msg
home size =
    Svg.svg [ Html.Attributes.style [ ( "height", toString size ++ "px" ) ], viewBox "0 0 34.94 32.63" ]
        [ Svg.path [ d "M34.94 15.58L17.24 0 0 15.65l1.5 1.66 2.14-1.92v17.25h27.68V15.38l2.14 1.88zM14.8 29.93V21.6h5.35v8.34zm14.27.45H22.4v-11h-9.84v11H5.88v-17L17.25 3l11.82 10.4z", fill "#262626", id "_01" ] []
        ]


points : Int -> Html.Html msg
points size =
    Svg.svg [ Html.Attributes.style [ ( "height", toString size ++ "px" ) ], viewBox "0 0 36.88 36.88" ]
        [ Svg.path [ fill "#040000", d "M0 18.44A18.44 18.44 0 0 1 18.44 0a18.44 18.44 0 0 1 18.44 18.44 18.44 18.44 0 0 1-18.44 18.44A18.44 18.44 0 0 1 0 18.44zm2.66 0A15.8 15.8 0 0 0 18.44 34.2 15.8 15.8 0 0 0 34.2 18.45 15.8 15.8 0 0 0 18.45 2.67 15.8 15.8 0 0 0 2.66 18.44z" ] []
        , Svg.path [ fill "#040000", d "M19.43 8.5a6.5 6.5 0 0 0-3.9 1.3v-.16a1.33 1.33 0 1 0-2.67 0V27.8a1.33 1.33 0 1 0 2.66 0v-7.5a6.56 6.56 0 1 0 3.9-11.8zm0 10.45a3.9 3.9 0 1 1 3.9-3.9 3.9 3.9 0 0 1-3.9 3.9z" ] []
        ]


pencil : Int -> Html.Html msg
pencil size =
    Svg.svg [ Html.Attributes.style [ ( "height", toString size ++ "px" ) ], viewBox "0 0 529 529" ]
        [ Svg.path [ d "M329 89l107 108-272 272L57 361 329 89zm189-26l-48-48a48 48 0 0 0-67 0l-46 46 108 108 53-54c14-14 14-37 0-52zM0 513c-2 9 6 16 15 14l120-29L27 391 0 513z" ] []
        ]


exitFullscreen : Int -> Html.Html msg
exitFullscreen size =
    Svg.svg [ Html.Attributes.style [ ( "height", toString size ++ "px" ) ], viewBox "0 0 32 32" ]
        [ Svg.path [ fill "#030104", d "M25 27l4 5 3-3-5-4 5-5H20v12zM0 12h12V0L7 5 3 0 0 3l5 4zm0 17l3 3 4-5 5 5V20H0l5 5zm20-17h12l-5-5 5-4-3-3-4 5-5-5z" ] []
        ]


fullscreen : Int -> Html.Html msg
fullscreen size =
    Svg.svg [ Html.Attributes.style [ ( "height", toString size ++ "px" ) ], viewBox "0 0 533 533" ]
        [ Svg.path [ d "M533 0v217l-83-84-100 100-50-50L400 83 317 0h216zM233 350L133 450l84 83H0V317l83 83 100-100 50 50z" ] []
        ]


hide : Int -> String -> Html msg
hide size color =
    Svg.svg [ SA.viewBox "0 0 512 512", SA.height <| toString size, SA.width <| toString size ]
        [ Svg.path
            [ SA.fill
                color
            , SA.d
                "M506 241l-89-89-14-13-258 258a227 227 0 0 0 272-37l89-89c8-8 8-22 0-30zM256 363a21 21 0 0 1 0-43c35 0 64-29 64-64a21 21 0 0 1 43 0c0 59-48 107-107 107zM95 152L6 241c-8 8-8 22 0 30l89 89 14 13 258-258c-86-49-198-37-272 37zm161 40c-35 0-64 29-64 64a21 21 0 0 1-43 0c0-59 48-107 107-107a21 21 0 0 1 0 43z"
            ]
            []
        ]


show : Int -> String -> Html msg
show size color =
    Svg.svg [ SA.viewBox "0 0 512 512", SA.height <| toString size, SA.width <| toString size ]
        [ Svg.path
            [ SA.fill
                color
            , SA.d
                "M256 192a64 64 0 1 0 0 128 64 64 0 0 0 0-128zm250 49l-89-89c-89-89-233-89-322 0L6 241c-8 8-8 22 0 30l89 89a227 227 0 0 0 322 0l89-89c8-8 8-22 0-30zM256 363a107 107 0 1 1 0-214 107 107 0 0 1 0 214z"
            ]
            []
        ]


mobileNotification2 : Int -> String -> Html msg
mobileNotification2 size color =
    Svg.svg [ SA.viewBox "0 0 31.68 31.68", SA.height <| toString size ]
        [ Svg.path
            [ SA.fill
                color
            , SA.d "M21.5 25.67H7V3.89h14.5v4.7h1.73V2.3a2.3 2.3 0 0 0-2.3-2.3H7.58a2.3 2.3 0 0 0-2.3 2.3v27.08a2.3 2.3 0 0 0 2.3 2.3h13.33a2.3 2.3 0 0 0 2.3-2.3V19.2H21.5v6.46zM19.4 1.44c.33 0 .59.27.59.6s-.26.58-.59.58-.59-.26-.59-.59.26-.59.59-.59zm-8.24.23h6.19v.67h-6.19v-.67zm5.91 27.55h-5.63V27.5h5.63v1.73z"
            ]
            []
        , Svg.path
            [ SA.fill
                color
            , SA.d "M13.05 9.3v9h1.56L13.05 22l4.54-3.7h8.81v-9H13.05zm12.21 7.86H17.2l-.32.25-1 .81.45-1.06H14.2v-6.71h11.07v6.7z"
            ]
            []
        ]


mobileRinging : Int -> String -> Html msg
mobileRinging size color =
    Svg.svg [ SA.viewBox "0 0 60 60", SA.height <| toString size ]
        [ Svg.path [ SA.fill color, SA.d "M43 0H17c-2 0-4 2-4 4v52c0 2 2 4 4 4h26c2 0 4-2 4-4V4c0-2-2-4-4-4zM15 8h30v38H15V8zm2-6h26l2 2v2H15V4l2-2zm26 56H17l-2-2v-8h30v8l-2 2z" ] []
        , Svg.path [ SA.fill color, SA.d "M30 49a4 4 0 1 0 0 8 4 4 0 0 0 0-8zm0 6a2 2 0 1 1 0-4 2 2 0 0 1 0 4zM26 5h4a1 1 0 1 0 0-2h-4a1 1 0 1 0 0 2zm7 0h1a1 1 0 1 0 0-2h-1a1 1 0 1 0 0 2zm24 0a1 1 0 1 0-2 1c4 4 4 10 0 14a1 1 0 1 0 2 1c4-5 4-12 0-16z" ] []
        , Svg.path [ SA.fill color, SA.d "M52 7a1 1 0 1 0-1 1 7 7 0 0 1 0 10 1 1 0 1 0 1 1 8 8 0 0 0 0-12zM5 6a1 1 0 1 0-2-1c-4 4-4 11 0 16a1 1 0 0 0 2 0v-1C1 16 1 10 5 6z" ] []
        , Svg.path [ SA.fill color, SA.d "M9 7H8a8 8 0 0 0 0 12 1 1 0 0 0 1 0v-2a7 7 0 0 1 0-9V7z" ] []
        ]


mobileNotification : Int -> String -> Html msg
mobileNotification size color =
    Svg.svg [ SA.viewBox "0 0 60 60", SA.height <| toString size ]
        [ Svg.path [ SA.fill color, SA.d "M20 49a4 4 0 1 0 0 8 4 4 0 0 0 0-8zm0 6a2 2 0 1 1 0-4 2 2 0 0 1 0 4zM17 5h4a1 1 0 1 0 0-2h-4a1 1 0 1 0 0 2zm7 0h1a1 1 0 1 0 0-2h-1a1 1 0 1 0 0 2z" ] []
        , Svg.path [ SA.fill color, SA.d "M56 12H38V4c0-2-2-4-4-4H8C6 0 4 2 4 4v52c0 2 2 4 4 4h26c2 0 4-2 4-4V33h18V12zM8 2h26l2 2v2H6V4l2-2zm26 56H8l-2-2v-8h30v8l-2 2zm2-12H6V8h30v4H18v21h4v7l9-7h5v13zm18-15H31l-7 5v-5h-4V14h34v17z" ] []
        , Svg.path [ SA.fill color, SA.d "M25 21h10a1 1 0 1 0 0-2H25a1 1 0 1 0 0 2zm-1 4l1 1h24a1 1 0 1 0 0-2H25l-1 1z" ] []
        ]


chevronDown : Int -> String -> Html msg
chevronDown size color =
    Svg.svg [ SA.viewBox "0 0 256 256", SA.height <| toString size ]
        [ Svg.path
            [ SA.d "M225.81 48.9L128 146.73 30.19 48.91 0 79.09l128 128 128-128z"
            ]
            []
        ]
