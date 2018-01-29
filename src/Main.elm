port module Main exposing (main)

import Element exposing (..)
import Element.Area as Area
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Hack as Hack
import Element.Input as Input
import Framework.Button
import Framework.Color
import Html
import Html.Events
import Http
import Json.Decode as Decode
import Navigation
import Pages.Examples
import Parts.Button
import Parts.Color
import Parts.LogoElm
import Parts.Spinner
import Styleguide
import UrlParser exposing ((</>))
import Window


-- ROUTES


routes : List Route
routes =
    [ Top
    , Framework
    , Styleguide
    , Examples
    , Sitemap
    , Debug

    --, Page2
    --, Page2_1
    ]


type Route
    = Top
    | Framework
    | Styleguide
    | Sitemap
    | Debug
    | Examples
    | Page2
    | Page2_1
    | NotFound


type alias RouteData =
    { name : String
    , path : List String
    , view : Model -> Element Msg
    }


routeData : Route -> RouteData
routeData route =
    case route of
        Top ->
            { name = "Intro"
            , path = []
            , view = viewTop
            }

        Framework ->
            { name = "Framework 1"
            , path = [ "framework" ]
            , view = viewFramework
            }

        Styleguide ->
            { name = "Framework 2"
            , path = [ "styleguide" ]
            , view = viewStyleguide
            }

        Sitemap ->
            { name = "Sitemap"
            , path = [ "sitemap" ]
            , view = viewSitemap
            }

        Debug ->
            { name = "Debug"
            , path = [ "debug" ]
            , view = viewDebug
            }

        Examples ->
            { name = "stylish-elephants"
            , path = [ "examples" ]
            , view = Pages.Examples.view
            }

        Page2 ->
            { name = "Page two"
            , path = [ "page2" ]
            , view = viewPage2
            }

        Page2_1 ->
            { name = "Page two.one"
            , path = [ "page2", "subpage1" ]
            , view = viewPage2_1
            }

        NotFound ->
            { name = "Page Not Found"
            , path = []
            , view = \_ -> text "Page not found"
            }


routePath : Route -> List String
routePath route =
    .path <| routeData route


pathSeparator : String
pathSeparator =
    "/"


routePathJoined : Route -> String
routePathJoined route =
    pathSeparator ++ String.join pathSeparator (routePath route)


routeName : Route -> String
routeName route =
    .name <| routeData route


routeView : Route -> Model -> Element Msg
routeView route =
    .view <| routeData route


matchers : UrlParser.Parser (Route -> a) a
matchers =
    UrlParser.oneOf
        (List.map
            (\route ->
                let
                    listPath =
                        routePath route
                in
                if List.length listPath == 0 then
                    UrlParser.map route UrlParser.top
                else if List.length listPath == 1 then
                    UrlParser.map route (UrlParser.s <| firstElement listPath)
                else if List.length listPath == 2 then
                    UrlParser.map route
                        ((UrlParser.s <| firstElement listPath)
                            </> (UrlParser.s <| secondElement listPath)
                        )
                else
                    UrlParser.map route UrlParser.top
            )
            routes
        )


locationToRoute : Navigation.Location -> Route
locationToRoute location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFound



-- PORTS


type alias Flag =
    { localStorage : String
    , packVersion : String
    , packElmVersion : String
    , bannerSrc : String
    , width : Int
    , height : Int
    }


port urlChange : String -> Cmd msg


port storeLocalStorage : Maybe String -> Cmd msg


port onLocalStorageChange : (Decode.Value -> msg) -> Sub msg



-- TYPES


type Msg
    = ChangeLocation String
    | UrlChange Navigation.Location
    | NewApiData (Result Http.Error DataFromApi)
    | FetchApiData String
    | SetLocalStorage (Result String String)
    | UpdateLocalStorage String
    | WindowSize Window.Size


type alias Model =
    { route : Route
    , history : List String
    , apiData : ApiData
    , location : Navigation.Location
    , title : String
    , localStorage : String
    , packVersion : String
    , packElmVersion : String
    , bannerSrc : String
    , device : Hack.Device
    }


modelIntrospection : Model -> List ( String, String )
modelIntrospection model =
    [ ( toString model.route, "route" )
    , ( toString model.history, "history" )
    , ( toString model.apiData, "apiData" )
    , ( toString model.location, "location" )
    , ( toString model.title, "title" )
    , ( toString model.localStorage, "localStorage" )
    , ( toString model.packVersion, "packVersion" )
    , ( toString model.packElmVersion, "packElmVersion" )
    , ( toString model.bannerSrc, "bannerSrc" )
    , ( toString model.device, "device" )
    ]


