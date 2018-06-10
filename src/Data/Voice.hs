module Data.Voice 
    ( Model
    , readMany
    ) 
    where


import Data.Int (Int16)
import Data.Note (Note)
import qualified Result
import Flow
import Data.List as List
import Data.List.Split (splitOn)
import qualified Util


data Model 
    = P
    | N
    -- Model
    --     { name :: String }
    -- -- { compileNote :: Note -> [ Int16 ]
    -- -- -- , lineMaker :: [ (Int, Note) ] -> (Note -> [ Int16 ]) -> [ Int16 ]
    -- -- }



fromString :: String -> Result.Result Model
fromString str =
    case Util.trim str of
        "p" ->
            Result.Ok P

        "n" ->
            Result.Ok N

        _ ->
            Result.UnrecognizedVoiceType str
                |> Result.Err


readMany :: String -> Result.Result [ Model ]
readMany str =
    str
        |> splitOn ","
        |> List.map fromString
        |> Result.join