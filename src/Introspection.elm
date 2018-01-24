module Introspection
    exposing
        ( Introspection
        , view
        )

import Color
import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Hack


type alias Introspection msg =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , types : List ( Element.Element msg, String )
    , usageResult : Element.Element msg
    , boxed : Bool
    }


spacing : number
spacing =
    10


rounded : number
rounded =
    10


codeAttributes : List (Element.Attribute msg)
codeAttributes =
    [ Element.Background.color <| Color.rgb 0xEE 0xEE 0xEE
    , Element.padding spacing
    , Element.Font.family [ Element.Font.monospace ]
    ]


view : Introspection msg -> Element.Element msg
view introspection =
    Element.column
        [ Element.Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , Element.Border.color Color.gray
        , Element.paddingEach { top = 60, right = 0, bottom = 30, left = 0 }
        , Element.spacing spacing
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

        -- This to be replaced with a rowWrapped when is implemented in style-elements
        , Element.paragraph []
            (List.map
                (\( part, name ) -> viewPart ( part, name ) introspection.boxed)
                introspection.types
            )
        ]


viewPart : ( Element.Element msg, String ) -> Bool -> Element.Element msg
viewPart ( part, name ) boxed =
    Element.el
        [ Element.paddingEach { top = 0, right = spacing, bottom = spacing, left = 0 }
        , Element.alignBottom
        ]
    <|
        Element.column
            ([ Element.spacing spacing
             ]
                ++ (if boxed then
                        [ Element.padding spacing
                        , Element.Background.color <| Color.rgb 0xEE 0xEE 0xEE
                        , Element.Border.rounded rounded
                        ]
                    else
                        []
                   )
            )
            [ Element.el [] <| part
            , Element.el
                [ Element.Font.color <| Color.rgb 0x99 0x99 0x99
                , Element.Font.family [ Element.Font.monospace ]
                , Element.Font.size 14
                ]
              <|
                Element.text <|
                    name
            ]
