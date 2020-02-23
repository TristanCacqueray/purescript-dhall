-- Copyright 2020 Red Hat
--
-- Licensed under the Apache License, Version 2.0 (the "License"); you may
-- not use this file except in compliance with the License. You may obtain
-- a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
-- License for the specific language governing permissions and limitations
-- under the License.

module Dhall.Parser where

import Prelude (bind, pure, ($))
import Control.Alt ((<|>))
import Control.Lazy (fix)
import Data.Array (some)
import Data.Either (Either)
import Data.List hiding (some)
import Data.String.CodeUnits (fromCharArray)
import Text.Parsing.Parser (ParseError, Parser, runParser)
import Text.Parsing.Parser.Combinators (between, sepBy)
import Text.Parsing.Parser.String (char, oneOf, noneOf, string)

import Dhall.Expr (DhallAttribute(..), DhallExpr(..))

type P a = Parser String a

trimSpace :: P (Array Char) -> P String
trimSpace p = do
  _ <- many $ char ' '
  r <- p
  _ <- many $ char ' '
  pure $ (fromCharArray r)


literalValue :: P DhallExpr
literalValue = do
  v <- trimSpace $ some $ noneOf ['{', ',', '}']
  pure $ DhallLiteralValue v

-- Record takes a combinator parser to enable recursion with Control.Lazy.fix
-- See: https://thimoteus.github.io/posts/2016-05-16-calculator.html
record :: P DhallExpr -> P DhallExpr
record p = do
  k <- between (string "{") (string "}") $ recordKeyType `sepBy` string ","
  pure $ DhallRecord $ k
  where
  recordKeyType = do
    k <- trimSpace $ some $ noneOf [':', '=', '}', '{', '.']
    _ <- some $ oneOf [' ', ':']
    v <- term p
    pure $ Attribute {key : k, value : v}

term :: P DhallExpr -> P DhallExpr
term p = record p <|> literalValue

parse :: String -> Either ParseError DhallExpr
parse expr = runParser expr (fix term)
