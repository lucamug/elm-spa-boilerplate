module Introspection
    exposing
        ( Introspection
        , Introspection2
        , view
        )

import Color
import Element
import Element.Background
import Element.Font
import Element.Hack
import Html exposing (..)


type alias Introspection msg a =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , types : List ( a, String )
    , example : a -> Element.Element msg
    , usageResult : Element.Element msg
    }


type alias Introspection2 msg =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , types : List ( Element.Element msg, String )
    , example : Element.Element msg -> Element.Element msg
    , usageResult : Element.Element msg
    }


code : List (Element.Attribute msg)
code =
    [ Element.Background.color <| Color.rgb 0xEE 0xEE 0xEE
    , Element.padding 10
    , Element.Font.family
        [ Element.Font.monospace
        ]
    ]


view : Introspection msg a -> Element.Element msg
view introspection =
    Element.column []
        [ Element.Hack.h3 [] [ text introspection.name ]
        , Element.paragraph code [ Element.text <| introspection.signature ]
        , Element.column []
            [ Element.paragraph [] [ Element.text introspection.description ]
            , Element.Hack.h4 [] [ text "Example code" ]
            , Element.paragraph code
                [ Element.text <|
                    "Parts."
                        ++ introspection.name
                        ++ "."
                        ++ introspection.usage
                ]
            , Element.Hack.h4 [] [ text "Result" ]
            , Element.el [] introspection.usageResult
            , Element.Hack.h4 [] [ text ((toString <| List.length introspection.types) ++ " types of " ++ introspection.name) ]
            , Element.paragraph []
                [ Element.column []
                    (List.map
                        (\( type_, name ) ->
                            Element.column []
                                [ Element.el [] <| introspection.example type_
                                , Element.el [] <| Element.text <| name
                                ]
                        )
                        introspection.types
                    )
                ]
            ]
        ]