type ApiData
    = NoData
    | Fetching
    | Fetched String



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation location ->
            ( model, Navigation.newUrl location )

        UrlChange location ->
            let
                newRoute =
                    locationToRoute location

                newHistory =
                    location.pathname :: model.history

                newTitle =
                    routeName newRoute ++ " - " ++ model.title
            in
            ( { model | route = newRoute, history = newHistory, location = location }
            , urlChange newTitle
            )

        NewApiData result ->
            case result of
                Ok data ->
                    ( { model | apiData = Fetched data.origin }, Cmd.none )

                Err data ->
                    ( { model | apiData = Fetched <| toString data }, Cmd.none )

        FetchApiData url ->
            ( { model | apiData = Fetching }
            , Http.send NewApiData (Http.get url apiDecoder)
            )

        SetLocalStorage result ->
            case result of
                Ok value ->
                    ( { model | localStorage = value }, Cmd.none )

                Err value ->
                    ( model, Cmd.none )

        UpdateLocalStorage value ->
            ( { model | localStorage = value }, storeLocalStorage <| Just value )

        WindowSize wsize ->
            ( { model | device = Hack.classifyDevice <| wsize }, Cmd.none )



-- INIT


initModel : Flag -> Navigation.Location -> Model
initModel flag location =
    { route = locationToRoute location
    , history = [ location.pathname ]
    , apiData = NoData
    , location = location
    , title = "Spa Boilerplate"
    , localStorage = flag.localStorage
    , packVersion = flag.packVersion
    , packElmVersion = flag.packElmVersion
    , bannerSrc = flag.bannerSrc
    , device = Hack.classifyDevice <| Window.Size flag.width flag.height
    }


initCmd : Model -> Navigation.Location -> Cmd Msg
initCmd model location =
    Cmd.batch
        -- [ Task.perform WindowSize Window.size ]
        []


init : Flag -> Navigation.Location -> ( Model, Cmd Msg )
init flag location =
    let
        model =
            initModel flag location

        cmd =
            initCmd model location
    in
    ( model, cmd )



-- API DECODER


type alias DataFromApi =
    { origin : String
    , data : String
    }


apiDecoder : Decode.Decoder DataFromApi
apiDecoder =
    Decode.map2 DataFromApi
        (Decode.at [ "origin" ] Decode.string)
        (Decode.at [ "data" ] Decode.string)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map SetLocalStorage <| onLocalStorageChange (Decode.decodeValue Decode.string)
        , Window.resizes WindowSize
        ]



-- VIEWS


viewLinkMenu : Model -> Route -> Element Msg
viewLinkMenu model route =
    let
        url =
            routePathJoined route

        common =
            if model.device.width < menuBreakPoint then
                [ padding 10
                , width fill
                ]
            else
                [ padding 10
                ]
    in
    if model.route == route then
        el
            ([ Background.color Parts.Color.white
             , Font.color Parts.Color.font
             ]
                ++ common
            )
            (text <| routeName route)
    else
        link
            ([ onLinkClickSE url
             ]
                ++ common
            )
            { url = url
            , label = text <| routeName route
            }


viewMenu : Model -> Element Msg
viewMenu model =
    let
        menuList =
            List.map
                (\route -> viewLinkMenu model route)
                routes
    in
    if model.device.width < menuBreakPoint then
        column
            [ Background.color Parts.Color.background
            , Font.color Parts.Color.onBackground
            ]
            menuList
    else
        row
            [ Background.color Parts.Color.background
            , Font.color Parts.Color.onBackground
            ]
            menuList


viewTopPart : Model -> Element Msg
viewTopPart model =
    column
        [ Background.fittedImage model.bannerSrc
        , Font.color Parts.Color.white
        , height <| px 200
        ]
        [ el [ padding 10 ] <| Parts.LogoElm.orange 50
        , h1
            [ center
            , Font.shadow { offset = ( 1, 0 ), blur = 1, color = Parts.Color.black }
            ]
          <|
            text model.title
        ]


viewMiddlePart : Model -> Element Msg
viewMiddlePart model =
    row [ width fill ]
        [ column
            [ padding 30
            , Hack.style [ ( "max-width", toString menuBreakPoint ++ "px" ) ]
            ]
            [ h2 [] <| text <| routeName model.route
            , routeView model.route model
            ]
        ]


menuBreakPoint : Int
menuBreakPoint =
    670


viewFooter : Model -> Element msg
viewFooter model =
    let
        element =
            if model.device.width < menuBreakPoint then
                column
            else
                row
    in
    element
        [ spaceEvenly
        , Background.color Parts.Color.background
        , Font.color Parts.Color.onBackground
        , padding 30
        ]
        [ viewMade "凸" "lucamug"
        , el [] <|
            text <|
                "ver. "
                    ++ model.packVersion
        , forkMe
        ]


