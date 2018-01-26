port module Main exposing (main)

-- import Element.Debug exposing (redBorder)

import Element
import Element.Background
import Element.Border
import Element.Font
import Element.Hack
import Element.Input
import Html
import Html.Events
import Http
import Introspection
import Json.Decode as Decode
import Navigation
import Pages.Examples
import Parts.Button
import Parts.Color
import Parts.LogoElm
import Parts.Spinner
import UrlParser exposing ((</>))
import Window


-- ROUTES


routes : List Route
routes =
    [ Top
    , Styleguide
    , Examples
    , Sitemap
    , Debug
    , Page2
    , Page2_1
    ]


type Route
    = Top
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
    , view : Model -> Element.Element Msg
    }


routeData : Route -> RouteData
routeData route =
    case route of
        Top ->
            { name = "Intro"
            , path = []
            , view = viewTop
            }

        Styleguide ->
            { name = "Style Guide"
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
            { name = "Examples"
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
            , view = \_ -> Element.text "Page not found"
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


routeView : Route -> Model -> Element.Element Msg
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
    , device : Element.Hack.Device
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
            ( { model | device = Element.Hack.classifyDevice <| wsize }, Cmd.none )



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

    -- Initial windowSize should come with a flag
    , device = Element.Hack.classifyDevice <| Window.Size flag.width flag.height
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


viewLinkMenu : Model -> Route -> Element.Element Msg
viewLinkMenu model route =
    let
        url =
            routePathJoined route

        common =
            if model.device.width < menuBreakPoint then
                [ Element.padding 10
                , Element.width Element.fill
                ]
            else
                [ Element.padding 10
                ]
    in
    if model.route == route then
        Element.el
            ([ Element.Background.color Parts.Color.white
             , Element.Font.color Parts.Color.font
             ]
                ++ common
            )
            (Element.text <| routeName route)
    else
        Element.link
            ([ onLinkClickSE url
             ]
                ++ common
            )
            { url = url
            , label = Element.text <| routeName route
            }


viewMenu : Model -> Element.Element Msg
viewMenu model =
    let
        menuList =
            List.map
                (\route -> viewLinkMenu model route)
                routes
    in
    if model.device.width < menuBreakPoint then
        Element.column
            [ Element.Background.color Parts.Color.background
            , Element.Font.color Parts.Color.onBackground
            ]
            menuList
    else
        Element.row
            [ Element.Background.color Parts.Color.background
            , Element.Font.color Parts.Color.onBackground
            ]
            menuList


viewTopPart : Model -> Element.Element Msg
viewTopPart model =
    Element.column
        [ Element.Background.fittedImage model.bannerSrc
        , Element.Font.color Parts.Color.white
        , Element.height <| Element.px 200
        ]
        [ Element.el [ Element.padding 10 ] <| Parts.LogoElm.orange 50
        , Element.Hack.h1
            [ Element.center
            , Element.Font.shadow { offset = ( 1, 0 ), blur = 1, color = Parts.Color.black }
            ]
          <|
            Element.text model.title
        ]


viewMiddlePart : Model -> Element.Element Msg
viewMiddlePart model =
    Element.row [ Element.width Element.fill ]
        [ Element.column
            [ Element.padding 30
            , Element.Hack.style [ ( "max-width", toString menuBreakPoint ++ "px" ) ]
            ]
            [ Element.Hack.h2 [] <| Element.text <| routeName model.route
            , routeView model.route model
            ]
        ]


menuBreakPoint : Int
menuBreakPoint =
    670


viewFooter : Model -> Element.Element msg
viewFooter model =
    let
        element =
            if model.device.width < menuBreakPoint then
                Element.column
            else
                Element.row
    in
    element
        [ Element.spaceEvenly
        , Element.Background.color Parts.Color.background
        , Element.Font.color Parts.Color.onBackground
        , Element.padding 30
        ]
        [ viewMade "凸" "lucamug"
        , Element.el [] <|
            Element.text <|
                "ver. "
                    ++ model.packVersion
        , forkMe
        ]


view : Model -> Html.Html Msg
view model =
    Element.layout
        [ Element.Font.family
            [ Element.Font.external
                { name = "Source Sans Pro"
                , url = "https://fonts.googleapis.com/css?family=Source+Sans+Pro"
                }
            , Element.Font.sansSerif
            ]
        , Element.Font.size 16
        , Element.Font.color Parts.Color.font
        , Element.Background.color Parts.Color.white

        -- , Element.Hack.style [ ( "min-height", toString model.device.height ++ "px" ) ]
        ]
    <|
        Element.column []
            [ viewTopPart model
            , viewMenu model
            , viewMiddlePart model
            , viewFooter model
            ]


onLinkClickSE : String -> Element.Attribute Msg
onLinkClickSE url =
    Element.attribute
        (Html.Events.onWithOptions "click"
            { stopPropagation = False
            , preventDefault = True
            }
            (Decode.succeed (ChangeLocation url))
        )


viewDebug : Model -> Element.Element msg
viewDebug model =
    Element.column []
        (List.map
            (\( item, name ) ->
                Element.column []
                    [ Element.Hack.h3 [] <| Element.text <| "► " ++ name
                    , Element.paragraph
                        [ Element.Background.color <| Parts.Color.lightGray
                        , Element.padding 10
                        ]
                        (List.map (\line -> Element.paragraph [] [ Element.text <| line ]) <| String.split "," item)
                    ]
            )
         <|
            modelIntrospection model
        )


viewTop : Model -> Element.Element Msg
viewTop model =
    Element.column [ Element.spacing 20 ]
        [ Element.paragraph []
            [ Element.text "This is a boilerplate for writing a Single Page Application. It is written in "
            , Element.link [ Element.Font.color Parts.Color.elmOrange ] { url = "http://elm-lang.org/", label = Element.text "Elm" }
            , Element.text " and "
            , Element.link [ Element.Font.color Parts.Color.elmOrange ] { url = "http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0/", label = Element.text "style-elements v5" }
            , Element.text " this means: "
            , Element.link [ Element.Font.color Parts.Color.elmOrange ] { url = "https://medium.com/@l.mugnaini/is-the-future-of-front-end-development-without-html-css-and-javascript-e7bb0877980e", label = Element.text "No HTML, No CSS, No Javascript" }
            , Element.text "."
            ]
        , Element.paragraph []
            [ Element.text "Find a detailed post in "
            , Element.link [ Element.Font.color Parts.Color.elmOrange ]
                { url = "https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2"
                , label = Element.text "Medium"
                }
            , Element.text ", the code is in "
            , Element.link [ Element.Font.color Parts.Color.elmOrange ]
                { url = "https://github.com/lucamug/elm-spa-boilerplate", label = Element.text "Github" }
            , Element.text "."
            ]
        , Element.Hack.h3 [] <| Element.text "Ajax request example"
        , case model.apiData of
            NoData ->
                Element.column []
                    [ Element.paragraph []
                        [ Parts.Button.largeImportant
                            "My IP is..."
                          <|
                            Just (FetchApiData "https://httpbin.org/delay/1")
                        ]
                    , Element.paragraph [] [ Element.text <| "Your IP is ..." ]
                    ]

            Fetching ->
                Element.column []
                    [ Element.paragraph []
                        [ Parts.Button.largeWithSpinner
                            "My IP is..."
                            Nothing
                        ]
                    , Element.paragraph [] [ Element.text <| "Your IP is ..." ]
                    ]

            Fetched ip ->
                Element.column []
                    [ Element.paragraph []
                        [ Parts.Button.largeImportant
                            "My IP is..."
                          <|
                            Just <|
                                FetchApiData "https://httpbin.org/delay/1"
                        ]
                    , Element.paragraph [] [ Element.text <| "Your IP is " ++ ip ]
                    ]
        , Element.Hack.h3 [] <| Element.text "Local Storage"
        , Element.paragraph [] [ Element.text "Example of local storage implementation using flags and ports. The value in the input field below is automatically read and written into localStorage.spa." ]
        , Element.Input.text
            [ Element.Border.width 1
            , Element.Border.color <| Parts.Color.font
            , Element.Border.rounded 10
            , Element.padding 8
            ]
            { onChange = Just UpdateLocalStorage
            , text = model.localStorage
            , placeholder = Nothing
            , label =
                Element.Input.labelLeft [] <|
                    Element.paragraph
                        [ Element.paddingEach { top = 8, right = 20, bottom = 8, left = 0 }
                        ]
                        [ Element.text "Local Storage" ]
            , notice = Nothing
            }
        ]


viewStyleguide : Model -> Element.Element Msg
viewStyleguide model =
    Element.column []
        [ Element.paragraph []
            [ Element.text "This is a Living Style Guide automatically generated from the code. Read more about it in "
            , Element.link [ Element.Font.color Parts.Color.elmOrange ]
                { url = "https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522"
                , label = Element.text "Medium"
                }
            , Element.text "."
            ]
        , Introspection.view Parts.Spinner.introspection
        , Introspection.view Parts.Button.introspection
        , Introspection.view Parts.Color.introspection
        , Introspection.view Parts.LogoElm.introspection
        ]


viewSitemap : Model -> Element.Element Msg
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
                    , link2 = Element.link [] { url = url, label = Element.text <| url }
                    }
                )
                routes
    in
    Element.table []
        { data =
            data
        , columns =
            [ { header = Element.text ""
              , view = \row -> Element.paragraph [] [ row.link1 ]
              }
            , { header = Element.text ""
              , view = \row -> Element.paragraph [ Element.padding 10 ] [ row.link2 ]
              }
            ]
        }


