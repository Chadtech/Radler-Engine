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

--         DebugFields fields ->
--             "These are fields -> " ++ (show (fieldsToString fields))


-- fieldsToString :: [ ( String, String ) ] -> String
-- fieldsToString fields =
--     case fields of
--         (key, value) : rest ->
--             key ++ " : " ++ value ++ " , " ++ (fieldsToString rest)

--         [] ->
--             "[]"