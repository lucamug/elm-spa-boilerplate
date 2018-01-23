module Introspection
    exposing
        ( Introspection
        , Introspection2
        , view
        )

import Color
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Hack


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


codeAttributes : List (Element.Attribute msg)
codeAttributes =
    [ Element.Background.color <| Color.rgb 0xEE 0xEE 0xEE
    , Element.padding 10
    , Element.Font.family
        [ Element.Font.monospace
        ]
    ]


view : Introspection msg a -> Element.Element msg
view introspection =
    Element.column
        [ Element.Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , Element.Border.color Color.gray
        , Element.paddingEach { top = 60, right = 0, bottom = 30, left = 0 }
        , Element.spacing 10
        ]
        [ Element.Hack.h3 [] <| Element.text <| "► " ++ introspection.name
        , Element.paragraph [] [ Element.text introspection.description ]
        , Element.Hack.h4 [] <| Element.text "Signature"
        , Element.paragraph codeAttributes [ Element.text <| introspection.signature ]
        , Element.Hack.h4 [] <| Element.text "Code Example"
        , Element.paragraph codeAttributes [ Element.text <| introspection.usage ]
        , Element.Hack.h4 [] <| Element.text "Result"
        , Element.paragraph [] [ introspection.usageResult ]
        , Element.Hack.h4 [] <| Element.text ((toString <| List.length introspection.types) ++ " types of " ++ introspection.name)
        , Element.paragraph
            []
            (List.map
                (\( type_, name ) ->
                    Element.column
                        [ Element.paddingEach { top = 0, right = 30, bottom = 30, left = 0 }
                        ]
                        [ Element.el
                            []
                          <|
                            introspection.example type_
                        , Element.el
                            [ Element.Font.size 14
                            ]
                          <|
                            Element.text <|
                                name
                        ]
                )
                introspection.types
            )
        ]
