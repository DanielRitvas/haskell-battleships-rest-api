module Move (Coordinates, ResultType(..), Move(..), Role(..), emptyMove, firstMove, someGameMoves) where

type Coordinates = (String, String)
data ResultType = HIT | MISS | UNKNOWN | NONE deriving (Eq,Ord,Enum,Show)

data Move = Empty | ValidMove { coords :: Coordinates
                        , result :: ResultType
                        , prev :: Move } deriving (Show, Eq)

data Role = A | B deriving (Eq,Ord,Enum,Show)

emptyMove = ValidMove ("", "") NONE Empty
firstMove = ValidMove ("A", "1") UNKNOWN Empty

someGameMoves = ValidMove {coords = ("B","1"), result = HIT, prev = ValidMove {coords = ("A","1"), result = NONE, prev = Empty}}