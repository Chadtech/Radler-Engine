module Data.Project 
    ( Model
    , name
    , voices
    , beatLength
    , dummy
    ) where


import Data.Voice (Voice)


data Model =
    Model
    { name :: String
    , voices :: [ Voice ] 
    , beatLength :: Int
    -- , timing :: [ Int ]
    }


dummy :: Model
dummy =
    Model 
    { name       = "alternation-piece-11"
    , voices     = [] 
    , beatLength = 5000
    }
