module Pages.Examples exposing (view)

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font


view : a -> Element msg
view model =
    column
        [ spacing 5
        ]
        [ paragraph []
            [ text "Examples of "
            , link [ Font.color orange ]
                { url = "http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0/Element"
                , label = text "mdgriffith/stylish-elephants"
                }
            , text ". The code is actually some kind of pseudo-code. For real code have a look at "
            , link [ Font.color orange ]
                { url = "https://github.com/lucamug/elm-spa-boilerplate/blob/master/src/Pages/Examples.elm", label = text "Examples.elm" }
            , text "."
            ]
        , paragraph []
            [ text "Unless otherwise specified, elements have padding and spacing of 5px so to make the examples clearer."
            ]

        --
        , section "Empty"
        , code "el|row|column|paragraph [] [ text ]"
        , el dummyA2 empty
        , row dummyA2 [ empty ]
        , column dummyA2 [ empty ]
        , paragraph dummyA2 [ empty ]

        --
        , section "Text"
        , code "el|row|column|paragraph [] [ text ]"
        , el dummyA2 <| text "text in el"
        , row dummyA2 [ text "text in row" ]
        , column dummyA2 [ text "text in column" ]
        , paragraph dummyA2 [ text "text in paragraph" ]

        --
        , section "Three elements in a row"
        , code "row [] [ el, el, el ]"
        , row dummyA2 [ el dummyA dummyT, el dummyA dummyT, el dummyA dummyT ]

        --
        , section "Alignment"
        , row dummyA2 [ el (alignLeft :: dummyA) <| text "alignLeft", el dummyA dummyT, el dummyA dummyT ]
        , row dummyA2 [ el (alignRight :: dummyA) <| text "alignRight", el dummyA dummyT, el dummyA dummyT ]
        , row dummyA2 [ el (alignLeft :: dummyA) <| text "alignLeft", el dummyA dummyT, el (alignRight :: dummyA) <| text "alignRight" ]
        , row dummyA2 [ el (alignRight :: dummyA) <| text "alignRight", el dummyA dummyT, el (alignLeft :: dummyA) <| text "alignLeft" ]
        , row dummyA2 [ el dummyA dummyT, el (alignLeft :: dummyA) <| text "alignLeft", el dummyA dummyT ]
        , row (dummyA2 ++ [ height <| px 100 ]) [ el (dummyA ++ [ alignTop ]) <| text "alignTop", el dummyA dummyT, el (dummyA ++ [ alignBottom ]) <| text "alignBottom" ]
        , section "Height, three elements in a tall row"
        , code "row [ height px 80 ] [ el, el, el ]"
        , row (height (px 80) :: dummyA2) [ el dummyA dummyT, el dummyA dummyT, el dummyA dummyT ]
        , row (height (px 80) :: dummyA2) [ el (height fill :: dummyA) <| text "height fill", el dummyA dummyT, el dummyA dummyT ]
        , row (height (px 80) :: dummyA2) [ el (height (px 40) :: dummyA) <| text "height px 40", el dummyA dummyT, el dummyA dummyT ]
        , row (height (px 80) :: dummyA2)
            [ el (dummyA ++ [ width fill, height fill ]) <| text "width fill, height fill", el dummyA dummyT, el dummyA dummyT ]

        --
        , section "Width shrink"
        , code "column [ height px 80 ] [ column [ heigh shrink ] [ text ] ]"
        , column (height (px 80) :: dummyA2) [ column dummyA [ el [] dummyT ] ]
        , column (height (px 80) :: dummyA2) [ column (height shrink :: dummyA) [ el [] <| text "height shrink" ] ]

        --
        , section "Width (1x = width fillPortion 1)"
        , row dummyA2 [ el (dummyA ++ [ width fill ]) <| text "width fill", el dummyA dummyT, el dummyA dummyT ]
        , row dummyA2 [ el (dummyA ++ [ width fill ]) <| text "width fill", el (dummyA ++ [ width fill ]) <| text "width fill", el dummyA dummyT ]
        , row dummyA2 [ el (dummyA ++ [ width fill ]) <| text "width fill", el (dummyA ++ [ width fill ]) <| text "width fill", el (dummyA ++ [ width fill ]) <| text "width fill" ]
        , row dummyA2 [ el (dummyA ++ [ width <| px 100 ]) <| text "width px 100", el dummyA dummyT, el dummyA dummyT ]
        , row dummyA2 [ el (dummyA ++ [ width <| fillPortion 1 ]) <| text "1x", el dummyA dummyT, el dummyA dummyT ]
        , row dummyA2 [ el (dummyA ++ [ width <| fillPortion 1 ]) <| text "1x", el (dummyA ++ [ width <| fillPortion 2 ]) <| text "2x", el dummyA dummyT ]

        --
        , section "Nearby Elements"
        , code "row [ height px 80 ] [ el [ below ], el ]"
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ below True (el dummyB <| text "below") ] (el dummyA dummyT) ]
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ above True (el dummyB <| text "above") ] (el dummyA dummyT) ]
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ onRight True (el dummyB <| text "onRight") ] (el dummyA dummyT) ]
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ onLeft True (el dummyB <| text "onLeft") ] (el dummyA dummyT) ]
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ inFront True (el dummyB <| text "inFront") ] (el dummyA dummyT) ]
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ behind True (el dummyB <| text "behind") ] (el dummyA dummyT) ]
        , code "row [ height px 80 ] [ el [ below [ onRight ] ] ]"
        , row (dummyA2 ++ [ height <| px 80 ]) [ el [ below True (el [ onRight True (el dummyC <| text "onRight") ] (el dummyB <| text "below")) ] (el dummyA dummyT) ]

        --
        -- I removed this example because it doesn't fit in the page, maybe a bug?
        --, section "row with many items (non wrapping)"
        --, code "row [] [ repeat 20 el ] (non wrapping)"
        --, row (dummyA2 ++ [ clipX, scrollbarX ]) (List.repeat 20 (el dummyA dummyT))
        --
        , section "paragraph with many items (wrapping)"
        , code "paragraph [] [ repeat 20 el ] (wrapping)"
        , paragraph dummyA2 (List.repeat 20 (el dummyA dummyT))

        --
        , section "Three elements in a column"
        , code "col [] [ el, el, el ]"
        , column dummyA2 (List.repeat 3 (el dummyA dummyT))
        , column dummyA2 [ el (dummyA ++ [ alignLeft ]) <| text "alignLeft", el dummyA dummyT, el (dummyA ++ [ alignRight ]) <| text "alignRight" ]
        , column dummyA2 [ el (dummyA ++ [ width fill ]) <| text "width fill", el dummyA dummyT, el (dummyA ++ [ width <| px 200, alignRight ]) <| text "alignRight, width px 200" ]

        --
        , section "Three elements in a tall column"
        , code "col [height px 160] [ el, el, el ]"
        , column (dummyA2 ++ [ height <| px 160 ]) (List.repeat 3 (el dummyA dummyT))
        , column (dummyA2 ++ [ height <| px 160 ]) [ el (dummyA ++ [ centerY ]) <| text "centerY", el dummyA dummyT, el (dummyA ++ [ alignBottom ]) <| text "alignBottom" ]
        , column (dummyA2 ++ [ height <| px 160 ]) [ el (dummyA ++ [ width fill, height fill ]) <| text "width fill, height fill", el dummyA dummyT, el dummyA dummyT ]

        --
        , section "Adjustment"
        , row dummyA2
            [ el (dummyA ++ [ moveUp 5 ]) <| text "moveUp"
            , el (dummyA ++ [ moveDown 5 ]) <| text "moveDown"
            ]
        , row dummyA2
            [ el (dummyA ++ [ moveLeft 5 ]) <| text "moveLeft"
            , el (dummyA ++ [ moveRight 5 ]) <| text "moveRight"
            ]
        , row dummyA2
            [ el (dummyA ++ [ rotate <| pi / 4 ]) <| text "rotate"
            , el (dummyA ++ [ scale 0.7 ]) <| text "scale"
            ]
        , row dummyA2
            [ el (dummyA ++ [ scale 0.7, mouseOverScale 1.2 ]) <| text "mouseOverScale"
            ]

        --
        , section "Paragraph"
        , code "paragraph [] [ text, text, text ]"
        , paragraph dummyA2 (List.repeat 3 lorem)
        , code "paragraph [ spacing 0 ] [ text, el, text ]"
        , paragraph (dummyA2 ++ [ spacing 0 ]) [ lorem, el [ Font.bold, Background.color lightGray, Font.color black, paddingXY 4 0 ] (text "This is bold."), lorem ]
        , paragraph (dummyA2 ++ [ spacing 0 ]) [ lorem, el [ Font.bold, Background.color lightGray, Font.color black, paddingXY 4 0 ] lorem, lorem ]
        , code "paragraph [ spacing 20 ] [ text, el, text ]"
        , paragraph (dummyA2 ++ [ spacing 20 ]) [ lorem, el [ Font.bold, Background.color lightGray, Font.color black, paddingXY 4 0 ] (text "This is bold."), lorem ]
        , code "paragraph [] [ el, el, el ]"
        , paragraph dummyA2 (List.repeat 3 (el dummyA lorem))

        --
        , section "Attributes"
        , row dummyA2
            [ el (dummyA ++ [ description "description" ]) <| text "description"
            , el (dummyA ++ [ pointer ]) <| text "pointer"
            ]
        ]


dummyA : List (Attribute msg)
dummyA =
    [ Background.color lightGray
    , Font.color black
    , padding 5
    ]


dummyA2 : List (Attribute msg)
dummyA2 =
    [ padding 5
    , spacing 5
    , Background.color <| rgb 0x65 0x8D 0xB5
    , Font.color white
    ]


dummyB : List (Attribute msg)
dummyB =
    [ Background.color lightYellow
    , Font.color black
    , padding 1
    ]


dummyC : List (Attribute msg)
dummyC =
    [ Background.color lightGreen
    , Font.color black
    , padding 1
    ]


dummyT : Element msg
dummyT =
    text "___"


code : String -> Element msg
code string =
    paragraph
        [ Background.color <| rgb 0xEE 0xEE 0xEE
        , padding 10
        , Font.family [ Font.monospace ]
        ]
        [ text string ]


section : String -> Element msg
section string =
    paragraph
        [ paddingXY 10 20
        ]
        [ text string ]


lorem : Element msg
lorem =
    text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent luctus sed tellus et placerat."
