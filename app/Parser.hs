{-# LANGUAGE OverloadedStrings #-}
module Parser (
    readMove, 
    readResult, 
    readCoords, 
    readDictionary, 
    readUpcommingValue, 
    readUpcommingKey, 
    tryToRemoveOuterBoundaries, 
    removeFirstIfMatched, 
    removeLastIfMatched) where

import Move
import Parserutils
import Data.Char

-- Returns fully or partially parsed move and rest of the message.
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
        -- first and last elements of list
        then ((head dictionary, last dictionary), tail)
    else (("", ""), tail)


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



-- Outer boundaries removal. Not use any more.
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