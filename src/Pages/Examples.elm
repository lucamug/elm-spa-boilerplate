module Pages.Examples exposing (view)

import Color
import Element exposing (..)
import Element.Background as Background


view : a -> Element msg
view model =
    column
        [ spacing 20
        ]
        [ paragraph [] [ text "Examples of mdgriffith/stylish-elephants" ]
        , text "row [] [el, el, el]"
        , row
            dummyA2
            [ el dummyA dummyT
            , el dummyA dummyT
            , el dummyA dummyT
            ]
        , row
            dummyA2
            [ el (dummyA ++ [ alignLeft ]) <| text "alignLeft"
            , el dummyA dummyT
            , el dummyA dummyT
            ]
        , row
            dummyA2
            [ el (dummyA ++ [ alignRight ]) <| text "alignRight"
            , el dummyA dummyT
            , el dummyA dummyT
            ]
        , row
            dummyA2
            [ el (dummyA ++ [ alignLeft ]) <| text "alignLeft"
            , el dummyA dummyT
            , el (dummyA ++ [ alignRight ]) <| text "alignRight"
            ]
        , row
            dummyA2
            [ el (dummyA ++ [ alignRight ]) <| text "alignRight"
            , el dummyA dummyT
            , el (dummyA ++ [ alignLeft ]) <| text "alignLeft"
            ]
        , row
            dummyA2
            [ el dummyA dummyT
            , el (dummyA ++ [ alignLeft ]) <| text "alignLeft"
            , el dummyA dummyT
            ]
        , text "row [height <| px 100] [el, el, el]"
        , row
            (dummyA2
                ++ [ height <| px 100
                   ]
            )
            [ el dummyA dummyT
            , el dummyA dummyT
            , el dummyA dummyT
            ]
        , row
            (dummyA2
                ++ [ height <| px 100
                   ]
            )
            [ el (dummyA ++ [ alignTop ]) <| text "alignTop"
            , el dummyA dummyT
            , el (dummyA ++ [ alignBottom ]) <| text "alignBottom"
            ]
        , row
            (dummyA2
                ++ [ height <| px 100
                   ]
            )
            [ el dummyA dummyT
            , el (dummyA ++ [ alignLeft, centerY ]) <| text "alignLeft centerY"
            , el (dummyA ++ [ alignRight, centerY ]) <| text "alignRight centerY"
            , el (dummyA ++ [ alignBottom ]) <| text "alignBottom"
            ]
        , column
            [ padding 10
            , spacing 7
            , Background.color Color.green
            , height <| px 100
            ]
            [ el dummyA dummyT
            , el (dummyA ++ [ alignLeft, centerY ]) <| text "alignLeft centerY"
            , el (dummyA ++ [ alignRight, centerY ]) <| text "alignRight centerY"
            , el (dummyA ++ [ alignBottom ]) <| text "alignBottom"
            ]
        ]


dummyA : List (Attribute msg)
dummyA =
    [ Background.color Color.orange
    , padding 2
    ]


dummyA2 : List (Attribute msg)
dummyA2 =
    [ padding 10
    , spacing 5
    , Background.color Color.green
    ]


dummyT : Element msg
dummyT =
    text "___"
