module Result
    ( Result(..)
    )
    where


data Result x a 
    = Ok a
    | Err x