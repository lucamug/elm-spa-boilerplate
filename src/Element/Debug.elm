module Element.Debug exposing (..)

--import Element
--import Element.Font
--import Html
--import Html.Attributes
--import Window

import Element
import Element.Border
import Parts.Color


redBorder : List (Element.Attribute msg)
redBorder =
    [ Element.Border.width 1
    , Element.Border.color Parts.Color.red
    ]
