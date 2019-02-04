module Style exposing (CSSRule, countdown, countdownButton, countdownRange, image, input, loader, root, styler, video)

import Html.Attributes
import List


type alias CSSRule =
    ( String, String )


styler =
    List.map
        (\( k, v ) -> Html.Attributes.style k v)


root : List CSSRule
root =
    [ ( "position", "absolute" )
    , ( "top", "0" )
    , ( "right", "0" )
    , ( "bottom", "0" )
    , ( "left", "0" )
    , ( "background", "radial-gradient(rgb(43, 43, 43) 40%, black)" )
    , ( "overflow", "hidden" )
    ]


image : List CSSRule
image =
    [ ( "width", "100%" )
    , ( "height", "100%" )
    , ( "background-size", "contain" )
    , ( "background-position", "50% 50%" )
    , ( "background-repeat", "no-repeat" )
    ]


video : List CSSRule
video =
    [ ( "width", "100%" )
    , ( "height", "100%" )
    , ( "background-size", "contain" )
    , ( "background-position", "50% 50%" )
    , ( "background-repeat", "no-repeat" )
    ]


input : List CSSRule
input =
    [ ( "position", "absolute" )
    , ( "top", "3%" )
    , ( "left", "1%" )
    ]


countdown : List CSSRule
countdown =
    [ ( "position", "absolute" )
    , ( "display", "flex" )
    , ( "top", "3%" )
    , ( "right", "2%" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    ]


countdownRange : List CSSRule
countdownRange =
    [ ( "margin-right", "10%" ) ]


countdownButton : List CSSRule
countdownButton =
    [ ( "color", "rgb(97, 96, 96)" )
    , ( "font-size", "1.2rem" )
    , ( "flex-shrink", "0" )
    , ( "width", "64px" )
    , ( "height", "64px" )
    , ( "border", "5px solid #4a3f3f" )
    , ( "display", "flex" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "border-radius", "50%" )
    ]


loader : List CSSRule
loader =
    [ ( "position", "absolute" )
    , ( "display", "flex" )
    , ( "top", "0" )
    , ( "right", "0" )
    , ( "bottom", "0" )
    , ( "left", "0" )
    , ( "justify-content", "center" )
    , ( "align-items", "center" )
    , ( "color", "#656565" )
    ]
