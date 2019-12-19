{-# LANGUAGE OverloadedStrings #-}
module Battlehttp (safeGetUrl) where

import Move
import Control.Lens
import Network.Wreq
import qualified Control.Exception as E
import qualified Data.ByteString.Char8 as BSC
import qualified Data.ByteString.Lazy as LBS
import Network.HTTP.Client (HttpException (HttpExceptionRequest),
                            HttpExceptionContent (StatusCodeException))

type URL = String

type Login = String

type Password = String

contentType = "application/relaxed-bencoding+nolists"

safeGetUrl :: URL -> Move -> IO (Either String (Response LBS.ByteString))
safeGetUrl url move = do
  let opts = defaults & header "Accept" .~ [contentType]
  (Right <$> getWith opts url) `E.catch` handler
  where
    handler :: HttpException -> IO (Either String (Response LBS.ByteString))
    handler (HttpExceptionRequest _ (StatusCodeException r _)) =
      return $ Left $ BSC.unpack (r ^. responseStatus . statusMessage)

getEnemyMove :: URL -> Move -> IO String
getEnemyMove url enemyMove = do
  ress <- safeGetUrl url enemyMove
  case ress of 
    Left err -> return err
    Right o -> return "OJ"

-- getEnemyMove :: String -> Move -> IO (Maybe Move)
-- getEnemyMove url enemyMoves = do
--     print "Getting enemy's move..."
--     let opts = defaults & header "Accept" .~ [contentType]
--     r <- getWith opts url
--     let responseStatusCode = r ^. responseStatus . statusCode
--     if responseStatusCode >= 200 && responseStatusCode < 300 then do
--         let enemyMoveCoords = toStr (r ^. responseBody)
--         let enemyMoveWithCoords = getMoveFromBEncodedCoords enemyMoveCoords
--         let isHit = checkIfHit (coords enemyMoveWithCoords)
--         let result = if isHit then HIT else MISS
--         print $ "Enemy hit " ++ show (coords enemyMoveWithCoords) ++ " result: " ++ show result
--         return (Just (ValidMove (coords enemyMoveWithCoords) result (prev enemyMoves)))
--     else do
--         print $ "Failed to get move: " ++ show (r ^. responseBody)
--         return Nothing