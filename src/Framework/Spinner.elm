module Framework.Spinner
    exposing
        ( spinner
        )

--import Introspection

import Element
import Framework.Color
import Framework.Framework exposing (..)
import Html
import Svg
import Svg.Attributes


-- INTROSPECTION
{-
   introspection : Introspection.Introspection msg
   introspection =
       { name = "Spinner"
       , signature = "Int -> Element msg"
       , description = "Spinner are used when the app is on hold, for example when waiting for an http request to come back. They are also embedded in other Parts, like button."
       , usage = "black 128"
       , usageResult = black 128
       , boxed = True
       , types =
           [ ( orange 64, "orange" )
           , ( white 64, "white" )
           , ( black 64, "black" )
           ]
       }
-}


spinner : Size -> Framework.Color.Color -> Element.Element msg
spinner =
    partElement


partElement : Size -> Framework.Color.Color -> Element.Element msg
partElement size color =
    Element.html <| partHtml size color


partHtml : Size -> Framework.Color.Color -> Html.Html msg
partHtml size color =
    let
        colorString =
            Framework.Color.colorToHex <| Framework.Color.color color

        id =
            toString color
    in
    Svg.svg
        [ Svg.Attributes.viewBox "0 0 38 38"
        , Svg.Attributes.xmlSpace "http://www.w3.org/2000/svg"
        , Svg.Attributes.width <| toString <| toPx size
        , Svg.Attributes.height <| toString <| toPx size
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
