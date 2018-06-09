module Data.Project 
    ( Model
    , name
    , voices
    , beatLength
    , dummy
    , fromString
    ) where


import Data.Voice (Voice)
import qualified Data.Part as Part
import qualified Result (Result)
import qualified Data.List as List
import Data.List.Split (splitOn)
import Text.Regex.Posix
import Flow
import qualified Result

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
    { name = "alternation-piece-11"
    , parts  = []
    , voices   = []
    , beatLength = 5000
    }


fromString :: String -> Result.Result Model
fromString str =
    splitOn "\n" str
        |> toFields
        |> List.filter ((/=) "")
        |> List.map toKeyValues
        |> Result.join
        |> Result.andThen fromKeyValues


fromKeyValues :: [ (String, String) ] -> Result.Result Model
fromKeyValues fields =
    Result.DebugFields fields
        |> Result.Err

toKeyValues :: String -> Result.Result (String, String)
toKeyValues str =
    case splitOn "=" str of
        key : value : [] ->
            Result.Ok (key, value)

        _ ->
            Result.FieldIsntKeyValue str
                |> Result.Err


toFields :: [ String ] -> [ String ]
toFields lines =
    case lines of
        first : (' ' : second) : rest ->
            toFields ((first ++ (' ' : second)) : rest)

        first : second : rest ->
            first : toFields (second : rest)

        first : [] ->
            first : []


isntNewLine :: Char -> Bool
isntNewLine c =
    c /= '\n'


isNewField :: String -> Bool
isNewField str =
    str =~ "^[a-z]*"