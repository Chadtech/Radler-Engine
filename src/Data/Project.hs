module Data.Project 
    ( Model
    , name
    , voices
    , beatLength
    , dummy
    ) where


import Data.Voice (Voice)
import qualified Data.Part as Part


data Model =
    Model
    { name :: String
    , parts :: [ Part.Model ]
    , voices :: [ Voice ] 
    , beatLength :: Int
    }


dummy :: Model
dummy =
    Model 
    { name       = "alternation-piece-11"
    , voices     = [] 
    , beatLength = 5000
    }
