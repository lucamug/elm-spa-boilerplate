port module Main exposing (main)

import Color
import Element
import Element.Background
import Element.Font
import Element.Hack
import Html
import Html.Attributes
import Html.Events
import Http
import Introspection
import Json.Decode as Decode
import Navigation
import Pages.Page1
import Parts.Button
import Parts.Color
import Parts.LogoElm
import UrlParser exposing ((</>))
import Window


-- ROUTES


routes : List Route
routes =
    [ Top
    , Styleguide
    , Sitemap
    , Debug
    , Page1
    , Page2
    , Page2_1
    ]


type Route
    = Top
    | Styleguide
    | Sitemap
    | Debug
    | Page1
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

        Page1 ->
            { name = "Page one"
            , path = [ "page1" ]
            , view = Pages.Page1.view
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
                    ( { model | apiData = NoData }, Cmd.none )

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
    , title = "Elm Spa Boilerplate"
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
             ]
                ++ common
            )
            (Element.text <| routeName route)
    else
        Element.link
            ([ Element.Font.color Parts.Color.red
             , onLinkClickSE url
             ]
                ++ common
            )
            { url = url
            , label = Element.text <| routeName route
            }


viewMenu : Model -> Element.Element Msg
viewMenu model =
    let
        element =
            if model.device.width < menuBreakPoint then
                Element.column
            else
                Element.row
    in
    element
        [ Element.Background.color Parts.Color.lightOrange
        ]
        (List.map
            (\route -> viewLinkMenu model route)
            routes
        )


viewTopPart : Model -> Element.Element Msg
viewTopPart model =
    Element.column
        [ Element.Background.fittedImage model.bannerSrc
        , Element.Font.color Parts.Color.white
        ]
        [ Element.el [ Element.padding 10 ] <| Parts.LogoElm.orange 50
        , Element.Hack.h1
            [ Html.Attributes.style
                [ ( "text-shadow", "1px 0 1px black" )
                , ( "text-align", "center" )
                ]
            ]
            [ Html.text "Elm Spa Boilerplate" ]
        ]


viewMiddelPart : Model -> Element.Element Msg
viewMiddelPart model =
    Element.column [ Element.padding 30 ]
        [ Element.Hack.h2 [] [ Html.text <| routeName model.route ]
        , routeView model.route model
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
        , Element.Background.color Parts.Color.elmOrange
        , Element.padding 30
        , Element.Font.color Parts.Color.white
        ]
        [ made "凸" "lucamug"
        , Element.el [] <|
            Element.text <|
                "ver. "
                    ++ model.packVersion
                    ++ " elm-ver. "
                    ++ model.packElmVersion
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
        , Element.Font.color Parts.Color.fontColor
        , Element.Background.color Color.white
        ]
    <|
        Element.column []
            [ viewTopPart model
            , viewMenu model
            , viewMiddelPart model
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
    Element.paragraph []
        (List.map
            (\( item, name ) ->
                Element.paragraph []
                    [ Element.Hack.h4 [] [ Html.text name ]
                    , Element.text item
                    ]
            )
         <|
            modelIntrospection model
        )


viewTop : Model -> Element.Element Msg
viewTop model =
    Element.column []
        [ Element.paragraph [] [ Element.text "This is a boilerplate for an Elm Single Page Application." ]
        , Element.paragraph []
            [ Element.text "Find a detailed post at "
            , Element.link []
                { url = "https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2"
                , label = Element.text "https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2"
                }
            ]
        , Element.paragraph []
            [ Element.text "The code is at "
            , Element.link [] { url = "https://github.com/lucamug/elm-spa-boilerplate2", label = Element.text "https://github.com/lucamug/elm-spa-boilerplate2" }
            ]
        , Element.Hack.h3 [] [ Html.text "Ajax request example" ]
        , case model.apiData of
            NoData ->
                Element.column []
                    [ Element.paragraph []
                        [ Parts.Button.largeImportant
                            []
                            (Element.text "My IP is...")
                          <|
                            Just (FetchApiData "https://httpbin.org/delay/1")
                        ]
                    , Element.paragraph [] [ Element.text <| "Your IP is ..." ]
                    ]

            Fetching ->
                Element.column []
                    [ Element.paragraph []
                        [ Parts.Button.largeImportantWithSpinner
                            []
                            (Element.text "My IP is...")
                            Nothing
                        ]
                    , Element.paragraph [] [ Element.text <| "Your IP is ..." ]
                    ]

            Fetched ip ->
                Element.column []
                    [ Element.paragraph []
                        [ Parts.Button.largeImportant
                            []
                            (Element.text "My IP is...")
                          <|
                            Just <|
                                FetchApiData "https://httpbin.org/delay/1"
                        ]
                    , Element.paragraph [] [ Element.text <| "Your IP is " ++ ip ]
                    ]
        , Element.Hack.h3 [] [ Html.text "Local Storage" ]
        , Element.paragraph [] [ Element.text "Example of local storage implementation using flags and ports. The value in the input field below is automatically read and written into localStorage.spa." ]
        , Element.html
            (Html.label []
                [ Html.text "localStorage"
                , Html.input
                    [ Html.Attributes.style [ ( "font-size", "18px" ), ( "padding", "10px 14px" ) ]
                    , Html.Attributes.value model.localStorage
                    , Html.Events.onInput UpdateLocalStorage
                    ]
                    []
                ]
            )
        ]


viewStyleguide : Model -> Element.Element Msg
viewStyleguide model =
    Element.column []
        [ Element.text "This is a Living Style Guide automatically generated from the code."
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
              , view = \row -> row.link1
              }
            , { header = Element.text ""
              , view = \row -> row.link2
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
        { url = "https://github.com/lucamug/elm-spa-boilerplate2"
        , label = Element.text "Fork me on GitHub"
        }



-- MADE BY LUCAMUG


made : String -> String -> Element.Element msg
made with by =
    Element.link
        [ Element.Font.color Color.white
        , Element.Hack.class "made-by"
        ]
        { url = "https://github.com/" ++ by
        , label =
            Element.row []
                [ Element.Hack.styleElement ".made-by:hover .made-by-spin {transform: rotate(0deg);}"
                , Element.text "made with "
                , Element.el
                    [ Element.Font.color Color.red
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
