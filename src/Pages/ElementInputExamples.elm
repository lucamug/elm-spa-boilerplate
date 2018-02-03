module Pages.ElementInputExamples exposing (Model, Msg(..), initModel, update, view)

--import Element.Area as Area

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html


type alias Model =
    { radio : Maybe String
    , text : String
    , checkbox : Bool
    }


type Msg
    = Radio String
    | Button
    | Input String
    | Checkbox Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg |> Debug.log "Msg" of
        Radio value ->
            ( { model | radio = Just value }, Cmd.none )

        Button ->
            ( model, Cmd.none )

        Input value ->
            ( { model | text = value }, Cmd.none )

        Checkbox value ->
            ( { model | checkbox = value }, Cmd.none )


initModel : Model
initModel =
    { radio = Just "A"
    , text = ""
    , checkbox = False
    }


type alias Cell2 =
    { type_ : String
    , label : String
    , msg : String
    , notice : String
    , value : String
    , placeholder : String
    }


cells2 : List Cell2
cells2 =
    [ { type_ = "button"
      , label = "✓"
      , msg = "Press"
      , notice = "-"
      , value = "-"
      , placeholder = "-"
      }
    , { type_ = "text"
      , label = "✓"
      , msg = "Change (String)"
      , notice = "✓"
      , value = "text (String)"
      , placeholder = "✓"
      }
    , { type_ = "checkbox"
      , label = "✓"
      , msg = "Change (Bool)"
      , notice = "✓"
      , value = "checked (Bool)"
      , placeholder = "-"
      }
    , { type_ = "radio"
      , label = "✓"
      , msg = "Change (option)"
      , notice = "✓"
      , value = "selected (Maybe option)"
      , placeholder = "-"
      }
    , { type_ = "select"
      , label = "✓"
      , msg = "Change (option)"
      , notice = "✓"
      , value = "selected (Maybe option)"
      , placeholder = "✓"
      }
    ]


notice : List (Element.Attribute msg)
notice =
    [ Font.color Color.yellow ]


view : Model -> Element Msg
view model =
    column
        [ spacing 5
        ]
        [ header

        --
        , table attrCont
            { data = cells2
            , columns =
                [ { header = paragraph (height fill :: width fill :: attrA) [ text "Type" ], view = \cell -> paragraph (height fill :: width fill :: attrB) [ text cell.type_ ] }
                , { header = paragraph (height fill :: width fill :: attrA) [ text "label" ], view = \cell -> paragraph (height fill :: width fill :: attrB) [ text cell.label ] }
                , { header = paragraph (height fill :: width fill :: attrA) [ text "on..." ], view = \cell -> paragraph (height fill :: width fill :: attrB) [ text cell.msg ] }
                , { header = paragraph (height fill :: width fill :: attrA) [ text "Value" ], view = \cell -> paragraph (height fill :: width fill :: attrB) [ text cell.value ] }
                , { header = paragraph (height fill :: width fill :: attrA) [ text "notice" ], view = \cell -> paragraph (height fill :: width fill :: attrB) [ text cell.notice ] }
                , { header = paragraph (height fill :: width fill :: attrA) [ text "p.holder" ], view = \cell -> paragraph (height fill :: width fill :: attrB) [ text cell.placeholder ] }
                ]
            }

        --
        , code "button [] { label, onPress }"
        , paragraph attrCont
            [ Input.button attrA
                { label = text "Label"
                , onPress = Just Button
                }
            ]

        --
        , code "text [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.text attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]

        --
        , code "checkbox [] { label, onChange, notice, checked, icon }"
        , paragraph attrCont
            [ Input.checkbox attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Checkbox
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , checked = model.checkbox

                -- , icon = Just <| text "Icon"
                , icon = Nothing
                }
            ]

        --
        , code "radio [] { label, onChange, notice, selected, options }"
        , paragraph attrCont
            [ Input.radio attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Radio
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , selected = model.radio
                , options =
                    [ Input.option "A" (text "Radio A")
                    , Input.option "B" (text "Radio B")
                    , Input.option "C" (text "Radio C")
                    ]
                }
            ]
        , code "radioRow [] { label, onChange, notice, selected, options }"
        , paragraph attrCont
            [ Input.radioRow attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Radio
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , selected = model.radio
                , options =
                    [ Input.option "A" (text "Radio A")
                    , Input.option "B" (text "Radio B")
                    , Input.option "C" (text "Radio C")
                    ]
                }
            ]

        --
        , code "select [] { label, onChange, notice, selected, menu, placeholder }"
        , paragraph attrCont
            [ Input.select
                attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Radio
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , selected = model.radio
                , menu =
                    Input.menuBelow []
                        [ Input.option "A" (text "Select A")
                        , Input.option "B" (text "Select B")
                        , Input.option "C" (text "Select C")
                        ]
                , placeholder = Just <| text "Place Holder"
                }
            ]
        , section "Regular Html select, to compare the behaviour on mobile"
        , code "<select><option><option></select>"
        , paragraph attrCont
            [ html
                (Html.select []
                    [ Html.option [] [ Html.text "Select A" ]
                    , Html.option [] [ Html.text "Select B" ]
                    , Html.option [] [ Html.text "Select C" ]
                    ]
                )
            ]

        --
        , section "Variation of Input.text"
        , code "username [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.username attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
        , code "newPassword [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.newPassword attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
        , code "currentPassword [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.currentPassword attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
        , code "email [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.email attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
        , code "search [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.search attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
        , code "multiline [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.multiline attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
        , code "spellcheckedMultiline [] { label, onChange, notice, placeholder, text }"
        , paragraph attrCont
            [ Input.spellcheckedMultiline attrA
                { label = Input.labelAbove [] <| text "Label"
                , onChange = Just Input
                , notice = Just <| Input.warningBelow notice <| text "Notice"
                , placeholder = Nothing
                , text = model.text
                }
            ]
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
                { url = "http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0/Element-Input"
                , label = text "mdgriffith/stylish-elephants/Element-Input"
                }
            , text ". The code is in "
            , link [ Font.color orange ]
                { url = "https://github.com/lucamug/elm-spa-boilerplate/blob/master/src/Pages/", label = text "lucamug/elm-spa-boilerplate" }
            , text "."
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


alternateCellAttr : Int -> List (Attribute msg)
alternateCellAttr index =
    if index % 2 == 0 then
        width fill :: attrC
    else
        width fill :: attrB
