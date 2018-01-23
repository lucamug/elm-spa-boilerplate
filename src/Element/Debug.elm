module Element.Debug exposing (..)

--import Element
--import Element.Font
--import Html
--import Html.Attributes
--import Window

import Color
import Element
import Element.Border


addTestBorder : List (Element.Attribute msg) -> List (Element.Attribute msg)
addTestBorder attributes =
    [ Element.Border.width 1
    , Element.Border.color Color.red
    ]
        ++ attributes
