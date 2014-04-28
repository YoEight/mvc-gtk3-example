--------------------------------------------------------------------------------
-- |
-- Module : App.GUI
-- Copyright : (C) 2014 Yorick Laupa
-- License : (see the file LICENSE)
--
-- Maintainer : Yorick Laupa <yo.eight@gmail.com>
-- Stability : provisional
-- Portability : non-portable
--
--------------------------------------------------------------------------------
module App.GUI where

--------------------------------------------------------------------------------
import qualified Graphics.UI.Gtk as Gtk

--------------------------------------------------------------------------------
data GUI
    = GUI
      { guiOpenFileDialog :: Gtk.FileChooserDialog
      , guiSaveFileDialog :: Gtk.FileChooserDialog
      , guiWindow         :: Gtk.Window
      , guiSrcButton      :: Gtk.Button
      , guiDestButton     :: Gtk.Button
      , guiDoItButton     :: Gtk.Button
      }

--------------------------------------------------------------------------------
makeGUI :: IO GUI
makeGUI = do
    Gtk.initGUI

    win <- Gtk.windowNew

    -- Open File Dialog
    odialog <- Gtk.fileChooserDialogNew (Just "Choose Source")
               (Just win)
               Gtk.FileChooserActionOpen
               [("Open", Gtk.ResponseOk), ("Cancel", Gtk.ResponseCancel)]

    -- Save File Dialog
    sdialog <- Gtk.fileChooserDialogNew (Just "Choose Destination")
               (Just win)
               Gtk.FileChooserActionSave
               [("Save", Gtk.ResponseOk), ("Cancel", Gtk.ResponseCancel)]

    -- Vbox
    vbox  <- Gtk.vBoxNew True 10
    srcb  <- Gtk.buttonNewWithLabel "Choose source..."
    destb <- Gtk.buttonNewWithLabel "Choose destination..."
    dob   <- Gtk.buttonNewWithLabel "Do it !"
    Gtk.widgetSetSensitive destb False
    Gtk.widgetSetSensitive dob False
    Gtk.containerAdd vbox srcb
    Gtk.containerAdd vbox destb
    Gtk.containerAdd vbox dob

    -- Configure main window
    Gtk.set win [ Gtk.windowTitle          Gtk.:= "MVC File Copier"
                , Gtk.windowDefaultWidth   Gtk.:= 200
                , Gtk.containerBorderWidth Gtk.:= 10
                , Gtk.containerChild       Gtk.:= vbox
                ]
    Gtk.on win Gtk.objectDestroy Gtk.mainQuit
    Gtk.widgetShowAll win

    return GUI{ guiOpenFileDialog = odialog
              , guiSaveFileDialog = sdialog
              , guiWindow         = win
              , guiSrcButton      = srcb
              , guiDestButton     = destb
              , guiDoItButton     = dob
              }
