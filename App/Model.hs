{-# LANGUAGE TemplateHaskell #-}
--------------------------------------------------------------------------------
-- |
-- Module : App.Model
-- Copyright : (C) 2014 Yorick Laupa
-- License : (see the file LICENSE)
--
-- Maintainer : Yorick Laupa <yo.eight@gmail.com>
-- Stability : provisional
-- Portability : non-portable
--
--------------------------------------------------------------------------------
module App.Model where

--------------------------------------------------------------------------------
import Control.Applicative (liftA2)
import Data.Foldable (traverse_)

--------------------------------------------------------------------------------
import Control.Lens
import Control.Monad.State
import MVC
import Pipes

--------------------------------------------------------------------------------
import App.Type

--------------------------------------------------------------------------------
-- | Represents the state of the application.
data AppState
    = AppState
      { _appSrc  :: Maybe FilePath -- ^ If a source file has been selected
      , _appDest :: Maybe FilePath -- ^ If a destination file has been selected
      }

--------------------------------------------------------------------------------
-- | Make our life easier by deriving some useful lenses
makeLenses ''AppState

--------------------------------------------------------------------------------
initState :: AppState
initState = AppState Nothing Nothing

--------------------------------------------------------------------------------
-- | Application logic
appModel :: Model AppState Inputs Outputs
appModel = asPipe $ for cat $ \i -> do
    case i of
        ISrc path -> do
            appSrc ?= path
            yield $ OSrc path
        IDest path -> do
            appDest ?= path
            yield $ ODest path
        IDoIt -> do
            src  <- use appSrc
            dest <- use appDest
            let zipped = liftA2 (,) src dest
            traverse_ (yield . uncurry ODoIt) zipped
