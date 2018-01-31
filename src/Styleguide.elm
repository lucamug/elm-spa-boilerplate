module Styleguide exposing (Data, Model, Msg, htmlPage, init, page, section, update, view)

{-| This simple package generates a page with Style Guides.
It uses certain data structure that each section of the framework expose ([Example](https://lucamug.github.io/elm-styleguide-generator/), [Example source](https://github.com/lucamug/elm-styleguide-generator/blob/master/examples/Main.elm)).

The idea is to have a Living version of the Style Guide that always stays
updated with no maintenance.

For more info about the idea, see [this post](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522).


# Functions

@docs Data, section, page, htmlPage

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


{-| This is the type that is required for Data

Example, inside Framework.Button:

    introspection : Styleguide.Data msg
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
type alias Data msg =
    { name : String
    , signature : String
    , description : String
    , usage : String
    , usageResult : Element Msg
    , types : List ( String, List ( Element msg, String ) )
    , boxed : Bool
    }


type Msg
    = ToggleSection String


init : ( Model, Cmd Msg )
init =
    ( [], Cmd.none )


type alias Model =
    List ( Data Msg, Bool )


type alias SectionId =
    String


view : Model -> Element Msg
view model =
    column []
        -- Html.input [ Html.Events.onInput ToggleSection ] []
        (List.map (\( data, show ) -> section data) model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg |> Debug.log "xxx" of
        ToggleSection section ->
            ( model, Cmd.none )



{-
   main =
       Html.program
           { init = init
           , view = view
           , update = update
           , subscriptions = \_ -> Sub.none
           }
-}


{-| This function create a section of the page based on the input data.

Example:

    section Framework.Button.introspection

-}
section : Data Msg -> Element Msg
section data =
    column
        [ Border.widthEach { top = 1, right = 0, bottom = 0, left = 0 }
        , Border.color gray
        , paddingEach { top = 40, right = 0, bottom = 40, left = 0 }
        , spacing conf.spacing
        ]
        [ el (h2 ++ [ Events.onClick <| ToggleSection "ciao" ]) <| text <| "⟩ " ++ data.name
        , paragraph [] [ text data.description ]
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
page : List (Data Msg) -> Element Msg
page listData =
    row [ width fill ]
        [ column
            [ padding 10
            , Element.attribute (Html.Attributes.style [ ( "max-width", "780px" ) ])
            ]
            ([ el h1 <| text "Style Guide" ]
                ++ List.map section listData
                ++ [ generatedBy ]
            )
        ]


{-| This create the entire page of Html type.

Example, in your Style Guide page:

    main : Html.Html msg
    main =
        Styleguide.htmlPage
            [ Framework.Button.introspection
            , Framework.Color.introspection
            ]

-}
htmlPage : List (Data Msg) -> Html.Html Msg
htmlPage listData =
    layout
        layoutAttributes
    <|
        page listData



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
    el [ paddingXY 0 0, alignLeft ] <|
        paragraph []
            [ text "Generated by "
            , link [ Font.color Color.orange ]
                { url = "http://package.elm-lang.org/packages/lucamug/elm-styleguide-generator/latest"
                , label = text "elm-styleguide-generator"
                }
            ]
