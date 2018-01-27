module Styleguide exposing (Data, generate)

{-| This library generates Style Guides. It is built using [Style Elements][style-elements].

[style-elements]: http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/latest


# Functions

@docs Data, generate

-}

import Color exposing (gray, rgb)
import Element exposing (..)
import Element.Area as Area
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


type alias Data msg =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , usageResult : Element msg
    , types : List ( String, List ( Element msg, String ) )
    , boxed : Bool
    }


conf : { rounding : Int, spacing : Int }
conf =
    { spacing = 10
    , rounding = 10
    }


codeAttributes : List (Attribute msg)
codeAttributes =
    [ Background.color <| rgb 0xEE 0xEE 0xEE
    , padding conf.spacing
    , Font.family [ Font.monospace ]
    ]


h2 : List (Element.Attribute msg)
h2 =
    [ Area.heading 2, Font.size 16, alignLeft ]


h3 : List (Element.Attribute msg)
h3 =
    [ Area.heading 3, Font.size 14, alignLeft ]


generate : Data msg -> Element msg
generate data =
    column
        [ Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , Border.color gray
        , paddingEach { top = 40, right = 0, bottom = 40, left = 0 }
        , spacing conf.spacing
        ]
        [ el h2 <| text <| "► " ++ data.name
        , paragraph [] [ text data.description ]
        , el h3 <| text "Signature"
        , paragraph codeAttributes [ text <| data.signature ]
        , el h3 <| text "Code Example"
        , paragraph codeAttributes [ text <| data.usage ]
        , el h3 <| text "Result"
        , paragraph [] [ data.usageResult ]
        , el h3 <| text ((toString <| List.length data.types) ++ " types of " ++ data.name)
        , column []
            (List.map
                (\( title, list ) ->
                    column []
                        [ el
                            [ alignLeft
                            , Font.size 22
                            , paddingXY 0 20
                            ]
                          <|
                            text <|
                                (toString <| List.length list)
                                    ++ " "
                                    ++ title
                        , column [] <| viewPart2 list data
                        ]
                )
                data.types
            )
        ]


viewPart2 : List ( Element msg, String ) -> { a | boxed : Bool } -> List (Element msg)
viewPart2 list data =
    List.map
        (\( part, name ) -> viewPart ( part, name ) data.boxed)
        list


viewPart : ( Element msg, String ) -> Bool -> Element msg
viewPart ( part, name ) boxed =
    el
        [ paddingEach { top = 0, right = conf.spacing, bottom = conf.spacing, left = 0 }
        , alignBottom
        , width fill
        ]
    <|
        row
            ([ spacing conf.spacing
             , width fill
             ]
                ++ (if boxed then
                        [ padding conf.spacing
                        , Background.color <| rgb 0xEE 0xEE 0xEE
                        , Border.rounded conf.rounding
                        ]
                    else
                        []
                   )
            )
            [ el
                [ width (fillPortion 1)
                ]
              <|
                el [ alignLeft ]
                    part
            , el
                [ width (fillPortion 2)
                , alignLeft
                , alignTop
                , Font.color <| rgb 0x99 0x99 0x99
                , Font.family [ Font.monospace ]
                , Font.size 14
                ]
              <|
                text <|
                    name
            ]
