module Elmy where


head :: [ a ] -> Maybe a
head list =
    case list of
        [] ->
            Nothing

        first : rest ->
            Just first


