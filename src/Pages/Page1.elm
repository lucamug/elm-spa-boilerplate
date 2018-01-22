module Pages.Page1 exposing (..)

import Html exposing (..)


view : a -> Html msg
view model =
    pre [] [ text """Midway upon the journey of our life
I found myself within a forest dark,
For the straightforward pathway had been lost.

Ah me! how hard a thing it is to say
What was this forest savage, rough, and stern,
Which in the very thought renews the fear.

So bitter is it, death is little more;
But of the good to treat, which there I found,
Speak will I of the other things I saw there.""" ]
