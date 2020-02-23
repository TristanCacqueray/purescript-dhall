module Main where

import Prelude (Unit, show, ($), (<>))

import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console (log)

import Dhall.Parser (parse)


main :: Effect Unit
main = do log $ handle $ parse testVal
  where testVal =   "{ toto : Text , tata : List Text , titi : { k : Bool, j : Natural }}"
        sVal = "{ toto : Text, tata : Bool }"
        handle result = case result of
          Right actual -> "success: " <> show actual
          Left err -> "error: " <> show err
