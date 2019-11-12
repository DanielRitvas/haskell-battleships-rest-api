{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Char(digitToInt)
import Debug.Trace

type Coordinates = (String, String)
data ResultType = HIT | MISS | NONE deriving (Eq,Ord,Enum,Show)

data Move = Empty | ValidMove { coords :: Coordinates
                        , result :: ResultType
                        , prev :: Move } deriving Show

singleMove = "d6:result4:MISS5:coordd1:11:D1:21:4ee"
singleMove2 = "d5:coordd1:11:A1:21:4ee"
twoMoves = "d6:result3:HIT5:coordd1:11:E1:21:2e4:prevd5:coordd1:11:H1:22:10e6:result4:MISSee"
twoMovesPrevFirst = "d4:prevd5:coordd1:11:H1:22:10e6:result3:HITe6:result4:MISS5:coordd1:11:E1:21:2ee"

game0 = "d4:prevd6:result4:MISS5:coordd1:11:F1:21:2e4:prevd5:coordd1:11:E1:22:10e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:J1:21:8e4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:21:4e6:result4:MISS4:prevd5:coordd1:11:I1:21:3e6:result4:MISS4:prevd4:prevd5:coordd1:11:A1:22:10e6:result4:MISS4:prevd4:prevd5:coordd1:11:C1:21:5e6:result4:MISS4:prevd5:coordd1:11:E1:21:7e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:H1:22:10e4:prevd4:prevd6:result4:MISS5:coordd1:11:G1:21:9e4:prevd6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:8e4:prevd6:result4:MISS5:coordd1:11:J1:22:10e4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:F1:22:10e4:prevd5:coordd1:11:D1:21:4e6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:A1:21:9e4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:21:6e4:prevd6:result4:MISS4:prevd4:prevd4:prevd4:prevd4:prevd5:coordd1:11:B1:21:7e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:D1:21:3e4:prevd6:result3:HIT5:coordd1:11:H1:21:2e4:prevd4:prevd4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:9e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:E1:21:3e4:prevd5:coordd1:11:E1:21:4e4:prevd5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:B1:21:1e6:result3:HIT4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:J1:21:5e4:prevd5:coordd1:11:F1:21:6e4:prevd5:coordd1:11:C1:21:1e4:prevd5:coordd1:11:F1:21:8e6:result3:HIT4:prevd6:result3:HIT4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:J1:21:8e4:prevd6:result3:HIT4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:22:10e6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:C1:21:6e4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:C1:21:8e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:7e6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:4e4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:I1:21:5e6:result3:HIT4:prevd4:prevd5:coordd1:11:J1:21:3e6:result3:HIT4:prevd6:result4:MISS4:prevd5:coordd1:11:B1:21:1e6:result4:MISS4:prevd5:coordd1:11:H1:21:7e6:result3:HIT4:prevd5:coordd1:11:A1:21:3e6:result4:MISS4:prevd5:coordd1:11:I1:21:6e4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:21:5e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:5e4:prevd4:prevd5:coordd1:11:F1:21:9e4:prevd6:result4:MISS5:coordd1:11:G1:21:1e4:prevd6:result3:HIT4:prevd4:prevd6:result3:HIT5:coordd1:11:G1:21:6e4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:22:10e6:result4:MISS4:prevd4:prevd4:prevd4:prevd6:result3:HIT5:coordd1:11:D1:21:9e4:prevd6:result4:MISS5:coordd1:11:J1:22:10e4:prevd6:result4:MISS5:coordd1:11:E1:21:3e4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:F1:21:9e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:B1:21:3e4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd4:prevd5:coordd1:11:B1:21:5e6:result4:MISS4:prevd5:coordd1:11:J1:21:7e6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:J1:21:1e4:prevd5:coordd1:11:G1:21:8e6:result4:MISS4:prevd5:coordd1:11:F1:21:2e6:result4:MISS4:prevd5:coordd1:11:C1:21:3e4:prevd4:prevd4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:J1:21:6e4:prevd5:coordd1:11:F1:21:8e6:result3:HIT4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:7e4:prevd5:coordd1:11:F1:21:1e6:result3:HIT4:prevd5:coordd1:11:I1:21:1e4:prevd5:coordd1:11:G1:22:10e4:prevd4:prevd4:prevd6:result3:HIT4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:8ee5:coordd1:11:I1:21:4ee5:coordd1:11:H1:21:6e6:result4:MISSe5:coordd1:11:C1:21:4ee5:coordd1:11:I1:21:7e6:result4:MISSe5:coordd1:11:C1:21:2e6:result4:MISSe6:result4:MISSe6:result4:MISSeee6:result3:HIT5:coordd1:11:C1:22:10eeee5:coordd1:11:D1:21:2e6:result4:MISSe5:coordd1:11:B1:21:8e6:result4:MISSe5:coordd1:11:A1:21:7e6:result4:MISSe5:coordd1:11:D1:21:8e6:result4:MISSe6:result4:MISSeeeeee6:result4:MISS5:coordd1:11:G1:21:2eeee5:coordd1:11:I1:21:2eee5:coordd1:11:E1:21:4ee6:result4:MISS5:coordd1:11:I1:22:10ee5:coordd1:11:I1:21:4e6:result3:HITeeee5:coordd1:11:B1:21:3e6:result4:MISSe6:result4:MISS5:coordd1:11:B1:21:9ee6:result3:HIT5:coordd1:11:E1:21:6eee5:coordd1:11:I1:21:6ee5:coordd1:11:B1:22:10e6:result4:MISSee5:coordd1:11:G1:21:6e6:result3:HITe5:coordd1:11:A1:21:7eee6:result4:MISSe5:coordd1:11:A1:21:1e6:result4:MISSeee5:coordd1:11:I1:21:1ee6:result3:HITeeee5:coordd1:11:H1:21:6eee5:coordd1:11:I1:21:9e6:result3:HITee5:coordd1:11:E1:21:8e6:result4:MISSe5:coordd1:11:D1:21:3ee5:coordd1:11:H1:21:9ee6:result4:MISS5:coordd1:11:I1:21:3eee5:coordd1:11:H1:21:4eee5:coordd1:11:B1:21:4ee5:coordd1:11:F1:21:4eee5:coordd1:11:B1:21:5e6:result4:MISSe5:coordd1:11:E1:21:9e6:result4:MISSe6:result4:MISSe5:coordd1:11:B1:21:2ee5:coordd1:11:G1:21:4ee5:coordd1:11:D1:21:5eee5:coordd1:11:F1:21:4ee5:coordd1:11:J1:21:2e6:result4:MISSe5:coordd1:11:I1:21:9eee5:coordd1:11:A1:21:4ee5:coordd1:11:C1:22:10eee6:result4:MISSe6:result4:MISSe6:result4:MISSe5:coordd1:11:D1:21:2ee5:coordd1:11:J1:21:4e6:result4:MISSe5:coordd1:11:J1:21:9e6:result4:MISSee6:result4:MISSe6:result4:MISSee5:coordd1:11:F1:21:1eee5:coordd1:11:I1:21:5ee5:coordd1:11:B1:21:7e6:result4:MISSe6:result4:MISS5:coordd1:11:H1:21:5ee5:coordd1:11:A1:21:1e6:result4:MISSe5:coordd1:11:G1:21:7e6:result4:MISSeee5:coordd1:11:G1:21:5ee6:result4:MISSe5:coordd1:11:J1:21:5e6:result4:MISSe6:result4:MISS5:coordd1:11:D1:21:7ee5:coordd1:11:J1:21:7e6:result4:MISSe5:coordd1:11:E1:21:1e6:result4:MISSe5:coordd1:11:D1:21:7ee6:result4:MISSe5:coordd1:11:A1:21:5ee6:result3:HIT5:coordd1:11:A1:21:6ee6:result4:MISS5:coordd1:11:J1:21:2ee6:result3:HITe5:coordd1:11:H1:21:1ee6:result4:MISS5:coordd1:11:H1:21:1ee5:coordd1:11:G1:21:2eee6:result4:MISSe6:result4:MISS5:coordd1:11:F1:22:10ee5:coordd1:11:E1:21:2eee6:result3:HITe5:coordd1:11:A1:21:3e6:result4:MISSe5:coordd1:11:C1:21:7ee5:coordd1:11:D1:21:8eee6:result4:MISS5:coordd1:11:I1:21:7ee6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3ee6:result3:HIT5:coordd1:11:I1:21:8ee6:result4:MISS5:coordd1:11:F1:21:5eeee6:result4:MISS5:coordd1:11:J1:21:4eee6:result3:HIT5:coordd1:11:H1:21:7eeee5:coordd1:11:E1:21:5ee6:result4:MISS5:coordd1:11:G1:21:8ee6:result4:MISS5:coordd1:11:C1:21:9eee5:coordd1:11:C1:21:8ee6:result4:MISSee5:coordd1:11:C1:21:3e6:result4:MISSe"
game1 = "d4:prevd5:coordd1:11:H1:21:5e6:result4:MISS4:prevd4:prevd5:coordd1:11:E1:21:9e4:prevd6:result3:HIT5:coordd1:11:C1:21:3e4:prevd6:result4:MISS5:coordd1:11:I1:21:6e4:prevd6:result3:HIT5:coordd1:11:I1:21:2e4:prevd4:prevd4:prevd5:coordd1:11:C1:21:1e4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:J1:21:7e4:prevd6:result4:MISS5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:I1:21:8e6:result4:MISS4:prevd5:coordd1:11:E1:21:8e6:result3:HIT4:prevd4:prevd4:prevd5:coordd1:11:C1:21:2ee5:coordd1:11:A1:21:7e6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3eeeeee5:coordd1:11:A1:21:3e6:result4:MISSe5:coordd1:11:B1:22:10ee6:result3:HITe5:coordd1:11:D1:21:9e6:result4:MISSe5:coordd1:11:F1:21:6e6:result4:MISSeeee6:result4:MISSe5:coordd1:11:D1:21:8e6:result4:MISSee6:result4:MISS5:coordd1:11:G1:21:8ee"

emptyMove = ValidMove ("", "") NONE Empty

main = do
    let message = game1
    -- At the end, tail should be empty
    let (parsedMoves, tail) = readMove emptyMove message
    print parsedMoves

readMove :: Move -> String -> (Move, String)
readMove move "" = (move, "")
readMove move ('e':message) = (move, message)
readMove move message = do
    let (didRemoveFirst, removedStartBoundary) = removeFirstIfMatched 'd' message
    let (key, tail) = readUpcommingKey removedStartBoundary
    if key == ""
        then (move, "")
    else if key == "coord"
        then do
            let (coords, finalTail) = readCoords tail
            readMove (ValidMove coords (result move) (prev move)) finalTail
    else if key == "result"
        then do
            let (result, finalTail) = readResult tail
            readMove (ValidMove (coords move) result (prev move)) finalTail
    else if key == "prev"
        then do
            let (prev, finalTail) = readMove emptyMove tail
            readMove (ValidMove (coords move) (result move) prev) finalTail
    else error $ createSyntaxError ("Unexpected key " ++ key)


readResult :: String -> (ResultType, String)
readResult message = do
    let (resultValue, tail) = readUpcommingKey message
    if resultValue == show HIT
        then (HIT, tail)
    else if resultValue == show MISS
        then (MISS, tail)
    else error $ createSyntaxError "Result can be only HIT or MISS"


readCoords :: String -> (Coordinates, String)
readCoords message = do
    let (dictionary, tail) = readDictionary message
    if length dictionary == 2
        then ((head dictionary, last dictionary), tail)
    else error $ createSyntaxError "Coords dictionary should be size of 2"

readDictionary :: String -> ([String], String)
readDictionary messageWithDictionaryAtTheBeggining = do
    let (didRemoveFirst, d1) = removeFirstIfMatched 'd' messageWithDictionaryAtTheBeggining
    if didRemoveFirst
        then do
            let (dictionaryContents, tail) = splitAtFirst 'e' d1
            (getDictionaryElements dictionaryContents [], tail)
        else error $ createSyntaxError "Dictionary should start from 'd'"
    where
        getDictionaryElements :: String -> [String] -> [String]
        getDictionaryElements "" arr = arr
        getDictionaryElements dictionaryElementsAsBlob arr = do
            let (_, value, tail) = getUpcommingDictionaryElement dictionaryElementsAsBlob
            prependList value (getDictionaryElements tail arr)

        getUpcommingDictionaryElement = readUpcommingValue



-- Expects key:value at the begging of message
readUpcommingValue :: String -> (String, String, String)
readUpcommingValue message = do
    let (keyLength, tailWithValue) = readUpcommingKey message
    let (value, tail) = readUpcommingKey tailWithValue
    (keyLength, value, tail)

-- Possible key detection
-- Error | Key and rest of the message
readUpcommingKey :: String -> (String, String)
readUpcommingKey message = do
    let (_, removedPreviousEnd) = removeFirstIfMatched 'e' message
    case removedPreviousEnd of
        "" -> ("", "")
        (keyLength:':':tail) -> do
            let upcommingKey = take (digitToInt keyLength) tail
            let restOfTheMessage = drop (digitToInt keyLength) tail
            (upcommingKey, restOfTheMessage)
        anyMessage ->
            error $ createSyntaxError "valueLength:value pair expected: " ++ message

-- Outer boundaries removal
tryToRemoveOuterBoundaries :: String -> String
tryToRemoveOuterBoundaries blob = do
    let (didRemoveFirst, b1) = removeFirstIfMatched 'd' blob
    let (didRemoveLast, b) = removeLastIfMatched 'e' b1
    if didRemoveFirst && didRemoveLast
        then b
        else error $ createSyntaxError "Outer boundaries 'd' and 'e' expected."

removeFirstIfMatched :: Char -> String -> (Bool, String)
removeFirstIfMatched _ [] = (False, [])
removeFirstIfMatched c1 (c2:cs) =
    if c1 == c2
        then (True, cs)
        else (False, c2:cs)

removeLastIfMatched :: Char -> String -> (Bool, String)
removeLastIfMatched c str = do
    let (didReverse, withLastRemoved) = removeFirstIfMatched c (reverse str)
    (didReverse, reverse withLastRemoved)

createSyntaxError :: String -> String
createSyntaxError errorMessage = "Syntax error: " ++ errorMessage

splitAtFirst :: Eq a => a -> [a] -> ([a], [a])
splitAtFirst x = fmap (drop 1) . break (x ==)

get1st (a, _) = a
get2nd (a, b) = b

appendList :: Eq a => a -> [a] -> [a]
appendList a = foldr (:) [a]

prependList :: Eq a => a -> [a] -> [a]
prependList element list = element:list