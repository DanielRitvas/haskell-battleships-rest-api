{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Char(digitToInt)

data Move = Empty | Msg { coord :: (String, String)
                        , result :: String
                        , prev :: Move } deriving Show

singleMove = "d5:coordd1:11:D1:21:4e6:result4:MISSe"
twoMoves = "d6:result4:MISS5:coordd1:11:E1:21:2e4:prevd5:coordd1:11:H1:22:10e6:result4:MISSee"
twoMovesPrevFirst = "d4:prevd5:coordd1:11:H1:22:10e6:result4:MISSe6:result4:MISS5:coordd1:11:E1:21:2ee"

game0 = "d4:prevd4:prevd5:coordd1:11:H1:22:10e4:prevd5:coordd1:11:I1:21:6e6:result4:MISS4:prevd5:coordd1:11:B1:21:5e4:prevd4:prevd5:coordd1:11:A1:21:2e4:prevd6:result4:MISS5:coordd1:11:G1:21:7e4:prevd6:result4:MISS5:coordd1:11:C1:21:4e4:prevd4:prevd5:coordd1:11:J1:21:9e6:result4:MISS4:prevd4:prevd5:coordd1:11:B1:21:6ee6:result4:MISS5:coordd1:11:G1:21:2eee6:result3:HIT5:coordd1:11:H1:21:9eeee6:result3:HITe5:coordd1:11:J1:21:2e6:result3:HITe6:result3:HITee6:result4:MISSe5:coordd1:11:E1:21:5e6:result4:MISSe6:result4:MISS5:coordd1:11:E1:21:2ee"

main = do
    let message = singleMove
    let messageWithRemovedOuterBoundaries = tryToRemoveOuterBoundaries message
    let (coord, tail) = readUpcommingKey messageWithRemovedOuterBoundaries
    print $ readDictionary tail

readDictionary :: String -> [String]
readDictionary messageWithDictionaryAtTheBeggining = do
    let (didRemoveFirst, d1) = removeFirstIfMatched 'd' messageWithDictionaryAtTheBeggining
    if didRemoveFirst
        then do
            let (dictionaryContents, tail) = splitAtFirst 'e' d1
            getDictionaryElements dictionaryContents []
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
readUpcommingKey message =
    case message of
    (keyLength:':':tail) -> do
        let upcommingKey = take (digitToInt keyLength) tail
        let restOfTheMessage = drop (digitToInt keyLength) tail
        (upcommingKey, restOfTheMessage)
    anyMessage ->
        error "valueLength:value pair expected."

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

-- parseCoordAfterPrev :: String -> Either String String
-- parseCoordAfterPrev json = 
--     let 
--         reversedJson = reverse json --}"7":"2","C":"1"{:"drooc",}}"7":"2","C":"1"{:"drooc"{:"verp","TIH":"tluser"
--         countUntilFirstComma = takeWhile (/=',') reversedJson
--         reversedCoordJsonFirstComma = take (length countUntilFirstComma + 1) reversedJson --"7":"2",
--         dropUntilFirstComma = drop (length countUntilFirstComma + 1) reversedJson --"C":"1"{:"drooc",}}"7":"2","C":"1"{:"drooc"{:"verp","TIH":"tluser"
--         countUntilSecondComma = takeWhile (/=',') dropUntilFirstComma 
--         reversedCoordJsonSecondComma = take (length countUntilSecondComma) dropUntilFirstComma --"C":"1"{:"drooc"
--         dropUntilSecondComma = drop (length countUntilSecondComma + 1) dropUntilFirstComma --}}"7":"2","C":"1"{:"drooc"{:"verp","TIH":"tluser"
--         allCoord = reverse (reversedCoordJsonFirstComma ++ reversedCoordJsonSecondComma)
--         unreversedMain = reverse dropUntilSecondComma
--         main = allCoord ++ unreversedMain
--     in 
--         dropChars ["\"coord\"", ":", "{", "\"", "1", "\"", ":", "\""] main