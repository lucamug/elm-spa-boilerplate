module Pages.ElementInputExamples exposing (view)

--import Element.Area as Area

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input


type Msg
    = NoOp


view : a -> Element msg
view model =
    column
        [ spacing 5
        ]
        [ header

        --
        , section "Radio"
        , code "radio [] { label, onChange, notice, selected, options }"
        , Input.radio []
            { label = Input.labelAbove [] <| text "Label"
            , onChange = Nothing
            , notice = Nothing
            , selected = Nothing
            , options = []
            }

        --
        , section "Button"
        , code "button [] { label, onPress }"
        , Input.button []
            { label = text "Button"
            , onPress = Nothing
            }

        --
        , section "Text (note that html attribute value is text)"
        , code "text [] { label, onChange, notice, placeholder, text }"
        , Input.text []
            { label = Input.labelAbove [] <| text "Input text"
            , onChange = Nothing
            , notice = Nothing
            , placeholder = Nothing
            , text = ""
            }

        --
        , section "Select"
        , code "select [] { label, onChange, notice, selected, menu, placeholder }"
        , Input.select
            []
            { label = Input.labelAbove [] <| text "Label"
            , onChange = Nothing
            , notice = Nothing
            , selected = Nothing
            , menu =
                Input.menuBelow []
                    [ Input.option 10 (text "ciao 10")
                    , Input.option 11 (text "ciao 11")
                    , Input.option 12 (text "ciao 12")
                    ]
            , placeholder = Just <| text "Place Holder"
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
