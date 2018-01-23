module Element.Hack exposing (..)

--import Element.Font

import Element
import Element.Area
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


value : String -> Element.Attribute msg
value value =
    Element.attribute (Html.Attributes.value value)


link : List (Element.Attribute msg) -> Element.Link msg -> Element.Element msg
link attributes urlLabel =
    -- Temporary fix because link doesn't accept colors yet, it is a bug
    Element.el
        attributes
    <|
        Element.link []
            urlLabel


goldenRatio : Float
goldenRatio =
    1.618


genericRatio : Float
genericRatio =
    1.4


scaledFontSize : Int -> Int
scaledFontSize n =
    round (16 * (genericRatio ^ toFloat n))


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
        ([ Element.Area.heading level
         , Element.Font.size fontSize
         , Element.paddingEach { top = fontSize, right = 0, bottom = fontSize, left = 0 }
         , Element.alignLeft
         , Element.Font.weight 800
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


h4 : List (Element.Attribute msg) -> Element.Element msg -> Element.Element msg
h4 =
    header 4
