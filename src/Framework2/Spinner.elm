module Framework2.Spinner
    exposing
        ( black
        , introspection
        , orange
        , white
        )

import Color
import Color.Convert
import Element
import Html
import Styleguide
import Svg exposing (..)
import Svg.Attributes exposing (..)


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


orange : Int -> Element.Element msg
orange size =
    part size Orange


white : Int -> Element.Element msg
white size =
    part size White


black : Int -> Element.Element msg
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


part : Size -> Color -> Element.Element msg
part =
    partElement


partElement : Size -> Color -> Element.Element msg
partElement size color =
    Element.html <| partHtml size color


partHtml : Size -> Color -> Html.Html msg
partHtml size color =
    let
        colorString =
            Color.Convert.colorToHex <| cssRgb color

        idElement =
            "id" ++ String.dropLeft 1 colorString

        speed =
            "0.6s"

        size =
            30
    in
    svg
        [ viewBox "0 0 64 64"
        , xmlSpace "http://www.w3.org/2000/svg"
        , width <| toString size
        , height <| toString size
        ]
        [ g
            []
            [ circle
                [ cx "16", cy "32", strokeWidth "0", r "4.26701", fill colorString ]
                [ animate
                    [ attributeName "fill-opacity"
                    , dur "750ms"
                    , values ".5;.6;.8;1;.8;.6;.5;.5"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate [ attributeName "r", dur "750ms", values "3;3;4;5;6;5;4;3", repeatCount "indefinite" ] []
                ]
            , circle
                [ cx "32", cy "32", strokeWidth "0", r "5.26701", fill colorString ]
                [ animate
                    [ attributeName "fill-opacity"
                    , dur "750ms"
                    , values ".5;.5;.6;.8;1;.8;.6;.5"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate [ attributeName "r", dur "750ms", values "4;3;3;4;5;6;5;4", repeatCount "indefinite" ] []
                ]
            , circle
                [ cx "48", cy "32", strokeWidth "0", r "5.73299", fill colorString ]
                [ animate
                    [ attributeName "fill-opacity"
                    , dur "750ms"
                    , values ".6;.5;.5;.6;.8;1;.8;.6"
                    , repeatCount "indefinite"
                    ]
                    []
                , animate [ attributeName "r", dur "750ms", values "5;4;3;3;4;5;6;5", repeatCount "indefinite" ] []
                ]
            ]
        ]



{-
   partHtml : Size -> Color -> Html.Html msg
   partHtml size color =
       let
           colorString =
               Color.Convert.colorToHex <| cssRgb color

           id =
               "F2" ++toString color
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

-}
