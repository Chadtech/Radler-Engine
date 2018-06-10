module Main where

import qualified Terminal.Output as Output
import qualified Terminal.Input as Input
import qualified Data.ByteString as Byte (readFile, ByteString)
import qualified Data.ByteString.Char8 as Char
import Flow
import qualified Model
import qualified Data.List as List
import qualified Data.String as String
import qualified Result
import qualified Debug.Trace as Debug


main :: IO ()
main = do
    projectData <- Byte.readFile "./project"
    awaitIfLoaded (Model.fromProjectData projectData)


awaitIfLoaded :: Result.Result Model.Model -> IO ()
awaitIfLoaded result =
    case result of
        Result.Ok model -> do
            ready ((Model.name model))
            Input.await model

        Result.Err err -> do
            putStrLn (show (Result.problemToString err))


ready :: String -> IO ()
ready str = do
    _ <- Output.say ("ready " ++ str)
    Output.newLine
    putStrLn "Ready"
    Output.newLine


