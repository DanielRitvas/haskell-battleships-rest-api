{-# LANGUAGE TupleSections #-}
{-# LANGUAGE TypeFamilies, QuasiQuotes, MultiParamTypeClasses,
             TemplateHaskell, OverloadedStrings, ViewPatterns #-}

module Main where

import Battlehttp
import Debug.Trace
import Network.Wreq
import Control.Lens
import Data.Aeson.Lens (_String, key)
import Text.Read
import Data.Char
import Control.Concurrent
import Move as M
import Parser
import Parserutils
import qualified GHC.List as GHCList
import qualified Data.ByteString.Lazy as BS
import qualified Data.ByteString.Lazy.Char8 as Char8

import Data.IORef
import Data.Text (Text)
import qualified Data.Text as DT
import Yesod hiding (insert)
import qualified Network.Wai as Wai
import qualified Network.HTTP.Types.Status as HTTPStatus
import Data.Map (Map, fromList, lookup, insert, toList)
import Prelude hiding (lookup, insert)

------------------------------------------------
-- 	  A	B C	D E F G H I J
-- 1  x x x x . . . . x x
-- 2  . . . . . . . . . x
-- 3  . . . . . . . . . x
-- 4  . . . . . . . . . .
-- 5  . . . . . . . . . .
-- 6  . . . . . . x x . . 
-- 7  . . . . . x x . . .
-- 8  . . . . . . . . . . 
-- 9  . x . . . . . . x x
-- 10 x x x . . . . . x x
------------------------------------------------

shipPositions =
    [("A", "1") :: Coordinates,
    ("B", "1") :: Coordinates,
    ("C", "1") :: Coordinates,
    ("D", "1") :: Coordinates,

    ("I", "1") :: Coordinates,
    ("J", "1") :: Coordinates,
    ("J", "2") :: Coordinates,
    ("J", "3") :: Coordinates,

    ("G", "6") :: Coordinates,
    ("H", "6") :: Coordinates,
    ("F", "7") :: Coordinates,
    ("G", "7") :: Coordinates,

    ("B", "9") :: Coordinates,
    ("A", "10") :: Coordinates,
    ("B", "10") :: Coordinates,
    ("C", "10") :: Coordinates,

    ("I", "9") :: Coordinates,
    ("J", "9") :: Coordinates,
    ("I", "10") :: Coordinates,
    ("J", "10") :: Coordinates]

numberOfHitsToWin = 20
contentType = "application/relaxed-bencoding+nolists"
url = "http://battleship.haskell.lt/game/"
localUrl = "http://localhost:3000"


data SingleGamesData = SingleGamesData {
    move :: Move,
    currentMove :: Role,
    playerADidMove :: Bool,
    playerAReadMove :: Bool
}

type GamesDataMap = Map String SingleGamesData

data GamesData = GamesData {
    gamesMap :: IORef GamesDataMap
}

mkYesod "GamesData" [parseRoutes|
/currentGames/list CurrentGameListR GET
/currentGames/status/#Text CurrentGameStatusR GET
/#Text GameR GET POST
|]

instance Yesod GamesData

-- get list of game names
getCurrentGameListR :: Handler String
getCurrentGameListR = do
    -- Example: Applicative Function fmap
    gamesDataMapRef <- fmap gamesMap getYesod
    gamesDataMap' <- liftIO $ readIORef gamesDataMapRef
    return $ show (map fst (toList gamesDataMap'))

getCurrentGameStatusR :: Text -> Handler String
getCurrentGameStatusR gameId = do
    gamesDataMapRef <- fmap gamesMap getYesod
    gamesDataMap' <- liftIO $ readIORef gamesDataMapRef
    let gameIdStr = DT.unpack gameId
    case lookup gameIdStr gamesDataMap' of
        Nothing -> return $ "No active game with name " ++ gameIdStr
        Just dataMap -> liftIO $ parseToBEncode (move dataMap)

getGameR :: Text -> Handler String
getGameR gameId = do
    let gameIdStr = DT.unpack gameId
    allowGet <- isTimeForPlayerAToGetMoveOfB gameIdStr
    if allowGet then do
        gameData <- getGameDataById gameIdStr
        setStateAfterAReadMove gameIdStr
        liftIO $ parseToBEncode (move gameData)
    else
        return $ error "It's not time to GET another move"


postGameR :: Text -> Handler String
postGameR gameId = do
    let gameIdStr = DT.unpack gameId
    allowPost <- isMoveOfPlayerA gameIdStr
    if allowPost then do
        -- Example Applicative Function <$> which is a infix synonym for fmap
        req <- reqWaiRequest <$> getRequest
        body <- liftIO $ Wai.lazyRequestBody req
        gameData <- getGameDataById gameIdStr
        let (newMove, opce) = readMove (move gameData) (toStr body)
        setGameDataById gameIdStr (SingleGamesData {
            move = newMove,
            currentMove = currentMove gameData,
            playerADidMove = playerADidMove gameData,
            playerAReadMove = playerAReadMove gameData
        })
        setStateAfterMoveOfPlayerA gameIdStr

        nextMoveOfB <- liftIO $ doNextMoveForPlayerB newMove
        case nextMoveOfB of
            Just bMove -> do
                setGameDataById gameIdStr (SingleGamesData {
                    move = bMove,
                    currentMove = currentMove gameData,
                    playerADidMove = playerADidMove gameData,
                    playerAReadMove = playerAReadMove gameData
                })
                setStateAfterMoveOfPlayerB gameIdStr
                return ""
            Nothing -> do
                liftIO $ error "Player B can't do another move"
                setStateAfterMoveOfPlayerB gameIdStr
                return ""
    else
        return $ error "It's not time to POST another move"

-- Example: Monad Maybe
doNextMoveForPlayerB :: Move -> IO (Maybe Move)
doNextMoveForPlayerB lastMoveOfPlayerA = do
    let didEnemyWin = calculateScoreOfEnemy lastMoveOfPlayerA B == numberOfHitsToWin
    if didEnemyWin then do
        -- Move Of Dramatic Failure
        print "I lost :(. Letting enemy know about it..."
        return $ Just $ ValidMove ("", "") HIT (prev lastMoveOfPlayerA)
    else
        case getMyNextMove lastMoveOfPlayerA B of
            Nothing -> do
                print "No correct response from enemy after very last move possible."
                return Nothing
            Just nextMove -> return $ Just nextMove

isMoveOfPlayerA :: String -> Handler Bool
isMoveOfPlayerA gameId = do
    gameData <- getGameDataById gameId
    return (currentMove gameData == A && not (playerADidMove gameData))


isTimeForPlayerAToGetMoveOfB :: String -> Handler Bool
isTimeForPlayerAToGetMoveOfB gameId = do
    gameData <- getGameDataById gameId
    return (currentMove gameData == A
        && not (playerADidMove gameData)
        && not (playerAReadMove gameData))


setStateAfterAReadMove :: String -> Handler ()
setStateAfterAReadMove gameId = do
    gameData <- getGameDataById gameId
    setGameDataById gameId (SingleGamesData {
        playerAReadMove = True,

        move = move gameData,
        currentMove = currentMove gameData,
        playerADidMove = playerADidMove gameData
    })
    return ()


setStateAfterMoveOfPlayerA :: String -> Handler ()
setStateAfterMoveOfPlayerA gameId = do
    gameData <- getGameDataById gameId
    setGameDataById gameId (SingleGamesData {
        currentMove = B,
        playerADidMove = True,

        move = move gameData,
        playerAReadMove = playerAReadMove gameData
    })
    return ()



setStateAfterMoveOfPlayerB :: String -> Handler ()
setStateAfterMoveOfPlayerB gameId = do
    gameData <- getGameDataById gameId
    setGameDataById gameId (SingleGamesData {
        currentMove = A,
        playerADidMove = False,
        playerAReadMove = False,

        move = move gameData
    })
    return ()



startGameServer = do
    emptyGamesMapRef <- newIORef (fromList [])
    warp 3000 $ GamesData {
        gamesMap = emptyGamesMapRef
    }


getGameDataById :: String -> Handler SingleGamesData
getGameDataById gameId = do
    gamesDataMapRef <- fmap gamesMap getYesod
    gamesDataMap' <- liftIO $ readIORef gamesDataMapRef
    case lookup gameId gamesDataMap' of
        Nothing -> return SingleGamesData {
            move = M.emptyMove,
            currentMove = A,
            playerADidMove = False,
            playerAReadMove = False
        }
        Just dataMap -> return dataMap

setGameDataById :: String -> SingleGamesData -> Handler SingleGamesData
setGameDataById gameId gameData = do
    gamesDataMapRef <- fmap gamesMap getYesod
    gamesDataMap' <- liftIO $ readIORef gamesDataMapRef
    let newMap = insert gameId gameData gamesDataMap'
    liftIO $ atomicModifyIORef gamesDataMapRef (newMap,)
    return gameData


-------------------------------------------
main = do
    instanceType <- readInstanceType
    if instanceType == 1 then do
        _ <- startClientGameWithRole A localUrl
        return ()
    else if instanceType == 2 then
        startGameServer
    else do
        _ <- startClientGame
        return ()


startClientGameWithRole :: Role -> String -> IO (Maybe Move)
startClientGameWithRole role serverUrl = do
    gameName' <- readGameName
    -- Example Monoid (under concatenation, (<>) = (++))
    print $ "Name of the game: " <> gameName'
    let url = serverUrl <> "/" <> gameName'
    case role of
        M.A -> do
            move <- doFirstAttack url
            case move of
                Just m -> startGameLoop url role m

startClientGame :: IO (Maybe Move)
startClientGame = do
    gameName <- readGameName
    role <- readRole
    print $ "Name of the game: " ++ gameName
    print $ "You are player: " ++ show role
    let url = getUrl gameName role
    case role of
        M.B -> startGameLoop url role firstMove
        M.A -> do
            move <- doFirstAttack url
            case move of
                Just m -> startGameLoop url role m

startGameLoop :: String -> Role -> Move -> IO (Maybe Move)
startGameLoop url role gameMoves = do
    print "5 seconds delay before checking enemy's move..."
    -- threadDelay (1000000 * 5)
    print gameMoves
    currentEnemyMove <- getEnemyMove url gameMoves
    case currentEnemyMove of
        Just em -> do
            let didEnemyWin = calculateScoreOfEnemy em role == numberOfHitsToWin
            if didEnemyWin then
                acceptDefeat url em
            else
                case getMyNextMove em role of
                    Nothing -> do
                        print "No correct response from enemy after very last move possible."
                        return Nothing
                    Just nextMove -> do
                        myCurrentMove <- doAttack url nextMove
                        case myCurrentMove of
                            Just mcm ->
                                startGameLoop url role mcm
        Nothing -> do
            print "It seems that something happened with enemy..."
            return Nothing


getLastPlayersMoveByRole :: Move -> Role -> Move
getLastPlayersMoveByRole move role =
    case role of
        A -> move
        B -> prev move


getMyNextMove :: Move -> Role -> Maybe Move
getMyNextMove moves role = do
    let prevMove = getLastPlayersMoveByRole moves role
    case prevMove of
        -- In case it's a first move for player B
        M.Empty -> return $ ValidMove (coords firstMove) (getPreviousResult moves) moves
        _ -> do
            let (firstCoord, secondCoord) = coords prevMove
            let charCoord = get1stChar firstCoord
            if charCoord < 'J' then do
                let newCoords = ([getNextCoordsLetter charCoord], secondCoord) :: Coordinates
                Just $ ValidMove newCoords (getPreviousResult moves) moves
            -- We reached the end... That's enough!
            else if secondCoord == "10" then
                Nothing
            else do
                let newCoords = ("A", getNextCoordsNumber secondCoord) :: Coordinates
                Just $ ValidMove newCoords (getPreviousResult moves) moves



getPreviousResult :: Move -> ResultType
getPreviousResult move = do
    let isHit = checkIfHit (coords move)
    if isHit then HIT else MISS

getNextCoordsLetter 'J' = 'A'
getNextCoordsLetter c = chr (ord c + 1)

getNextCoordsNumber :: String -> String
getNextCoordsNumber n = do
    let num = read n :: Int
    if num < 10 then show (num + 1)
    else "10"


getEnemyMove :: String -> Move -> IO (Maybe Move)
getEnemyMove url moves = do
    print "Getting enemy's move..."
    let opts = defaults & header "Accept" .~ [contentType]
    r <- getWith opts url
    let responseStatusCode = r ^. responseStatus . statusCode
    if responseStatusCode >= 200 && responseStatusCode < 300 then do
        let enemyMoveData = toStr (r ^. responseBody)
        let (enemyMove, _) = readMove moves enemyMoveData
        -- First enemy hit should have result unknown.
        print $ "Enemy hit " ++ show (coords enemyMove) ++ " result: " ++ show (result enemyMove)
        return (Just enemyMove)
    else do
        print $ "Failed to get move: " ++ show (r ^. responseBody)
        return Nothing

doFirstAttack :: String -> IO (Maybe Move)
doFirstAttack url = do
    print $ "First attack " ++ show (coords firstMove) ++ "..."
    p <- parseToBEncode firstMove
    let firstCoords = p ++ "e"
    let opts = defaults & header "Content-Type" .~ [contentType]
    r <- postWith opts url (toBS firstCoords)
    let responseStatusCode = r ^. responseStatus . statusCode
    if responseStatusCode >= 200 && responseStatusCode < 300 then
        return (Just (ValidMove (coords firstMove) UNKNOWN M.Empty))
    else do
        print $ "Failed to do first attack: " ++ show (r ^. responseBody)
        return Nothing

doAttack :: String -> Move -> IO (Maybe Move)
doAttack url move = do
    print $ "Attacking " ++ show (coords move) ++ "..."
    let opts = defaults & header "Content-Type" .~ [contentType]
    m <- parseToBEncode move
    r <- postWith opts url (toBS m)
    let responseStatusCode = r ^. responseStatus . statusCode
    if responseStatusCode >= 200 && responseStatusCode < 300 then
        return (Just (ValidMove (coords move) UNKNOWN (prev move)))
    else do
        print $ "Failed to attack: " ++ show (r ^. responseBody)
        return Nothing

acceptDefeat :: String -> Move -> IO (Maybe Move)
acceptDefeat url move = do
    print "I lost :(. Letting enemy know about it..."
    let opts = defaults & header "Content-Type" .~ [contentType]
    let moveOfDramaticFailure = ValidMove ("", "") HIT (prev move)
    m <- parseToBEncode moveOfDramaticFailure
    r <- postWith opts url (toBS m)
    let responseStatusCode = r ^. responseStatus . statusCode
    if responseStatusCode >= 200 && responseStatusCode < 300 then
        return (Just (ValidMove (coords move) UNKNOWN (prev move)))
    else do
        print $ "Failed to fail :') " ++ show (r ^. responseBody)
        return Nothing

getUrl :: String -> Role -> String
getUrl gameName role = url ++ gameName ++ "/player/" ++ show role

readGameName :: IO String
readGameName = do
    putStrLn "Enter game name:"
    name <- readNotEmptyString
    case name of
        Just n -> return n
        Nothing -> putStrLn "Name can't be empty" >> readGameName

readRole :: IO Role
readRole = do
    putStrLn "Select player role (A/B):"
    role <- readNotEmptyString
    case role of
        Just r
            | r == "A" -> return A
            | r == "B" -> return B
            | otherwise -> putStrLn "Role only can be A or B" >> readRole
        Nothing -> putStrLn "Name can't be empty" >> readRole

readInstanceType :: IO Int
readInstanceType = do
    putStrLn "Select type for this instance:"
    putStrLn "1 - client (player A)"
    putStrLn "2 - game server"
    putStrLn "Any other key - basic client to play another client"
    role <- readNotEmptyString
    case role of
        Just r
            | r == "1" -> return 1
            | r == "2" -> return 2
            | otherwise -> return 3
            -- | otherwise -> putStrLn "Type only can be 1 or 2" >> readInstanceType
        Nothing -> putStrLn "Type can't be empty" >> readInstanceType


readNotEmptyString :: IO (Maybe String)
readNotEmptyString = do
    input <- getLine
    if null input then
        return Nothing
    else
        return (Just input)

parseToBEncode :: Move -> IO String
parseToBEncode move = do
    p <- parseOneMoveToBEncode move
    return $ "d" ++ p ++ "e"

parseOneMoveToBEncode :: Move -> IO String
parseOneMoveToBEncode move = do
    let c = parseCoordinatesToBEncode (coords move)
    let r = parseResultToBEncode (result move)
    case prev move of
        M.Empty -> return $ c ++ r
        ValidMove {} -> do
            p <- parseOneMoveToBEncode (prev move)
            if p == "" then
                return $ c ++ r
            else
                return $ r ++ c ++ "4:prevd" ++ p ++ "e"

parseMoveResponseToBEncode :: Move -> String
parseMoveResponseToBEncode move =
        "d" ++ parseCoordinatesToBEncode (coords move) ++ "e"

parseCoordinatesToBEncode :: Coordinates -> String
parseCoordinatesToBEncode coords = do
    let secondValueLength = length (get2nd coords)
    if secondValueLength == 0 then
        "5:coordde"
    else
        "5:coordd1:11:" ++ get1st coords ++ "1:2" ++ show secondValueLength ++ ":" ++ get2nd coords ++ "e"

parseResultToBEncode :: ResultType -> String
parseResultToBEncode result =
    case result of
        HIT -> "6:result3:HIT"
        MISS -> "6:result4:MISS"
        _ -> ""

checkIfHit :: Coordinates -> Bool
checkIfHit coords = do
    let hitsInColumn = filter (\c -> get2nd c == get2nd coords) shipPositions
    let intendedHit = GHCList.lookup (get1st coords) hitsInColumn
    case intendedHit of
        Just h -> True
        Nothing -> False

calculateScoreOfEnemy :: Move -> Role -> Int
calculateScoreOfEnemy move role = do
    let (scoreA, scoreB) = calculateScoreForPlayersAB move
    case role of
        A -> scoreA
        B -> scoreB

-- Error | (hits of A, hits of B)
calculateScoreForPlayersAB :: Move -> (Int, Int)
calculateScoreForPlayersAB move = do
    let numberOfMoves = getNumberOfMoves move
    case prev move of
        ValidMove a b c ->
            if isEven numberOfMoves then
                (calculateScore (prev move), calculateScore move)
            else
                (calculateScore move, calculateScore (prev move))
        M.Empty -> (0, calculateScore move)



calculateScore :: Move -> Int
calculateScore move = do
    let lastMoveScore = incrementScoreIfHit move 0
    let (_, score) = getPrev move lastMoveScore
    score
    where
        getPrev :: Move -> Int -> (Move, Int)
        getPrev move score = do
            let prevPreMove = prev (prev move)
            if prev move /= M.Empty && prevPreMove /= M.Empty
                then getPrev prevPreMove (incrementScoreIfHit prevPreMove score)
            else (move, incrementScoreIfHit move score)
        incrementScoreIfHit :: Move -> Int -> Int
        incrementScoreIfHit move score =
            if result move == HIT
                then score + 1
            else score



getNumberOfMoves :: Move -> Int
getNumberOfMoves move = do
    let (_, numberOfMoves) = getPrev move 0
    numberOfMoves
    where
        getPrev :: Move -> Int -> (Move, Int)
        getPrev move score = do
            let prevMove = prev move
            let incrementedScore = score + 1
            if prevMove /= M.Empty
                then getPrev prevMove incrementedScore
            else (prevMove, incrementedScore)
