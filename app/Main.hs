module Main where

import Parser
import Data.List.Split

game0 = "d5:coordd1:11:D1:22:10e4:prevd4:prevd4:prevd5:coordd1:11:A1:21:4e4:prevd4:prevd5:coordd1:11:A1:21:2e4:prevd5:coordd1:11:A1:22:10ee6:result3:HITe6:result3:HIT5:coordd1:11:D1:21:7ee6:result4:MISSe5:coordd1:11:H1:21:6e6:result3:HITe6:result3:HIT5:coordd1:11:J1:21:1ee6:result3:HITe"
game1 = "l5:coordl1:B1:8e4:prevl5:coordl1:J2:10e4:prevl5:coordl1:J1:5e4:prevl5:coordl1:J1:1e4:prevl5:coordl1:F1:1e4:prevl5:coordl1:J1:9e4:prevl5:coordl1:C1:6e4:prevl5:coordl1:B1:1e4:prevl5:coordl1:F1:4e4:prevl5:coordl1:C1:3e4:prevl5:coordl1:B1:6e4:prevl5:coordl1:D2:10e4:prevl5:coordl1:I1:1e4:prevl5:coordl1:A2:10e4:prevl5:coordl1:F2:10e4:prevl5:coordl1:A1:4e4:prevl5:coordl1:J1:8e4:prevl5:coordl1:I1:2e4:prevl5:coordl1:B2:10e4:prevl5:coordl1:A1:9e4:prevl5:coordl1:D1:5e4:prevl5:coordl1:C1:1e4:prevl5:coordl1:J1:6e4:prevl5:coordl1:F1:2e4:prevl5:coordl1:D1:8e4:prevl5:coordl1:C1:2e4:prevl5:coordl1:D1:3e4:prevl5:coordl1:G1:1e4:prevl5:coordl1:A1:3e4:prevl5:coordl1:I1:6e4:prevl5:coordl1:F1:8e4:prevl5:coordl1:B1:3e4:prevl5:coordl1:B1:9e4:prevl5:coordl1:A1:3e4:prevl5:coordl1:F1:6e4:prevl5:coordl1:E2:10e4:prevl5:coordl1:C1:1e4:prevl5:coordl1:C1:8e4:prevl5:coordl1:H1:1e4:prevl5:coordl1:C1:9e4:prevl5:coordl1:I1:6e4:prevl5:coordl1:A1:8e4:prevl5:coordl1:I1:3e4:prevl5:coordl1:A1:6e4:prevl5:coordl1:G1:7e4:prevl5:coordl1:E1:7e4:prevl5:coordl1:H2:10e4:prevl5:coordl1:G2:10e4:prevl5:coordl1:E1:3e4:prevl5:coordl1:H1:2e4:prevl5:coordl1:A1:6e4:prevl5:coordl1:J1:3e4:prevl5:coordl1:A1:7e4:prevl5:coordl1:G1:3e4:prevl5:coordl1:A1:4e4:prevl5:coordl1:J1:2e4:prevl5:coordl1:E1:7e4:prevl5:coordl1:B1:4e4:prevl5:coordl1:D1:7e4:prevl5:coordl1:D1:4e4:prevl5:coordl1:G1:9e4:prevl5:coordl1:C1:6e4:prevl5:coordl1:J1:4e4:prevl5:coordl1:D1:5e4:prevl5:coordl1:I1:5e4:prevl5:coordl1:G1:9e4:prevl5:coordl1:E1:6e4:prevl5:coordl1:B1:6e4:prevl5:coordl1:C1:8e4:prevl5:coordl1:F1:4e4:prevl5:coordl1:B1:4e4:prevl5:coordl1:E1:4e4:prevl5:coordl1:G1:1e4:prevl5:coordl1:H1:1e4:prevl5:coordl1:F1:7e4:prevl5:coordl1:J1:6e4:prevl5:coordl1:J1:1e4:prevl5:coordl1:I1:7e4:prevl5:coordl1:J1:2e4:prevl5:coordl1:E1:3e4:prevl5:coordl1:H1:8e4:prevl5:coordl1:E1:8e4:prevl5:coordl1:C1:9e4:prevl5:coordl1:B1:9e4:prevl5:coordl1:C1:7e4:prevl5:coordl1:A1:1e4:prevl5:coordl1:I1:8e4:prevl5:coordl1:H1:7e4:prevl5:coordl1:H1:4e4:prevl5:coordl1:B1:2e4:prevl5:coordl1:C1:4e4:prevl5:coordl1:E1:6e4:prevl5:coordl1:B1:7e4:prevl5:coordl1:D1:1e4:prevl5:coordl1:E1:2e4:prevl5:coordl1:G1:4e4:prevl5:coordl1:I1:4e4:prevl5:coordl1:F1:9e4:prevl5:coordl1:F1:5e4:prevl5:coordl1:E1:5e4:prevl5:coordl1:B1:3e4:prevl5:coordl1:A1:7e4:prevl5:coordl1:D1:9e4:prevl5:coordl1:I1:4e4:prevl5:coordl1:D2:10e4:prevl5:coordl1:F1:6e4:prevl5:coordl1:A1:8e4:prevl5:coordl1:I2:10e4:prevl5:coordl1:H1:6e4:prevl5:coordl1:F1:3e4:prevl5:coordl1:G1:2e4:prevl5:coordl1:D1:3e4:prevl5:coordl1:G1:8e4:prevl5:coordl1:G1:7e4:prevl5:coordl1:A1:9e4:prevl5:coordl1:J1:5e4:prevl5:coordl1:J1:9e4:prevl5:coordl1:D1:2e4:prevl5:coordl1:I1:9e4:prevl5:coordl1:I1:9e4:prevl5:coordl1:E2:10e4:prevl5:coordl1:H1:4e4:prevl5:coordl1:H1:5e4:prevl5:coordl1:H1:8e4:prevl5:coordl1:C1:2e4:prevl5:coordl1:G1:8e4:prevl5:coordl1:H1:7e4:prevl5:coordl1:G1:6e4:prevl5:coordl1:F1:2e4:prevl5:coordl1:F1:8e4:prevl5:coordl1:C2:10e4:prevl5:coordl1:C1:4e4:prevl5:coordl1:I1:2e4:prevl5:coordl1:B1:8e4:prevl5:coordl1:D1:2e4:prevl5:coordl1:F2:10e4:prevl5:coordl1:D1:4e4:prevl5:coordl1:F1:5e4:prevl5:coordl1:G1:4e4:prevl5:coordl1:B2:10e4:prevl5:coordl1:E1:4e4:prevl5:coordl1:D1:9e4:prevl5:coordl1:E1:1e4:prevl5:coordl1:H2:10e4:prevl5:coordl1:C1:3e4:prevl5:coordl1:J1:7e4:prevl5:coordl1:E1:5e4:prevl5:coordl1:F1:7e4:prevl5:coordl1:B1:1e4:prevl5:coordl1:H1:9e4:prevl5:coordl1:B1:5e4:prevl5:coordl1:A1:5e4:prevl5:coordl1:F1:9e4:prevl5:coordl1:H1:5e4:prevl5:coordl1:A1:1e4:prevl5:coordl1:D1:7e4:prevl5:coordl1:A1:2e4:prevl5:coordl1:D1:6e4:prevl5:coordl1:C1:5e4:prevl5:coordl1:C1:5e4:prevl5:coordl1:H1:3e4:prevl5:coordl1:E1:1e4:prevl5:coordl1:J1:3e4:prevl5:coordl1:J1:4e4:prevl5:coordl1:D1:6e4:prevl5:coordl1:C1:7e4:prevl5:coordl1:G2:10e4:prevl5:coordl1:I1:1e4:prevl5:coordl1:H1:2ee6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe"
game2 = "l5:coordl1:F1:6e4:prevl5:coordl1:A1:2e4:prevl5:coordl1:B1:4e4:prevl5:coordl1:E1:8e4:prevl5:coordl1:C1:6e4:prevl5:coordl1:J1:5e4:prevl5:coordl1:A2:10ee6:result3:HITe6:result4:MISSe6:result4:MISSe6:result3:HITe6:result3:HITe6:result3:HITe"
repeatedCoords = "l5:coordl1:B1:7e4:prevl5:coordl1:F1:4e4:prevl5:coordl1:B1:7e4:prevl5:coordl1:F2:10e4:prevl5:coordl1:E1:1e4:prevl5:coordl1:G1:4e4:prevl5:coordl1:F1:4e4:prevl5:coordl1:E1:4e4:prevl5:coordl1:G1:4e4:prevl5:coordl1:I1:4e4:prevl5:coordl1:H1:9e4:prevl5:coordl1:F1:2e4:prevl5:coordl1:B1:6ee6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe6:result4:MISSe"

