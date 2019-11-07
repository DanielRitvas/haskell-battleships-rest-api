module Parser where

import Data.List
import Data.Char

score :: String -> Either String (Int, Int)
score msg =
    case parseGame msg of
        Left e -> Left e
        Right (p1, p2) -> Right (getScore p1 0, getScore p2 0)
    where
        getScore :: [((String, Int), Maybe Bool)] -> Int -> Int
        getScore ((coord, res):g) count =
            case res of
                Nothing -> getScore g count
                Just h ->
                    if h then getScore g $ count + 1
                    else getScore g count
        getScore [] count = count

parseGame :: String -> Either String ([((String, Int), Maybe Bool)], [((String, Int), Maybe Bool)])
parseGame msg = parseGame' msg
    where
        parseGame' :: String -> Either String ([((String, Int), Maybe Bool)], [((String, Int), Maybe Bool)])
        parseGame' msg =
            if msg == "le" then Left "Game has ended"
            else case parseGameCoords msg of
                Left e1 -> Left e1
                Right (coords, m) ->
                    case parseGameResults m of
                        Left e2 -> Left e2
                        Right results ->
                            if ((length coords) - 1) /= (length results) then Left "Game is not correct"
                            else if (validateCoords (first coords)) && (validateCoords (second coords))
                                then Right (first (merge (reverse coords) (Nothing : (reverse results)) []), second (merge (reverse coords) (Nothing : (reverse results)) []))
                                else Left "Repeated coordinates"
        first :: [a] -> [a]
        first (x:y:xs) = x : first xs
        first (x:xs) = x : first xs
        first _ = []
        second :: [a] -> [a]
        second (x:y:xs) = y : second xs
        second _ = []
        merge :: [(String, Int)] -> [Maybe Bool] -> [((String, Int), Maybe Bool)] -> [((String, Int), Maybe Bool)]
        merge ((x, y):c1) (z:r) r1 = merge c1 r $ ((x, y), z) : r1
        merge [] [] r1 = r1

        validateCoords :: [(String, Int)] -> Bool
        validateCoords [] = True
        validateCoords (coord:cr) =
            case validateCoords' coord cr of
                False -> False
                True -> validateCoords cr
            where
                validateCoords' :: (String, Int) -> [(String, Int)] -> Bool
                validateCoords' _ [] = True
                validateCoords' k1 (k2:kr) =
                    if (k1 /= k2) then validateCoords' k1 kr
                    else False

parseGameCoords :: String -> Either String ([(String, Int)], String)
parseGameCoords msg = parse msg []
    where
        parse :: String -> [(String, Int)] -> Either String ([(String, Int)], String)
        parse ('l':m) game =
            case parseMsgString m of
                Left e1 -> Left e1
                Right (s1, r1) ->
                    if s1 /= "coord" then Left $ "Key 'coord' is required " ++ msg
                    else
                        case parseCoords r1 of
                            Left e2 -> Left e2
                            Right ((x, y), r2) ->
                                if (take 1 r2) == "e" then Right ((x, y) : game, drop 1 r2)
                                else
                                    case parseMsgString r2 of
                                        Left e3 -> Left e3
                                        Right (s3, r3) ->
                                            if s3 /= "prev" then Left "Key 'prev' is required"
                                            else parse r3 $ (x, y) : game
        parse _ _ = Left "'l' missing"

parseGameResults :: String -> Either String [Maybe Bool]
parseGameResults msg = parse msg []
    where
        parse :: String -> [Maybe Bool] -> Either String [Maybe Bool]
        parse [] results = Right results
        parse m results =
                case parseMsgString m of
                    Left e1 -> Left e1
                    Right (s1, r1) ->
                        if s1 /= "result" then Left "Key 'result' is required"
                        else
                            case parseResult r1 of
                                Left e2 -> Left e2
                                Right (res, r2) ->
                                    if r2 == "e" then Right $ (Just res) : results
                                    else if (take 1 r2) == "e" then parse (drop 1 r2) $ (Just res) : results
                                        else Left "'e' expected"

parseResult :: String -> Either String (Bool, String)
parseResult str =
    case parseMsgString str of
                Left e2 -> Left e2
                Right (r2, l2) ->
                    case extractResult r2 of
                        Left e3 -> Left e3
                        Right b3 -> Right (b3, l2)
    where
        extractResult :: String -> Either String Bool
        extractResult r =
            if r == "HIT" then Right True else
            if r == "MISS" then Right False
            else Left "Result not correct"

parseCoords :: String -> Either String ((String, Int), String)
parseCoords str =
    case parseMsgList str of
        Left e2 -> Left e2
        Right (r2, l2) ->
            case extractCoords r2 of
                Left e3 -> Left e3
                Right (r3, l3) -> Right ((r3, l3), l2)
    where
        extractCoords :: [String] -> Either String (String, Int)
        extractCoords [a,b] =
            case parseX a of
                Left e1 -> Left e1
                Right x ->
                    case parseY b of
                    Left e2 -> Left e2
                    Right y -> Right (x, y)
            where
                parseX :: String -> Either String String
                parseX x =
                    if x == "A" || x == "B" || x == "C" || x == "D" || x == "E" || x == "F" || x == "G" || x == "H" || x == "I" || x == "J"
                        then Right x
                    else
                        Left "Incorrect first coord"
                parseY :: String -> Either String Int
                parseY y =
                    if y == "1" || y == "2" || y == "3" || y == "4" || y == "5" || y == "6" || y == "7" || y == "8" || y == "9" || y == "10"
                        then Right $ read y
                    else
                        Left "Incorrect second coord"
        extractCoords _ = Left "Coords not correct"

parseMsgList :: String -> Either String ([String], String)
parseMsgList ('l':m) = parseElement m []
    where
        parseElement :: String -> [String] -> Either String ([String], String)
        parseElement ('e':l) acc = Right (reverse acc, l)
        parseElement z acc =
            case parseMsgString z of
                Left e -> Left e
                Right (r, l) ->
                    parseElement l (r:acc)
parseMsgList _ = Left "'l' missing"

parseMsgString :: String -> Either String (String, String)
parseMsgString msg = readStr len $ drop (length lenghtAsStr) msg
    where
        lenghtAsStr :: String
        lenghtAsStr = takeWhile isDigit msg
        len :: Int
        len = read lenghtAsStr
        readStr :: Int -> String -> Either String (String, String)
        readStr n (':':m) = Right (take n m, drop n m)
        readStr _ h = Left $ "Digit or colon expected: " ++ h