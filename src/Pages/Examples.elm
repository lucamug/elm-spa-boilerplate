module Pages.Examples exposing (view)

import Color exposing (..)
import Element exposing (..)
import Element.Area as Area
import Element.Background as Background
import Element.Font as Font


view : a -> Element msg
view model =
    column
        [ spacing 5
        ]
        [ header

        --
        , section "Links"
        , code "link [] { url, label }"
        , el (width fill :: attrCont) <| link attrA { url = "http://example.com", label = text "link" }
        , code "newTabLink [] { url, label }"
        , el (width fill :: attrCont) <| newTabLink attrA { url = "http://example.com", label = text "newTabLink" }
        , code "download [] { url, label }"
        , el (width fill :: attrCont) <| download attrA { url = "http://example.com", label = text "download" }
        , code "downloadAs [] { url, label }"
        , el (width fill :: attrCont) <| downloadAs attrA { url = "http://example.com", label = text "downloadAs", filename = "filename" }

        --
        , section "Area Annotations"
        , code "link [ Area.heading 1 ] { url, label }"
        , el (width fill :: attrCont) <| link (Area.heading 1 :: attrA) { url = "http://example.com", label = text "h1 link" }
        , code "el [ Area.heading 1 ] text"
        , el (width fill :: attrCont) <| el (Area.heading 1 :: attrA) <| text "h1 text"

        --
        , section "Images"
        , code "el [] [ image ]"
        , code "el [] [ decorativeImage ]"

        --
        , section "Empty"
        , code "el|row|column|paragraph [] [ text ]"
        , el attrCont empty
        , row attrCont [ empty ]
        , column attrCont [ empty ]
        , paragraph attrCont [ empty ]

        --
        , section "Text"
        , code "el|row|column|paragraph [] [ text ]"
        , el attrCont <| text "text in el"
        , row attrCont [ text "text in row" ]
        , column attrCont [ text "text in column" ]
        , paragraph attrCont [ text "text in paragraph" ]

        --
        , section "Three elements in a row"
        , code "row [] [ el, el, el ]"
        , row attrCont [ el attrA dummyT, el attrA dummyT, el attrA dummyT ]

        --
        , section "Alignment"
        , row attrCont [ el (alignLeft :: attrA) <| text "alignLeft", el attrA dummyT, el attrA dummyT ]
        , row attrCont [ el (alignRight :: attrA) <| text "alignRight", el attrA dummyT, el attrA dummyT ]
        , row attrCont [ el (alignLeft :: attrA) <| text "alignLeft", el attrA dummyT, el (alignRight :: attrA) <| text "alignRight" ]
        , row attrCont [ el (alignRight :: attrA) <| text "alignRight", el attrA dummyT, el (alignLeft :: attrA) <| text "alignLeft" ]
        , row attrCont [ el attrA dummyT, el (alignLeft :: attrA) <| text "alignLeft", el attrA dummyT ]
        , row (height (px 100) :: attrCont) [ el (attrA ++ [ alignTop ]) <| text "alignTop", el attrA dummyT, el (attrA ++ [ alignBottom ]) <| text "alignBottom" ]

        --
        , section "Height, three elements in a tall row"
        , code "row [ height px 80 ] [ el, el, el ]"
        , row (height (px 80) :: attrCont) [ el attrA dummyT, el attrA dummyT, el attrA dummyT ]
        , row (height (px 80) :: attrCont) [ el (height fill :: attrA) <| text "height fill", el attrA dummyT, el attrA dummyT ]
        , row (height (px 80) :: attrCont) [ el (height (px 40) :: attrA) <| text "height px 40", el attrA dummyT, el attrA dummyT ]
        , row (height (px 80) :: attrCont) [ el (attrA ++ [ width fill, height fill ]) <| text "width fill, height fill", el attrA dummyT, el attrA dummyT ]

        --
        , section "Width shrink"
        , code "column [ height px 80 ] [ column [ heigh shrink ] [ text ] ]"
        , column (height (px 80) :: attrCont) [ column attrA [ el [] dummyT ] ]
        , column (height (px 80) :: attrCont) [ column (height shrink :: attrA) [ el [] <| text "height shrink" ] ]

        --
        , section "Width (1x = width fillPortion 1)"
        , row attrCont [ el (attrA ++ [ width fill ]) <| text "width fill", el attrA dummyT, el attrA dummyT ]
        , row attrCont [ el (attrA ++ [ width fill ]) <| text "width fill", el (attrA ++ [ width fill ]) <| text "width fill", el attrA dummyT ]
        , row attrCont [ el (attrA ++ [ width fill ]) <| text "width fill", el (attrA ++ [ width fill ]) <| text "width fill", el (attrA ++ [ width fill ]) <| text "width fill" ]
        , row attrCont [ el (attrA ++ [ width <| px 100 ]) <| text "width px 100", el attrA dummyT, el attrA dummyT ]
        , row attrCont [ el (attrA ++ [ width <| fillPortion 1 ]) <| text "1x", el attrA dummyT, el attrA dummyT ]
        , row attrCont [ el (attrA ++ [ width <| fillPortion 1 ]) <| text "1x", el (attrA ++ [ width <| fillPortion 2 ]) <| text "2x", el attrA dummyT ]

        --
        , section "Nearby Elements"
        , code "row [ height px 80 ] [ el [ below ], el ]"
        , row (height (px 80) :: attrCont) [ el [ below True (el attrB <| text "below") ] (el attrA dummyT) ]
        , row (height (px 80) :: attrCont) [ el [ above True (el attrB <| text "above") ] (el attrA dummyT) ]
        , row (height (px 80) :: attrCont) [ el [ onRight True (el attrB <| text "onRight") ] (el attrA dummyT) ]
        , row (height (px 80) :: attrCont) [ el [ onLeft True (el attrB <| text "onLeft") ] (el attrA dummyT) ]
        , row (height (px 80) :: attrCont) [ el [ inFront True (el attrB <| text "inFront") ] (el attrA dummyT) ]
        , row (height (px 80) :: attrCont) [ el [ behind True (el attrB <| text "behind") ] (el attrA dummyT) ]
        , code "row [ height px 80 ] [ el [ below [ onRight ] ] ]"
        , row (height (px 80) :: attrCont) [ el [ below True (el [ onRight True (el attrC <| text "onRight") ] (el attrB <| text "below")) ] (el attrA dummyT) ]

        --
        , section "row with many items (non wrapping, is not working with \"width fill\" so it needs fixed with otherwise doesn't fit in the parent element. The elements are centered...)"
        , issue "https://github.com/mdgriffith/stylish-elephants/issues/27"
        , code "row [ width px 200 ] [ repeat 20 el ] (non wrapping)"
        , row (width (px 200) :: clipX :: scrollbarX :: attrCont) (List.repeat 20 (el attrA dummyT))

        --
        , section "paragraph with many items (wrapping)"
        , code "paragraph [] [ repeat 20 el ] (wrapping)"
        , paragraph attrCont (List.repeat 20 (el attrA dummyT))

        --
        , section "Three elements in a column"
        , code "col [] [ el, el, el ]"
        , column attrCont (List.repeat 3 (el attrA dummyT))
        , column attrCont [ el (attrA ++ [ alignLeft ]) <| text "alignLeft", el attrA dummyT, el (attrA ++ [ alignRight ]) <| text "alignRight" ]
        , column attrCont [ el (attrA ++ [ width fill ]) <| text "width fill", el attrA dummyT, el (attrA ++ [ width <| px 200, alignRight ]) <| text "alignRight, width px 200" ]

        --
        , section "Three elements in a tall column"
        , code "col [height px 160] [ el, el, el ]"
        , column (height (px 160) :: attrCont) (List.repeat 3 (el attrA dummyT))
        , column (height (px 160) :: attrCont) [ el (attrA ++ [ centerY ]) <| text "centerY", el attrA dummyT, el (attrA ++ [ alignBottom ]) <| text "alignBottom" ]
        , column (height (px 160) :: attrCont) [ el (attrA ++ [ width fill, height fill ]) <| text "width fill, height fill", el attrA dummyT, el attrA dummyT ]

        --
        , section "Adjustment"
        , row attrCont [ el (attrA ++ [ moveUp 5 ]) <| text "moveUp", el (attrA ++ [ moveDown 5 ]) <| text "moveDown" ]
        , row attrCont [ el (attrA ++ [ moveLeft 5 ]) <| text "moveLeft", el (attrA ++ [ moveRight 5 ]) <| text "moveRight" ]
        , row attrCont [ el (attrA ++ [ rotate <| pi / 4 ]) <| text "rotate", el (attrA ++ [ scale 0.7 ]) <| text "scale" ]
        , row attrCont [ el (attrA ++ [ scale 0.7, mouseOverScale 1.2 ]) <| text "mouseOverScale" ]

        --
        , section "Paragraph"
        , code "paragraph [] [ text, text, text ]"
        , paragraph attrCont (List.repeat 3 loremT)
        , code "paragraph [ spacing 0 ] [ text, el, text ]"
        , paragraph (spacing 0 :: attrCont) [ loremT, el [ Font.bold, Background.color lightGray, Font.color black, paddingXY 4 0 ] (text "This is bold."), loremT ]
        , paragraph (spacing 0 :: attrCont) [ loremT, el [ Font.bold, Background.color lightGray, Font.color black, paddingXY 4 0 ] loremT, loremT ]
        , code "paragraph [ spacing 20 ] [ text, el, text ]"
        , paragraph (spacing 20 :: attrCont) [ loremT, el [ Font.bold, Background.color lightGray, Font.color black, paddingXY 4 0 ] (text "This is bold."), loremT ]
        , code "paragraph [] [ el, el, el ]"
        , paragraph attrCont (List.repeat 3 (el attrA loremT))
        , paragraph (padding 5 :: attrBackground) [ el [ alignLeft, paddingEach { top = 0, right = 6, bottom = 0, left = 0 }, Font.lineHeight 1, Font.size 40 ] (text "S"), loremT, loremT, loremT ]

        --
        , section "column vs. textColumn"
        , code "textColumn [width fill] [ paragraph, paragraph [alignLeft], paragraph ]"
        , textColumn (width fill :: attrCont) [ paragraph attrA [ loremT ], paragraph (alignLeft :: width (px 100) :: attrB) [ loremT ], paragraph attrA [ loremT ] ]
        , code "column [] [ paragraph, paragraph [alignLeft], paragraph ]"
        , column attrCont [ paragraph attrA [ loremT ], paragraph (alignLeft :: width (px 100) :: attrB) [ loremT ], paragraph attrA [ loremT ] ]
        , code "textColumn [width fill] [ paragraph, paragraph ]"
        , textColumn (width fill :: attrCont) (List.repeat 2 (paragraph attrA [ loremT ]))
        , code "column [width fill] [ paragraph, paragraph ]"
        , column attrCont (List.repeat 2 (paragraph attrA [ loremT ]))

        --
        , section "Attributes"
        , row attrCont [ el (attrA ++ [ description "description" ]) <| text "description", el (attrA ++ [ pointer ]) <| text "pointer" ]

        --
        , section "Tables"
        , code "table [] { data, columns } "
        , table attrCont
            { data = cells
            , columns =
                [ { header = el (width fill :: attrA) <| text "Header 1", view = \cell -> el (width fill :: attrB) <| text cell.cell1 }
                , { header = el (width fill :: attrA) <| text "Header 2", view = \cell -> el (width fill :: attrB) <| text cell.cell2 }
                ]
            }
        , code "indexTable [] { data, columns } "
        , indexedTable attrCont
            { data = cells
            , columns =
                [ { header = el (width fill :: attrA) <| text "Index", view = \index cell -> el (width fill :: attrC) <| text <| toString index }
                , { header = el (width fill :: attrA) <| text "Header 1", view = \index cell -> el (width fill :: attrB) <| text cell.cell1 }
                , { header = el (width fill :: attrA) <| text "Header 2", view = \index cell -> el (width fill :: attrB) <| text cell.cell2 }
                ]
            }
        , text "with alternated colors"
        , indexedTable attrCont
            { data = cells
            , columns =
                [ { header = el (width fill :: attrA) <| text "Index", view = \index cell -> el (alternateCellAttr index) <| text <| toString index }
                , { header = el (width fill :: attrA) <| text "Header 1", view = \index cell -> el (alternateCellAttr index) <| text cell.cell1 }
                , { header = el (width fill :: attrA) <| text "Header 2", view = \index cell -> el (alternateCellAttr index) <| text cell.cell2 }
                ]
            }
        ]


