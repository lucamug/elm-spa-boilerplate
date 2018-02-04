module Styleguide exposing (Introspection, Model, Msg, update, view, viewPage, viewSection, viewSections)

{-| This simple package generates a page with Style Guides.
It uses certain data structure that each section of the framework expose ([Example](https://lucamug.github.io/elm-styleguide-generator/), [Example source](https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Main.elm)).

The idea is to have a Living version of the Style Guide that always stays
updated with no maintenance.

For more info about the idea, see [this post](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522).


# Functions

@docs Introspection, Model, Msg, update, view, viewPage, viewSection, viewSections

-}

import Color exposing (gray, rgb)
import Element exposing (..)
import Element.Area as Area
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html
import Html.Attributes


version : String
version =
    "3.0.0"


{-| This is the type that is required for Introspection

Example, inside Framework.Button:

    introspection : Styleguide.Introspection msg
    introspection =
        { name = "Button"
        , signature = "button : List Modifier -> Maybe msg -> String -> Element msg"
        , description = "Buttons accept a list of modifiers, a Maybe msg (for example: \"Just DoSomething\") and the text to display inside the button."
        , usage = "button [ Medium, Success, Outlined ] Nothing \"Button\""
        , usageResult = button [ Medium, Success, Outlined ] Nothing "Button"
        , boxed = False
        , types =
            [ ( "Sizes"
              , [ ( button [ Small ] Nothing "Button", "button [ Small ] Nothing \"Button\"" )
                , ( button [ Medium ] Nothing "Button", "button [ Medium ] Nothing \"Button\"" )
                , ( button [ Large ] Nothing "Button", "button [ Large ] Nothing \"Button\"" )
                ]
              )
            ]
        }

-}
type alias Introspection msg =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , usageResult : Element Msg
    , types : List ( String, List ( Element msg, String ) )
    , boxed : Bool
    }


{-| -}
type Msg
    = ToggleSection String


{-| -}
type alias Model =
    List ( Introspection Msg, Bool )


{-| -}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleSection dataName ->
            let
                toggle ( data, show ) =
                    if data.name == dataName then
                        ( data, not show )
                    else
                        ( data, show )

                newModel =
                    List.map toggle model
            in
            ( newModel, Cmd.none )


{-| -}
viewSections : Model -> Element Msg
viewSections model =
    column []
        (List.map (\( data, show ) -> viewSection data show) model
            ++ [ generatedBy ]
        )


attrOpen : List (Element.Attribute msg)
attrOpen =
    [ Font.color Color.white
    , Background.color Color.orange
    , Background.mouseOverColor Color.lightOrange
    ]


attrClose : List (Element.Attribute msg)
attrClose =
    [ Font.color Color.orange
    , Background.color Color.white
    , Font.mouseOverColor Color.white
    , Background.mouseOverColor Color.orange
    ]


{-| This function create a section of the page based on the input data.

Example:

    section Framework.Button.introspection

-}
viewSection : Introspection Msg -> Bool -> Element Msg
viewSection data show =
    column
        [ Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , Border.color gray
        , paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
        , spacing 0
        ]
        [ el
            (h2
                ++ [ pointer
                   , Events.onClick <| ToggleSection data.name
                   , width fill
                   , paddingEach { top = 20, right = 20, bottom = 20, left = 20 }
                   ]
                ++ (if show then
                        attrOpen
                    else
                        attrClose
                   )
            )
          <|
            paragraph [ alignLeft ]
                [ el
                    [ padding 10
                    , rotate
                        (if show then
                            pi / 2
                         else
                            0
                        )
                    ]
                    (text <|
                        "⟩ "
                    )
                , text <| data.name
                ]
        , if show then
            column [ paddingXY 0 20 ]
                [ paragraph [] [ text data.description ]
                , el h3 <| text "Signature"
                , paragraph codeAttributes [ text <| data.signature ]
                , el h3 <| text "Code Example"
                , paragraph codeAttributes [ text <| data.usage ]
                , el h3 <| text "Result"
                , paragraph [] [ data.usageResult ]
                , column []
                    (List.map
                        (\( title, types ) ->
                            column []
                                [ viewTitle title
                                , viewTypes types data.boxed
                                ]
                        )
                        data.types
                    )
                ]
          else
            text ""
        ]


{-| This create the entire page of Element type. If you are working
with style-elements this is the way to go, so you can customize your page.

Example, in your Style Guide page:

    main : Html.Html msg
    main =
        layout layoutAttributes <|
            column []
                [ ...
                , Styleguide.page
                    [ Framework.Button.introspection
                    , Framework.Color.introspection
                    ]
                ...
                ]

-}
viewPage : Model -> Element Msg
viewPage model =
    row [ width fill ]
        [ column
            [ padding 10
            , Element.attribute (Html.Attributes.style [ ( "max-width", "780px" ) ])
            ]
            ([ el h1 <| text "Style Guide" ]
                ++ List.map (\( data, show ) -> viewSection data show) model
            )
        ]


{-| This create the entire page of Html type.

Example, in your Style Guide page:

    main : Html.Html msg
    main =
        Styleguide.viewHtmlPage
            [ Framework.Button.introspection
            , Framework.Color.introspection
            ]

-}
view : Model -> Html.Html Msg
view model =
    layout
        layoutAttributes
    <|
        viewPage model



-- INTERNAL


layoutAttributes : List (Attribute msg)
layoutAttributes =
    [ Font.family
        [ Font.external
            { name = "Source Sans Pro"
            , url = "https://fonts.googleapis.com/css?family=Source+Sans+Pro"
            }
        , Font.sansSerif
        ]
    , Font.size 16
    , Font.color <| Color.rgb 0x33 0x33 0x33
    , Background.color Color.white
    , padding 20
    ]


viewTitle : String -> Element Msg
viewTitle title =
    el h3 <| text title


viewTypes : List ( Element Msg, String ) -> Bool -> Element Msg
viewTypes list boxed =
    column [] <|
        List.map
            (\( part, name ) -> viewType ( part, name ) boxed)
            list


viewType : ( Element Msg, String ) -> Bool -> Element Msg
viewType ( part, name ) boxed =
    el
        [ paddingEach
            { top = 0
            , right = conf.spacing
            , bottom = conf.spacing
            , left = 0
            }
        , alignBottom
        , width fill
        ]
    <|
        paragraph
            [ spacing conf.spacing
            , width fill
            ]
            [ el [ width (fillPortion 1) ] <|
                el
                    (if boxed then
                        [ padding conf.spacing
                        , Background.color <| rgb 0xEE 0xEE 0xEE
                        , Border.rounded conf.rounding
                        ]
                     else
                        []
                    )
                    part
            , el
                [ width (fillPortion 2)
                , alignTop
                , Font.color <| rgb 0x99 0x99 0x99
                , Font.family [ Font.monospace ]
                , Font.size 14
                ]
              <|
                text <|
                    name
            ]


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
    , Font.size 14
    ]


