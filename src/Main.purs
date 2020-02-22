module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Dhall.Parser (test)

main :: Effect Unit
main = do
  log test