attrBackground : List (Element.Attribute msg)
attrBackground =
    [ Background.color <| rgb 0x65 0x8D 0xB5
    , Font.color white
    ]


attrCont : List (Attribute msg)
attrCont =
    [ padding 5
    , spacing 5
    ]
        ++ attrBackground


attrA : List (Attribute msg)
attrA =
    [ Background.color <| rgb 0xD1 0xE5 0xFA
    , Font.color black
    , padding 5
    ]


attrB : List (Attribute msg)
attrB =
    [ Background.color lightYellow
    , Font.color black
    , padding 1
    ]


attrC : List (Attribute msg)
attrC =
    [ Background.color lightGreen
    , Font.color black
    , padding 1
    ]


dummyT : Element msg
dummyT =
    text "___"


loremT : Element msg
loremT =
    text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent luctus sed tellus et placerat."


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
    paragraph [ paddingXY 10 20 ] [ text string ]


header : Element msg
header =
    column []
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
        ]


issue : String -> Element msg
issue url =
    paragraph (paddingXY 10 0 :: Font.color red :: [])
        [ text "Issue: "
        , link [ Font.color red ]
            { url = url
            , label = text url
            }
        ]


type alias Cell =
    { cell1 : String
    , cell2 : String
    }


cells : List Cell
cells =
    [ { cell1 = "Cell 1.1"
      , cell2 = "Cell 2.1"
      }
    , { cell1 = "Cell 1.2"
      , cell2 = "Cell 2.2"
      }
    , { cell1 = "Cell 1.3"
      , cell2 = "Cell 2.3"
      }
    , { cell1 = "Cell 1.4"
      , cell2 = "Cell 2.4"
      }
    ]


alternateCellAttr : Int -> List (Attribute msg)
alternateCellAttr index =
    if index % 2 == 0 then
        width fill :: attrC
    else
        width fill :: attrB