view : Model -> Html.Html Msg
view model =
    layout
        [ Font.family
            [ Font.external
                { name = "Source Sans Pro"
                , url = "https://fonts.googleapis.com/css?family=Source+Sans+Pro"
                }
            , Font.sansSerif
            ]
        , Font.size 16
        , Font.color Parts.Color.font
        , Background.color Parts.Color.white
        ]
    <|
        column []
            [ viewTopPart model
            , viewMenu model
            , viewMiddlePart model
            , viewFooter model
            ]


onLinkClickSE : String -> Attribute Msg
onLinkClickSE url =
    attribute
        (Html.Events.onWithOptions "click"
            { stopPropagation = False
            , preventDefault = True
            }
            (Decode.succeed (ChangeLocation url))
        )


viewDebug : Model -> Element msg
viewDebug model =
    column []
        (List.map
            (\( item, name ) ->
                column []
                    [ h3 [] <| text <| "► " ++ name
                    , paragraph
                        [ Background.color <| Parts.Color.lightGray
                        , padding 10
                        ]
                        (List.map (\line -> paragraph [] [ text <| line ]) <| String.split "," item)
                    ]
            )
         <|
            modelIntrospection model
        )


viewTop : Model -> Element Msg
viewTop model =
    column [ spacing 20 ]
        [ paragraph []
            [ text "This is a "
            , link [ Font.color Parts.Color.elmOrange ] { url = "https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2", label = text "boilerplate for writing a Single Page Application" }
            , text "."
            ]
        , paragraph []
            [ text "It is written using "
            , link [ Font.color Parts.Color.elmOrange ] { url = "http://elm-lang.org/", label = text "Elm" }
            , text " + "
            , link [ Font.color Parts.Color.elmOrange ] { url = "https://www.npmjs.com/package/create-elm-app", label = text "elm-app" }
            , text " + "
            , link [ Font.color Parts.Color.elmOrange ] { url = "http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0/", label = text "style-elements v5.alpha" }
            , text " + "
            , link [ Font.color Parts.Color.elmOrange ] { url = "http://package.elm-lang.org/packages/lucamug/elm-style-framework/1.0.1", label = text "elm-style-framework" }
            , text " + "
            , link [ Font.color Parts.Color.elmOrange ] { url = "http://package.elm-lang.org/packages/lucamug/elm-styleguide-generator/1.0.1", label = text "elm-styleguide-generator" }
            , text ". So "
            , link [ Font.color Parts.Color.elmOrange ] { url = "https://medium.com/@l.mugnaini/is-the-future-of-front-end-development-without-html-css-and-javascript-e7bb0877980e", label = text "No HTML, No CSS, No Javascript" }
            , text "."
            ]
        , paragraph []
            [ text "Code: "
            , link [ Font.color Parts.Color.elmOrange ] { url = "https://github.com/lucamug/elm-spa-boilerplate", label = text "elm-spa-boilerplate" }
            , text "."
            ]
        , h3 [] <| text "Ajax request example"
        , case model.apiData of
            NoData ->
                column []
                    [ paragraph []
                        [ Parts.Button.largeImportant
                            "My IP is..."
                          <|
                            Just (FetchApiData "https://httpbin.org/delay/1")
                        ]
                    , paragraph [] [ text <| "Your IP is ..." ]
                    ]

            Fetching ->
                column []
                    [ paragraph []
                        [ Parts.Button.largeWithSpinner
                            "My IP is..."
                            Nothing
                        ]
                    , paragraph [] [ text <| "Your IP is ..." ]
                    ]

            Fetched ip ->
                column []
                    [ paragraph []
                        [ Parts.Button.largeImportant
                            "My IP is..."
                          <|
                            Just <|
                                FetchApiData "https://httpbin.org/delay/1"
                        ]
                    , paragraph [] [ text <| "Your IP is " ++ ip ]
                    ]
        , h3 [] <| text "Local Storage"
        , paragraph [] [ text "Example of local storage implementation using flags and ports. The value in the input field below is automatically read and written into localStorage.spa." ]
        , Input.text
            [ Border.width 1
            , Border.color <| Parts.Color.font
            , Border.rounded 10
            , padding 8
            ]
            { onChange = Just UpdateLocalStorage
            , text = model.localStorage
            , placeholder = Nothing
            , label =
                Input.labelLeft [] <|
                    paragraph
                        [ paddingEach { top = 8, right = 20, bottom = 8, left = 0 }
                        ]
                        [ text "Local Storage" ]
            , notice = Nothing
            }
        ]


