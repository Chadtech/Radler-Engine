module Util 
    ( trim
    , dropLast
    , log_
    )
    where

import qualified Data.List as List
import qualified Data.Char as Char
import Flow
import qualified Debug.Trace as Debug



trim :: String -> String
trim = 
    List.dropWhileEnd isntLetter
        >> List.dropWhile isntLetter

isntLetter :: Char -> Bool
isntLetter c =
    not (Char.isLetter c)


dropLast :: String -> String
dropLast str =
    case List.reverse str of
        _ : rest ->
            List.reverse rest

        [] ->
            str

-- Debug --


log_ :: String -> (a -> String) -> a -> a
log_ msg toString x =
    Debug.trace (msg ++ " : " ++ (toString x)) x