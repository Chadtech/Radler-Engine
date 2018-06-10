module Data.Project 
    ( Model
    , name
    , parts
    , fromString
    ) where


import qualified Data.Voice as Voice
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
    , voices :: [ Voice.Model ] 
    , seed :: Int
    , timingVariance :: Int
    , beatLength :: Int
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
            if thisKey == key then
                Just thisVal
            else
                getField rest key

        [] ->
            Nothing


fromKeyValues :: [ (String, String) ] -> Result.Result Model
fromKeyValues fields =
    let
        ctor =
            construct fields
    in
    Result.Ok Model
        |> ctor "name" readName
        |> ctor "parts" Part.readMany
        |> ctor "voices" Voice.readMany
        |> ctor "seed" (useInt Result.CouldNotParseSeed)
        |> ctor "timing-variance" (useInt Result.CouldNotParseTimingVariance)
        |> ctor "beat-length" (useInt Result.CouldNotParseBeatLength)


readName :: String -> Result.Result String
readName str =
    Result.Ok str


useInt :: (String -> Result.Problem) -> String -> Result.Result Int
useInt problemCtor str =
    let
        trimmedStr =
            Util.trim str
    in
    case Util.readInt trimmedStr of
        Just int ->
            Result.Ok int

        Nothing ->
            problemCtor trimmedStr
                |> Result.Err


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

