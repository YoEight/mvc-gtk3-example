--------------------------------------------------------------------------------
-- |
-- Module : App.Controller
-- Copyright : (C) 2014 Yorick Laupa
-- License : (see the file LICENSE)
--
-- Maintainer : Yorick Laupa <yo.eight@gmail.com>
-- Stability : provisional
-- Portability : non-portable
--
--------------------------------------------------------------------------------
module App.Controller where

--------------------------------------------------------------------------------
import Data.Foldable (traverse_)
import Data.Functor (void)

--------------------------------------------------------------------------------
import qualified Graphics.UI.Gtk as Gtk
import           MVC
import           Pipes.Concurrent

--------------------------------------------------------------------------------
import App.GUI
import App.Type

--------------------------------------------------------------------------------
makeController :: GUI -> Managed (Controller Inputs)
makeController g = managed $ \k -> do
    (output, input, seal) <- spawn' Unbounded

    -- We send ISrc message to the Actor once the user select a source file
    Gtk.on (guiSrcButton g) Gtk.buttonActivated $ do
        opt <- getSelection $ guiOpenFileDialog g
        traverse_ (forkIO . void . atomically . send output . ISrc) opt

    -- We send IDest message to the Actor once the user select
    -- a destination file.
    Gtk.on (guiDestButton g) Gtk.buttonActivated $ do
        opt <- getSelection $ guiSaveFileDialog g
        traverse_ (forkIO . void . atomically . send output . IDest) opt

    -- We just send IDoIt message to the Actor when 'Do it' is clicked
    Gtk.on (guiDoItButton g) Gtk.buttonActivated $
        void $ forkIO $ void $ atomically $ send output IDoIt

    -- We listen to Gtk events in another thread
    forkIO (Gtk.mainGUI >> atomically seal)

    let controller = asInput input
    r <- k controller
    atomically seal
    return r

--------------------------------------------------------------------------------
getSelection :: Gtk.FileChooserDialog -> IO (Maybe FilePath)
getSelection diag = do
    resp <- Gtk.dialogRun diag
    Gtk.widgetHide diag
    case resp of
        Gtk.ResponseOk -> Gtk.fileChooserGetFilename diag
        _              -> return Nothing