introduction : Element msg
introduction =
    el [ paddingXY 0 0, alignLeft ] <|
        paragraph []
            [ text "This is a "
            , link [ Font.color Parts.Color.elmOrange ]
                { url = "https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522"
                , label = text "Living Style Guide"
                }
            , text " of "
            , link [ Font.color Parts.Color.elmOrange ]
                { url = "https://github.com/lucamug/elm-style-framework"
                , label = text "elm-style-framework"
                }
            , text " (built on top of "
            , link [ Font.color Parts.Color.elmOrange ]
                { url = "http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0/Element"
                , label = text "style-elements v.4.alpha"
                }
            , text ") automatically generated from Elm code using "
            , link [ Font.color Parts.Color.elmOrange ]
                { url = "https://github.com/lucamug/elm-styleguide-generator"
                , label = text "elm-styleguide-generator"
                }
            , text "."
            ]


viewFramework : Model -> Element Msg
viewFramework model =
    column []
        [ introduction
        , Styleguide.page
            [ Framework.Button.introspection
            , Framework.Color.introspection
            ]
        ]


viewStyleguide : Model -> Element Msg
viewStyleguide model =
    column []
        [ paragraph []
            [ text "This is a Living Style Guide automatically generated from the code. Read more about it in "
            , link [ Font.color Parts.Color.elmOrange ]
                { url = "https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522"
                , label = text "Medium"
                }
            , text "."
            ]
        , Styleguide.page
            [ Parts.Button.introspection
            , Parts.Color.introspection
            , Parts.LogoElm.introspection
            , Parts.Spinner.introspection
            ]
        ]


viewSitemap : Model -> Element Msg
viewSitemap model =
    let
        data =
            List.map
                (\route ->
                    let
                        url =
                            model.location.origin ++ routePathJoined route
                    in
                    { link1 = viewLinkMenu model route
                    , link2 = link [] { url = url, label = text <| url }
                    }
                )
                routes
    in
    table []
        { data =
            data
        , columns =
            [ { header = text ""
              , view = \row -> paragraph [] [ row.link1 ]
              }
            , { header = text ""
              , view = \row -> paragraph [ padding 10 ] [ row.link2 ]
              }
            ]
        }


viewPage2 : Model -> Element Msg
viewPage2 model =
    paragraph []
        [ text """I cannot well repeat how there I entered,
So full was I of slumber at the moment
In which I had abandoned the true way.

But after I had reached a mountain's foot,
At that point where the valley terminated,
Which had with consternation pierced my heart,

Upward I looked, and I beheld its shoulders
Vested already with that planet's rays
Which leadeth others right by every road..""" ]


viewPage2_1 : Model -> Element Msg
viewPage2_1 model =
    paragraph []
        [ text """Then was the fear a little quieted
That in my heart's lake had endured throughout
The night, which I had passed so piteously

And even as he, who, with distressful breath,
Forth issued from the sea upon the shore,
Turns to the water perilous and gazes;

So did my soul, that still was fleeing onward,
Turn itself back to re-behold the pass
Which never yet a living person left.""" ]



-- HELPERS


firstElement : List String -> String
firstElement list =
    Maybe.withDefault "" (List.head list)


secondElement : List String -> String
secondElement list =
    firstElement (Maybe.withDefault [] (List.tail list))



-- MAIN


main : Program Flag Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


forkMe : Element msg
forkMe =
    link []
        { url = "https://github.com/lucamug/elm-spa-boilerplate"
        , label = text "Fork me on GitHub"
        }


viewMade : String -> String -> Element msg
viewMade with by =
    link
        [ Hack.class "made-by"
        ]
        { url = "https://github.com/" ++ by
        , label =
            row []
                [ Hack.styleElement ".made-by:hover .made-by-spin {transform: rotate(0deg);}"
                , text "made with "
                , el
                    [ Font.color <| Parts.Color.red
                    , rotate <| degrees 60
                    , padding 4
                    , Hack.class "made-by-spin"
                    , Hack.style [ ( "transition", "all .4s ease-in-out" ) ]
                    ]
                  <|
                    text with
                , text <| " by " ++ by
                ]
        }


header :
    number
    -> List (Element.Attribute msg)
    -> Element.Element msg
    -> Element.Element msg
header level attributes child =
    let
        fontLevel =
            abs (level - 4)

        fontSize =
            scaledFontSize fontLevel
    in
    Element.el
        ([ Area.heading level
         , Font.size fontSize
         , paddingEach { top = fontSize, right = 0, bottom = fontSize, left = 0 }
         , alignLeft
         , Font.weight 800
         ]
            ++ attributes
        )
        child


h1 : List (Element.Attribute msg) -> Element.Element msg -> Element.Element msg
h1 =
    header 1


h2 : List (Element.Attribute msg) -> Element.Element msg -> Element.Element msg
h2 =
    header 2


h3 : List (Element.Attribute msg) -> Element.Element msg -> Element.Element msg
h3 =
    header 3



{-
   goldenRatio : Float
   goldenRatio =
       1.618
-}


genericRatio : Float
genericRatio =
    1.4


scaledFontSize : Int -> Int
scaledFontSize n =
    round (16 * (genericRatio ^ toFloat n))
