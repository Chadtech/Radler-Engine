module Model where


data Model
    = Model
        { name :: String }


dummy :: Model
dummy =
    Model
        { name = "alternation-piece-12" }