module Main where

import qualified Terminal.Output as Output
import qualified Terminal.Input as Input
import qualified Data.ByteString as Byte (readFile, ByteString)
import qualified Data.ByteString.Char8 as Char
import Flow
import qualified Model
import qualified Data.List as List
import qualified Data.String as String


main :: IO ()
main = do
    projectData <- Byte.readFile "./project.json"
    putStrLn (getProjectString projectData)
    ready
    Input.await Model.dummy


ready :: IO ()
ready = do
    _ <- Output.say "ready"
    Output.newLine
    putStrLn "Ready"
    Output.newLine


getProjectString :: Byte.ByteString -> String
getProjectString projectData = 
    projectData
        |> Char.split '\n'
        |> List.map Char.unpack
        |> List.unlines