h1 : List (Element.Attribute msg)
h1 =
    [ Area.heading 1
    , Font.size 28
    , Font.weight 700
    , paddingEach { bottom = 40, left = 0, right = 0, top = 20 }
    ]


h2 : List (Element.Attribute msg)
h2 =
    [ Area.heading 2
    , Font.size 24
    , alignLeft
    , Font.weight 700
    , paddingXY 0 20
    ]


h3 : List (Element.Attribute msg)
h3 =
    [ Area.heading 3
    , Font.size 18
    , alignLeft
    , Font.weight 700
    , paddingXY 0 20
    ]


generatedBy : Element msg
generatedBy =
    el [ paddingXY 0 10, alignLeft, Font.size 14, Font.color Color.darkGray ] <|
        paragraph []
            [ text "Generated by "
            , link [ Font.color Color.orange ]
                { url = "http://package.elm-lang.org/packages/lucamug/elm-styleguide-generator/latest"
                , label = text "elm-styleguide-generator"
                }
            , text <| " version " ++ version
            ]



-- SELF EXAMPLE


introspectionExample : String -> Introspection msg
introspectionExample id =
    { name = "Name " ++ id
    , signature = "Signature " ++ id
    , description = "Description " ++ id
    , usage = "Usage " ++ id
    , usageResult = text <| "Usage result " ++ id
    , boxed = True
    , types =
        [ ( "Type 1, Example " ++ id
          , [ ( text <| "Case 1, Type 1, Example " ++ id, "Code for Case 1, Type 1, Example " ++ id )
            , ( text <| "Case 2, Type 1, Example " ++ id, "Code for Case 1, Type 1, Example " ++ id )
            ]
          )
        , ( "Type 2, Example " ++ id
          , [ ( text <| "Case 1, Type 2, Example " ++ id, "Code for Case 1, Type 2, Example " ++ id )
            , ( text <| "Case 2, Type 2, Example " ++ id, "Code for Case 1, Type 2, Example " ++ id )
            ]
          )
        ]
    }


init : ( Model, Cmd msg1 )
init =
    ( [ ( introspectionExample "A", False )
      , ( introspectionExample "B", False )
      , ( introspectionExample "C", False )
      ]
    , Cmd.none
    )


viewExample : Model -> Html.Html Msg
viewExample model =
    layout layoutAttributes <|
        column []
            [ viewPage model
            ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
