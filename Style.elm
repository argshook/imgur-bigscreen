module Style exposing (..)


(=>) : String -> String -> ( String, String )
(=>) key value =
    ( key, value )


type alias CSSRule =
    ( String, String )


root : List CSSRule
root =
    [ "position" => "relative"
    , "background" => "radial-gradient(#2b2b2b 40%, black)"
    ]


image : List CSSRule
image =
    [ "width" => "100vw"
    , "height" => "100vh"
    , "background-size" => "contain"
    , "background-position" => "50% 50%"
    , "background-repeat" => "no-repeat"
    ]


input : List CSSRule
input =
    [ "position" => "absolute"
    , "top" => "3%"
    , "left" => "1%"
    ]


countdown : List CSSRule
countdown =
    [ "position" => "absolute"
    , "display" => "flex"
    , "top" => "3%"
    , "right" => "2%"
    , "justify-content" => "center"
    , "align-items" => "center"
    ]


countdownRange : List CSSRule
countdownRange =
    [ "margin-right" => "10%" ]


countdownButton : List CSSRule
countdownButton =
    [ "color" => "rgb(97, 96, 96)"
    , "font-size" => "1.2rem"
    , "flex-shrink" => "0"
    , "width" => "64px"
    , "height" => "64px"
    , "border" => "5px solid #4a3f3f"
    , "display" => "flex"
    , "justify-content" => "center"
    , "align-items" => "center"
    , "border-radius" => "50%"
    ]
