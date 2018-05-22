module Model where


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