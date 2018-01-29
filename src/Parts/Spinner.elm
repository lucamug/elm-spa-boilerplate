module Parts.Spinner
    exposing
        ( black
        , introspection
        , orange
        , white
        )

import Color
import Color.Convert
import Element exposing (..)
import Html
import Styleguide
import Svg
import Svg.Attributes


-- INTROSPECTION


introspection : Styleguide.Data msg
introspection =
    { name = "Spinner"
    , signature = "Int -> Element msg"
    , description = "Spinner are used when the app is on hold, for example when waiting for an http request to come back. They are also embedded in other Parts, like button."
    , usage = "black 128"
    , usageResult = black 128
    , boxed = True
    , types =
        [ ( "Spinners"
          , [ ( orange 64, "orange" )
            , ( white 64, "white" )
            , ( black 64, "black" )
            ]
          )
        ]
    }



-- TYPES


orange : Int -> Element msg
orange size =
    part size Orange


white : Int -> Element msg
white size =
    part size White


black : Int -> Element msg
black size =
    part size Black



-- TYPES


type alias Size =
    Int


type Color
    = Orange
    | White
    | Black



-- INTERNAL


cssRgb : Color -> Color.Color
cssRgb color =
    case color of
        Orange ->
            Color.rgb 0xF0 0xAD 0x00

        White ->
            Color.rgb 0xFF 0xFF 0xFF

        Black ->
            Color.rgb 0x00 0x00 0x00


part : Size -> Color -> Element msg
part =
    partElement


partElement : Size -> Color -> Element msg
partElement size color =
    html <| partHtml size color


partHtml : Size -> Color -> Html.Html msg
partHtml size color =
    let
        colorString =
            Color.Convert.colorToHex <| cssRgb color

        id =
            toString color
    in
    Svg.svg
        [ Svg.Attributes.viewBox "0 0 38 38"
        , Svg.Attributes.width <| toString size
        , Svg.Attributes.height <| toString size
        , Svg.Attributes.xmlSpace "http://www.w3.org/2000/svg"
        ]
        [ Svg.defs []
            [ Svg.linearGradient
                [ Svg.Attributes.id id
                , Svg.Attributes.x1 "8%"
                , Svg.Attributes.x2 "65.7%"
                , Svg.Attributes.y1 "0%"
                , Svg.Attributes.y2 "23.9%"
                ]
                [ Svg.stop
                    [ Svg.Attributes.offset "0%"
                    , Svg.Attributes.stopColor colorString
                    , Svg.Attributes.stopOpacity "0"
                    ]
                    []
                , Svg.stop
                    [ Svg.Attributes.offset "63.1%"
                    , Svg.Attributes.stopColor colorString
                    , Svg.Attributes.stopOpacity ".6"
                    ]
                    []
                , Svg.stop
                    [ Svg.Attributes.offset "100%"
                    , Svg.Attributes.stopColor colorString
                    ]
                    []
                ]
            ]
        , Svg.g
            [ Svg.Attributes.fill "none"
            , Svg.Attributes.fillRule "evenodd"
            , Svg.Attributes.transform "translate(1 1)"
            ]
            [ Svg.path
                [ Svg.Attributes.d "M36 18C36 8 28 0 18 0"
                , Svg.Attributes.stroke <| "url(#" ++ id ++ ")"
                , Svg.Attributes.strokeWidth "2"
                ]
                [ Svg.animateTransform
                    [ Svg.Attributes.attributeName "transform", Svg.Attributes.dur "0.9s", Svg.Attributes.from "0 18 18", Svg.Attributes.repeatCount "indefinite", Svg.Attributes.to "360 18 18", Svg.Attributes.type_ "rotate" ]
                    []
                ]
            , Svg.circle
                [ Svg.Attributes.cx "36"
                , Svg.Attributes.cy "18"
                , Svg.Attributes.fill colorString
                , Svg.Attributes.r "1"
                ]
                [ Svg.animateTransform
                    [ Svg.Attributes.attributeName "transform"
                    , Svg.Attributes.dur "0.9s"
                    , Svg.Attributes.from "0 18 18"
                    , Svg.Attributes.repeatCount "indefinite"
                    , Svg.Attributes.to "360 18 18"
                    , Svg.Attributes.type_ "rotate"
                    ]
                    []
                ]
            ]
        ]
