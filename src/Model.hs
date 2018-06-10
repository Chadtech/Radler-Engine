module Model 
    ( Model
    , name
    , project
    , fromProjectData
    )
    where


import qualified Data.Part as Part
import qualified Data.Project as Project
import qualified Data.ByteString as Byte
import qualified Result
import qualified Data.List as List
import qualified Data.ByteString.Char8 as Char
import Flow


data Model
    = Model
        { project :: Project.Model
        }


name :: Model -> String
name model =
    Project.name (project model)


fromProjectData :: Byte.ByteString -> Result.Result Model
fromProjectData byteString =
    getProjectString byteString
        |> Project.fromString
        |> Result.map fromProject


fromProject :: Project.Model -> Model
fromProject project =
    Model
        { project = project }


getProjectString :: Byte.ByteString -> String
getProjectString projectData = 
    projectData
        |> Char.split '\n'
        |> List.map Char.unpack
        |> List.unlines