-- ["d5","coordd1","11","D1","22","10e4","prevd4","prevd4","prevd5","coordd1","11","A1","21","4e4","prevd4","prevd5","coordd1","11","A1","21","2e4","prevd5","coordd1","11","A1","22","10ee6","result3","HITe6","result3","HIT5","coordd1","11","D1","21","7ee6","result4","MISSe5","coordd1","11","H1","21","6e6","result3","HITe6","result3","HIT5","coordd1","11","J1","21","1ee6","result3","HITe"]

isInteger str = 
    case reads str :: [(Integer, String)] of
        [(_, "")] -> True
        _         -> False

isNotInteger str = not (isInteger str)


-- d5:coordd1:11:B1:21:1e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:G1
main :: IO ()
main = do  
    let miau = tail $ splitOn ":" game0
        miauu = [c | c <- miau, isNotInteger c]
        -- miauuu = [c | c <- miauu, "coord" `isPrefixOf` c]
    print miauu
    -- let lastElementIsLastPrev = splitOn "prev" game0
        -- fullElementSomewhereAtTheBeggining = last lastElementIsLastPrev
        -- fullLastElement = last $ reverse $ splitOn "ee6" fullElementSomewhereAtTheBeggining
    -- print fullElementSomewhereAtTheBeggining

-- import qualified Data.Map as Map  
  
