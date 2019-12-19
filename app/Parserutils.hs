{-# LANGUAGE OverloadedStrings #-}
module Parserutils (
    validateMovesForAB,
    validateUniqueCoords,
    createSyntaxError,
    splitAtFirst,
    appendList,
    prependList,
    get1st,
    get2nd,
    get1stChar,
    isEven) where

import Move as M

validateMovesForAB move =
    case validateUniqueCoords move of
        Left error -> Left error
        Right _ -> validateUniqueCoords (prev move)



validateUniqueCoords :: Move -> Either String Bool
validateUniqueCoords move = checkPrev move []
    where
        checkPrev :: Move -> [Coordinates] -> Either String Bool
        checkPrev move usedCoords = do
            let currentMoveCoords = coords move
            if areCoordsInList currentMoveCoords usedCoords
                then Left $ createSyntaxError "Dublicated coords: " ++ show currentMoveCoords
            else do
                let prevPreMove = prev (prev move)
                let appendedList = appendList currentMoveCoords usedCoords
                if prev move /= M.Empty && prevPreMove /= M.Empty
                    then checkPrev prevPreMove appendedList
                else Right True
        areCoordsInList :: Coordinates -> [Coordinates] -> Bool
        areCoordsInList coordsToCheck coordList = coordsToCheck `elem` coordList



createSyntaxError :: String -> String
createSyntaxError errorMessage = "Syntax error: " ++ errorMessage



splitAtFirst :: Eq a => a -> [a] -> ([a], [a])
splitAtFirst x = fmap (drop 1) . break (x ==)


appendList :: Eq a => a -> [a] -> [a]
appendList a = foldr (:) [a]



prependList :: Eq a => a -> [a] -> [a]
prependList element list = element:list

get1st :: Coordinates -> String
get1st (a, _) = a
get2nd :: Coordinates -> String
get2nd (_, b) = b

get1stChar :: String -> Char
get1stChar (c:t) = c

isEven n = mod n 2 == 0