module Introspection exposing (Introspection, view)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Introspection msg a =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , usageResult : Html.Html msg
    , example : a -> Html msg
    , types : List a
    }


view : Introspection msg a -> Html msg
view introspection =
    div
        [ style
            [ ( "margin-top", "50px" )
            , ( "border-top", "1px solid #ddd" )
            ]
        ]
        [ h3 [] [ text introspection.name ]
        , pre [] [ text <| "component : " ++ introspection.signature ]
        , div [ style [ ( "padding-left", "40px" ) ] ]
            [ p [] [ text introspection.description ]
            , h4 [] [ text "Example code" ]
            , pre [] [ text <| "component " ++ introspection.usage ]
            , h4 [] [ text "Result" ]
            , div [] [ introspection.usageResult ]
            , h4 [] [ text ((toString <| List.length introspection.types) ++ " types of " ++ introspection.name) ]
            , div
                [ style
                    [ ( "display", "flex" )
                    , ( "flex-wrap", "wrap" )
                    , ( "align-items", "stretch" )
                    , ( "justify-content", "flex-start" )
                    ]
                ]
                (List.map
                    (\type_ ->
                        div
                            [ style
                                [ ( "margin-top", "20px" )
                                , ( "padding-bottom", "10px" )
                                , ( "text-align", "center" )
                                , ( "flex", "0 1 auto" )
                                , ( "margin-right", "10px" )
                                ]
                            ]
                            [ div [] [ introspection.example type_ ]
                            , div
                                [ class "code"
                                , style
                                    [ ( "padding-top", "10px" )
                                    , ( "margin-top", "10px" )
                                    ]
                                ]
                                [ text <| toString type_ ]
                            ]
                    )
                    introspection.types
                )
            ]
        ]
