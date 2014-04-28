--------------------------------------------------------------------------------
-- |
-- Module : App.Type
-- Copyright : (C) 2014 Yorick Laupa
-- License : (see the file LICENSE)
--
-- Maintainer : Yorick Laupa <yo.eight@gmail.com>
-- Stability : provisional
-- Portability : non-portable
--
--------------------------------------------------------------------------------
module App.Type where

--------------------------------------------------------------------------------
-- | Emitted by the Controller
data Inputs = ISrc FilePath
            | IDest FilePath
            | IDoIt

--------------------------------------------------------------------------------
-- | Received by the View
data Outputs = OSrc FilePath
             | ODest FilePath
             | ODoIt FilePath FilePath