viewPage2 : Model -> Element.Element Msg
viewPage2 model =
    Element.paragraph []
        [ Element.text """I cannot well repeat how there I entered,
So full was I of slumber at the moment
In which I had abandoned the true way.

But after I had reached a mountain's foot,
At that point where the valley terminated,
Which had with consternation pierced my heart,

Upward I looked, and I beheld its shoulders
Vested already with that planet's rays
Which leadeth others right by every road.""" ]


viewPage2_1 : Model -> Element.Element Msg
viewPage2_1 model =
    Element.paragraph []
        [ Element.text """Then was the fear a little quieted
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



-- FORK ME ON GITHUB


forkMe : Element.Element msg
forkMe =
    Element.link []
        { url = "https://github.com/lucamug/elm-spa-boilerplate"
        , label = Element.text "Fork me on GitHub"
        }



-- MADE BY LUCAMUG


viewMade : String -> String -> Element.Element msg
viewMade with by =
    Element.link
        [ Element.Hack.class "made-by"
        ]
        { url = "https://github.com/" ++ by
        , label =
            Element.row []
                [ Element.Hack.styleElement ".made-by:hover .made-by-spin {transform: rotate(0deg);}"
                , Element.text "made with "
                , Element.el
                    [ Element.Font.color <| Parts.Color.red
                    , Element.rotate <| degrees 60
                    , Element.padding 4
                    , Element.Hack.class "made-by-spin"
                    , Element.Hack.style [ ( "transition", "all .4s ease-in-out" ) ]
                    ]
                  <|
                    Element.text with
                , Element.text <| " by " ++ by
                ]
        }
