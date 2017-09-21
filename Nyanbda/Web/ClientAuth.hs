{-# LANGUAGE OverloadedStrings, TypeFamilies, FlexibleInstances #-}
module Nyanbda.Web.ClientAuth (withAuth, authDialog) where
import Haste.App
import Haste.DOM
import Haste.Events
import System.IO.Unsafe
import Data.IORef
import Nyanbda.Web.API

{-# NOINLINE authref #-}
authref :: IORef Auth
authref = unsafePerformIO $ newIORef (Auth "" "")

type family Unauthed a where
  Unauthed (Client a)  = Auth -> Client a
  Unauthed (a -> b)    = a -> Unauthed b

class Authable a where
  withAuth :: Unauthed a -> a

instance Authable (Client a) where
  withAuth m = do
    auth <- liftIO $ readIORef authref
    m auth

instance Authable b => Authable (a -> b) where
  withAuth f x = withAuth (f x)

setAuth :: String -> String -> Client ()
setAuth u p = liftIO $ writeIORef authref (Auth u p)

-- | Show a login dialog, perform the given action once the user submits their
--   username or password.
authDialog :: Client () -> Client ()
authDialog go = do
  user <- newElem "input" `with`
    [ "type" =: "text"
    , "placeholder" =: "Username"
    , style "display" =: "block"
    , style "margin" =: "1em"
    , style "font-size" =: "large"
    , style "width" =: "83%"
    ]
  pass <- newElem "input" `with`
    [ "type" =: "password"
    , "placeholder" =: "Password"
    , style "display" =: "block"
    , style "margin" =: "1em"
    , style "font-size" =: "large"
    , style "width" =: "83%"
    ]
  btn <- newElem "button" `with`
    [ "innerText" =: "Log in"
    , style "margin-left" =: "1em"
    , style "font-size" =: "large"
    ]
  msg <- newTextElem "Please enter your username and password to continue."
  dlg <- newElem "div" `with`
    [ "className" =: "auth-dialog"
    , style "position" =: "absolute"
    , style "margin" =: "auto"
    , style "top" =: "10%"
    , style "left" =: "0"
    , style "right" =: "0"
    , style "width" =: "20em"
    , style "height" =: "11em"
    , style "border" =: "1px solid black"
    , style "background-color" =: "white"
    , style "padding" =: "2em"
    , style "box-shadow" =: "0.5em 0.5em 0.5em grey"
    , children [msg, user, pass, btn]
    ]
  cover <- newElem "div" `with`
    [ style "zIndex" =: "2000000000"
    , style "position" =: "fixed"
    , style "margin" =: "0"
    , style "padding" =: "0"
    , style "top" =: "0"
    , style "left" =: "0"
    , style "width" =: "100%"
    , style "height" =: "100%"
    , style "background-color" =: "white"
    , children [dlg]
    ]
  let login = do
        u <- getProp user "value"
        p <- getProp pass "value"
        setAuth u p
        deleteChild documentBody cover
        go
  btn `onEvent` Click $ \_ -> login
  user `onEvent` KeyPress $ \13 -> login
  pass `onEvent` KeyPress $ \13 -> login
  appendChild documentBody cover
  focus user
