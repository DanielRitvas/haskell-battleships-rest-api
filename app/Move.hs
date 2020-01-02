module Move (Coordinates, ResultType(..), Move(..), Role(..), emptyMove, firstMove, someGameMoves) where

type Coordinates = (String, String)
data ResultType = HIT | MISS | UNKNOWN | NONE deriving (Eq,Ord,Enum,Show)

data Move = Empty | ValidMove { coords :: Coordinates
                        , result :: ResultType
                        , prev :: Move } deriving (Show, Eq)

data Role = A | B deriving (Eq,Ord,Enum,Show)

emptyMove = ValidMove ("", "") NONE Empty
firstMove = ValidMove ("A", "1") UNKNOWN Empty

someGameMoves = ValidMove {coords = ("F","2"), result = UNKNOWN, prev = ValidMove {coords = ("E","2"), result = MISS, prev = ValidMove {coords = ("E","2"), result = MISS, prev = ValidMove {coords = ("D","2"), result = MISS, prev = ValidMove {coords = ("D","2"), result = MISS, prev = ValidMove {coords = ("C","2"), result = MISS, prev = ValidMove {coords = ("C","2"), result = MISS, prev = ValidMove {coords = ("B","2"), result = MISS, prev = ValidMove {coords = ("B","2"), result = MISS, prev = ValidMove {coords = ("A","2"), result = MISS, prev = ValidMove {coords = ("A","2"), result = HIT, prev = ValidMove {coords = ("J","1"), result = HIT, prev = ValidMove {coords = ("J","1"), result = HIT, prev = ValidMove {coords = ("I","1"), result = HIT, prev = ValidMove {coords = ("I","1"), result = MISS, prev = ValidMove {coords = ("H","1"), result = MISS, prev = ValidMove {coords = ("H","1"), result = MISS, prev = ValidMove {coords = ("G","1"), result = MISS, prev = ValidMove {coords = ("G","1"), result = MISS, prev = ValidMove {coords = ("F","1"), result = MISS, prev = ValidMove {coords = ("F","1"), result = MISS, prev = ValidMove {coords = ("E","1"), result = MISS, prev = ValidMove {coords = ("E","1"), result = HIT, prev = ValidMove {coords = ("D","1"), result = HIT, prev = ValidMove {coords = ("D","1"), result = HIT, prev = ValidMove {coords = ("C","1"), result = HIT, prev = ValidMove {coords = ("C","1"), result = HIT, prev = ValidMove {coords = ("B","1"), result = HIT, prev = ValidMove {coords = ("B","1"), result = HIT, prev = ValidMove {coords = ("A","1"), result = NONE, prev = Empty}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}