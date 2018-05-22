module Data.Voice (Voice) where


import Data.Int (Int16)
import Data.Note (Note)


data Voice =
    Voice
    { compileNote :: Note -> [ Int16 ]
    -- , lineMaker :: [ (Int, Note) ] -> (Note -> [ Int16 ]) -> [ Int16 ]
    }
