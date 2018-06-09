module Data.Part 
    ( readMany
    , Model
    )
    where

import qualified Result
import qualified Debug.Trace as Debug
import qualified Util

data Model
    = Model
        { file :: String
        , length :: Int
        }


readMany :: String -> Result.Result [ Model ]
readMany str =
    Result.Ok []