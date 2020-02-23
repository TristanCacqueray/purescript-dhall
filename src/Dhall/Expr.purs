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

module Dhall.Expr where

import Prelude
import Data.Array (fromFoldable)
import Data.String.Utils (repeat)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)

-- The dhall gramar
data DhallExpr = DhallLiteralValue String
               | DhallRecord (List DhallAttribute)

data DhallAttribute = Attribute { key :: String, value :: DhallExpr }


-- Show implementation
showIndent :: Int -> String
showIndent count = case repeat (count * 4) " " of
  Just s -> s
  Nothing -> ""

showAttribute :: Int -> DhallAttribute -> String
showAttribute indent (Attribute a) = (showIndent indent) <> a.key <> ": " <> showExpr indent a.value

showAttributes :: Int -> List DhallAttribute -> String
showAttributes indent xs = (joinWith "\n" $ (map (showAttribute (indent + 1)) (fromFoldable xs)))

showExpr :: Int -> DhallExpr -> String
showExpr indent (DhallLiteralValue l) = l
showExpr indent (DhallRecord r) = "{\n" <> showAttributes indent r <> "\n" <> indent_ <> "}"
  where indent_ ∷ String
        indent_ = showIndent indent

instance showExpr' :: Show DhallExpr where
  show = showExpr 0


-- Eq implementation
derive instance eqExpr :: Eq DhallExpr
derive instance eqAttribute :: Eq DhallAttribute
