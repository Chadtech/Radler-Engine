module Update (update) where


import Msg (Msg(..))
import qualified Model
import System.Process (callCommand)
import qualified Terminal.Output as Output
import Data.Maybe


update :: Msg -> Model.Model -> (Model.Model, Maybe (IO ()))
update msg model =
    case msg of
        Play ->
            ( model
            , Just (playIo model)
            )

        Build ->
            ( model
            , Just buildIo
            )

        UnrecognizedCmd cmd ->
            ( model
            , Just notRecognizedIo
            )


playIo :: Model.Model -> IO ()
playIo model = do
    Output.say "playing"
    let audioFileName = getAudioFileName model
    callCommand ("play " ++ (Model.name model))
    Output.newLine


getAudioFileName :: Model.Model -> String
getAudioFileName model =
    Model.name model ++ ".wav"


buildIo :: IO ()
buildIo = do
    putStrLn "-- BUILDING"
    Output.say "building"
    Output.newLine


notRecognizedIo :: IO ()
notRecognizedIo = do
    putStrLn "-- Not recognized"
    Output.say "not recognized"
    Output.newLine

