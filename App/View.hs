--------------------------------------------------------------------------------
-- |
-- Module : App.View
-- Copyright : (C) 2014 Yorick Laupa
-- License : (see the file LICENSE)
--
-- Maintainer : Yorick Laupa <yo.eight@gmail.com>
-- Stability : provisional
-- Portability : non-portable
--
--------------------------------------------------------------------------------
module App.View where

--------------------------------------------------------------------------------
import qualified Graphics.UI.Gtk as Gtk
import           MVC
import           System.FilePath (takeFileName)

--------------------------------------------------------------------------------
import App.GUI
import App.Type

--------------------------------------------------------------------------------
makeView :: GUI -> View Outputs
makeView g = asSink go where
  go (OSrc path) = Gtk.postGUISync $ do
      Gtk.buttonSetLabel (guiSrcButton g) (takeFileName path)
      Gtk.widgetSetSensitive (guiDestButton g) True

  go (ODest path) = Gtk.postGUISync $ do
      Gtk.buttonSetLabel (guiDestButton g) (takeFileName path)
      Gtk.widgetSetSensitive (guiDoItButton g) True

  go (ODoIt from to) = readFile from >>= writeFile to
