module Entities where
data Msg = Empty | Msg { coord :: (String, String)
                        , result :: String
                        , prev :: Msg } deriving Show
                        
data Value = Available | HIT | Taken

type Ship = [(String, String)]

data Board = Board { ship1 :: Ship
                    , ship2 :: Ship
                    , ship3 :: Ship
                    , ship4 :: Ship
                    , ship5 :: Ship } deriving Show