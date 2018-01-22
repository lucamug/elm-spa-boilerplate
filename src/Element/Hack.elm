module Element.Hack exposing (..)

import Element
import Element.Font
import Html
import Html.Attributes
import Window


type alias Device =
    { width : Int
    , height : Int
    , phone : Bool
    , tablet : Bool
    , desktop : Bool
    , bigDesktop : Bool
    , portrait : Bool
    }


classifyDevice : Window.Size -> Device
classifyDevice { width, height } =
    { width = width
    , height = height
    , phone = width <= 600
    , tablet = width > 600 && width <= 1200
    , desktop = width > 1200 && width <= 1800
    , bigDesktop = width > 1800
    , portrait = width < height
    }


styleElement : String -> Element.Element msg
styleElement text =
    Element.html (Html.node "style" [] [ Html.text text ])


class : String -> Element.Attribute msg
class name =
    Element.attribute (Html.Attributes.class name)


style : List ( String, String ) -> Element.Attribute msg
style style =
    Element.attribute (Html.Attributes.style style)


headersCommon : List (Element.Element msg) -> Element.Element msg
headersCommon elements =
    Element.paragraph
        [ Element.padding 20
        ]
        elements


h1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Element.Element msg
h1 attributes children =
    headersCommon
        [ Element.html <|
            Html.h1 attributes children
        ]


h2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Element.Element msg
h2 attributes children =
    headersCommon
        [ Element.html <|
            Html.h2 attributes children
        ]


h3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Element.Element msg
h3 attributes children =
    headersCommon
        [ Element.html <|
            Html.h3 attributes children
        ]


h4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Element.Element msg
h4 attributes children =
    headersCommon
        [ Element.html <|
            Html.h4 attributes children
        ]
