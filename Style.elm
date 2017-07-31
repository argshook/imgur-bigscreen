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
