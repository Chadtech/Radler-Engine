module Data.Part 
    ( readMany
    , file
    , Model
    )
    where

import qualified Result
import qualified Debug.Trace as Debug
import qualified Util
import Data.List.Split (splitOn)
import Data.List as List
import Flow
import qualified Util


data Model
    = Model
        { file :: String
        , length_ :: Int
        }


fromString :: String -> Result.Result Model
fromString str =
    case splitOn ";" (Util.trim str) of
        fileName : lengthStr : [] ->
            fromTwoStrings fileName (Util.trim lengthStr)

        _ ->
            Result.PartStringCantBeSplitInTwo str
                |> Result.Err


fromTwoStrings :: String -> String -> Result.Result Model
fromTwoStrings fileName lengthStr =
    case Util.readInt lengthStr of
        Just length_ ->
            Model
                { file = fileName
                , length_ = length_
                }
                |> Result.Ok

        Nothing ->
            Result.PartLengthCouldNotBeParsed lengthStr
                |> Result.Err




readMany :: String -> Result.Result [ Model ]
readMany str =
    str
        |> splitOn ","
        |> List.map fromString
        |> Result.join