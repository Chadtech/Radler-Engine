module Main where

import qualified Terminal.Output as Output
import qualified Terminal.Input as Input
import qualified Data.ByteString as Byte (readFile, ByteString)
import qualified Data.ByteString.Char8 as Char
import Flow
import qualified Model

main :: IO ()
main = do
    -- projectData <- Byte.readFile "./project.project"
    -- let lines = parseLines projectData
    ready
    Input.await Model.dummy


ready :: IO ()
ready = do
    _ <- Output.say "ready"
    Output.newLine
    putStrLn "Ready"
    Output.newLine



-- parseLines :: Byte.ByteString -> [ String ]
-- parseLines projectData = 
--     projectData
--         |> Char.split '\n'
--         |> map Char.unpack