module Result
    ( Result(..)
    , Problem(..)
    , map
    , andThen
    , join
    , problemToString
    )
    where


import Prelude (String, (++), show)


data Problem
    = FieldIsntKeyValue String
    | FieldDoesNotExist String
    | PartStringCantBeSplitInTwo String
    | PartLengthCouldNotBeParsed String
    | UnrecognizedVoiceType String
    | CouldNotParseSeed String
    | CouldNotParseTimingVariance String
    | CouldNotParseBeatLength String


data Result a 
    = Ok a
    | Err Problem


map :: (a -> b) -> Result a -> Result b
map f result =
    case result of
        Ok v ->
            Ok (f v)

        Err problem ->
            Err problem


andThen :: (a -> Result b) -> Result a -> Result b
andThen f result =
    case result of
        Ok v ->
            f v

        Err problem ->
            Err problem


join :: [ Result a ] -> Result [ a ]
join results =
    joinHelp results []


joinHelp :: [ Result a ] -> [ a ] -> Result [ a ]
joinHelp results vs =
    case results of
        Ok v : rest ->
            joinHelp rest (v : vs)

        Err problem : _ ->
            Err problem

        [] ->
            Ok vs


problemToString :: Problem -> String
problemToString problem =
    case problem of
        FieldIsntKeyValue str ->
            "Field isnt key value -> " ++ str 

        FieldDoesNotExist str ->
            "Field does not exist -> " ++ str

        PartStringCantBeSplitInTwo str ->
            "part string cant be split in two -> " ++ str

        PartLengthCouldNotBeParsed str ->
            "part length could not be parsed -> " ++ show str

        UnrecognizedVoiceType str ->
            "unrecognized voice type -> " ++ show str

        CouldNotParseSeed str ->
            "could not parse into seed -> " ++ show str

        CouldNotParseTimingVariance str ->
            "could not parse timing variance -> " ++ show str

        CouldNotParseBeatLength str ->
            "could not parse beat length -> " ++ show str
            