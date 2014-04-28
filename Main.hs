--------------------------------------------------------------------------------
-- |
-- Module : Main
-- Copyright : (C) 2014 Yorick Laupa
-- License : (see the file LICENSE)
--
-- Maintainer : Yorick Laupa <yo.eight@gmail.com>
-- Stability : provisional
-- Portability : non-portable
--
--------------------------------------------------------------------------------
import Data.Functor (void)

--------------------------------------------------------------------------------
import MVC

--------------------------------------------------------------------------------
import App.GUI
import App.Controller
import App.Model
import App.View

--------------------------------------------------------------------------------
main :: IO ()
main = do
    gui <- makeGUI
    let gtk = fmap (\c -> (makeView gui, c)) (makeController gui)
    void $ runMVC initState appModel gtk
