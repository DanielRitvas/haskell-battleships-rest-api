module Move (Coordinates, ResultType(..), Move(..), Role(..), emptyMove, firstMove) where

type Coordinates = (String, String)
data ResultType = HIT | MISS | UNKNOWN | NONE deriving (Eq,Ord,Enum,Show)

data Move = Empty | ValidMove { coords :: Coordinates
                        , result :: ResultType
                        , prev :: Move } deriving (Show, Eq)

data Role = A | B deriving (Eq,Ord,Enum,Show)

emptyMove = ValidMove ("", "") NONE Empty
firstMove = ValidMove ("A", "1") UNKNOWN Empty