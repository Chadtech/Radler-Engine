module Model 
    ( Model
    , name
    , dummy
    )
    where


import qualified Data.Part as Part
import qualified Data.Project as Project

data Model
    = Model
        { project :: Project.Model
        }


dummy :: Model
dummy =
    Model
        { project = Project.dummy 
        }


name :: Model -> String
name model =
    Project.name (project model)