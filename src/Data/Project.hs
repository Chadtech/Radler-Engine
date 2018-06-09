module Data.Project 
    ( Model
    , name
    -- , voices
    -- , beatLength
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
import qualified Util


data Model =
    Model
    { name :: String
    , parts :: [ Part.Model ]
    -- , voices :: [ Voice ] 
    -- , beatLength :: Int
    }


fromString :: String -> Result.Result Model
fromString str =
    splitOn "\n" str
        |> toFields
        |> List.filter ((/=) "")
        |> List.map toKeyValues
        |> Result.join
        |> Result.andThen fromKeyValues


construct 
    :: [ (String, String) ] 
    -> String 
    -> (String -> Result.Result a) 
    -> Result.Result (a -> b)
    -> Result.Result b
construct fields fieldName reader step =
    case step of
        Result.Ok ctor ->
            case getField fields fieldName of
                Just str ->
                    case reader str of
                        Result.Ok part ->
                            Result.Ok (ctor part)

                        Result.Err problem ->
                            Result.Err problem

                Nothing ->
                    Result.Err (Result.FieldDoesNotExist fieldName)

        Result.Err problem ->
            Result.Err problem


getField :: [ (String, String) ] -> String -> Maybe String
getField fields key =
    case fields of
        (thisKey, thisVal) : rest ->
            if (Util.log_ "KEY" show thisKey) == key then
                Just (Util.log_ "VAL" (\x -> x) thisVal)
            else
                getField rest key

        [] ->
            Nothing


fromKeyValues :: [ (String, String) ] -> Result.Result Model
fromKeyValues fields =
    let
        constructor =
            construct fields
    in
    Result.Ok Model
        |> constructor "name" readName
        |> constructor "parts" Part.readMany


readName :: String -> Result.Result String
readName str =
    Result.Ok str


toKeyValues :: String -> Result.Result (String, String)
toKeyValues str =
    case splitOn "=" str of
        key : value : [] ->
            ( Util.dropLast (Util.trim key)
            , Util.trim value
            )
                |> Result.Ok

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

        _ ->
            lines




isntNewLine :: Char -> Bool
isntNewLine c =
    c /= '\n'


isNewField :: String -> Bool
isNewField str =
    str =~ "^[a-z]*"