module MyWorkspaces
( myWorkspaces
, wsTerm, wsNet, wsEdit, wsPlace, wsMail, ws6, ws7, ws8, ws9
) where

-- hooks --
import XMonad.Hooks.DynamicLog

------------------------------------------------------------------------

-- Workspaces
myWorkspacenames = ["term", "net", "edit", "place", "mail", "ζ", "η", "θ", "ι"]

myWorkspaces :: [String]
myWorkspaces = clickable . map dzenEscape $ myWorkspacenames
    where clickable l = [ x ++ ws ++ "^ca()^ca()^ca()" |
                        (i,ws) <- zip "123456789" l,
                        let n = i
                            x = "^ca(1,xdotool key super+" ++ show n ++ ")"]


[wsTerm, wsNet, wsEdit, wsPlace, wsMail, ws6, ws7, ws8, ws9] = myWorkspaces 