-- data LockerState = Taken | Free deriving (Show, Eq)  
  
-- type Code = String  
  
-- type LockerMap = Map.Map Int (LockerState, Code) 

-- lockerLookup :: Int -> LockerMap -> Either String Code  
-- lockerLookup lockerNumber map =   
--     case Map.lookup lockerNumber map of   
--         Nothing -> Left $ "Locker number " ++ show lockerNumber ++ " doesn't exist!"  
--         Just (state, code) -> if state /= Taken   
--                                 then Right code
--                                 else Left $ "Locker " ++ show lockerNumber ++ " is already taken!"


-- lockers :: LockerMap  
-- lockers = Map.fromList   
--     [
--         (100,(Taken,"ZD39I"))  
--         ,(101,(Free,"JAH3I"))  
--         ,(103,(Free,"IQSA9"))  
--         ,(105,(Free,"QOTSA"))  
--         ,(109,(Taken,"893JJ"))  
--         ,(110,(Taken,"99292"))  
--     ]  
        
-- main = print $ lockerLookup 101 lockers 



-- main = do   
--     line <- getLine  
--     if null line  
--         then return ()  
--         else do  
--             putStrLn $ reverseWords line  
--             main  
    
-- reverseWords :: String -> String  
-- reverseWords = unwords . map reverse . words  

-- import Control.Monad  
-- import Data.Char  
-- main = forever (do  
--     putStr "Give me some input: "  
--     l <- getLine  
--     putStrLn (map toUpper l))



-- import Control.Monad 
-- main = do   
--     colors <- forM [1,2,3,4] (\a -> do  
--         putStrLn $ "Which color do you associate with the number " ++ show a ++ "?"  
--         getLine)  
--     putStrLn "The colors that you associate with 1, 2, 3 and 4 are: "  
--     mapM putStrLn colors 

