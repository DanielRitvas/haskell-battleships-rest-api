{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Char(digitToInt)
import Debug.Trace
import Network.Wreq
import Control.Lens
import Data.Aeson.Lens (_String, key)

singleMove = "d6:result4:MISS5:coordd1:11:D1:21:4ee"
singleMove2 = "d5:coordd1:11:A1:21:4ee"
twoMoves = "d6:result3:HIT5:coordd1:11:E1:21:2e4:prevd5:coordd1:11:H1:22:10e6:result4:MISSee"
twoMovesPrevFirst = "d4:prevd5:coordd1:11:H1:22:10e6:result3:HITe6:result4:MISS5:coordd1:11:E1:21:2ee"

game0 = "d4:prevd6:result4:MISS5:coordd1:11:F1:21:2e4:prevd5:coordd1:11:E1:22:10e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:J1:21:8e4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:21:4e6:result4:MISS4:prevd5:coordd1:11:I1:21:3e6:result4:MISS4:prevd4:prevd5:coordd1:11:A1:22:10e6:result4:MISS4:prevd4:prevd5:coordd1:11:C1:21:5e6:result4:MISS4:prevd5:coordd1:11:E1:21:7e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:H1:22:10e4:prevd4:prevd6:result4:MISS5:coordd1:11:G1:21:9e4:prevd6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:8e4:prevd6:result4:MISS5:coordd1:11:J1:22:10e4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:F1:22:10e4:prevd5:coordd1:11:D1:21:4e6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:A1:21:9e4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:21:6e4:prevd6:result4:MISS4:prevd4:prevd4:prevd4:prevd4:prevd5:coordd1:11:B1:21:7e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:D1:21:3e4:prevd6:result3:HIT5:coordd1:11:H1:21:2e4:prevd4:prevd4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:9e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:E1:21:3e4:prevd5:coordd1:11:E1:21:4e4:prevd5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:B1:21:1e6:result3:HIT4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:J1:21:5e4:prevd5:coordd1:11:F1:21:6e4:prevd5:coordd1:11:C1:21:1e4:prevd5:coordd1:11:F1:21:8e6:result3:HIT4:prevd6:result3:HIT4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:J1:21:8e4:prevd6:result3:HIT4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:22:10e6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:C1:21:6e4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:C1:21:8e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:7e6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:4e4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:I1:21:5e6:result3:HIT4:prevd4:prevd5:coordd1:11:J1:21:3e6:result3:HIT4:prevd6:result4:MISS4:prevd5:coordd1:11:B1:21:1e6:result4:MISS4:prevd5:coordd1:11:H1:21:7e6:result3:HIT4:prevd5:coordd1:11:A1:21:3e6:result4:MISS4:prevd5:coordd1:11:I1:21:6e4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:21:5e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:5e4:prevd4:prevd5:coordd1:11:F1:21:9e4:prevd6:result4:MISS5:coordd1:11:G1:21:1e4:prevd6:result3:HIT4:prevd4:prevd6:result3:HIT5:coordd1:11:G1:21:6e4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:D1:22:10e6:result4:MISS4:prevd4:prevd4:prevd4:prevd6:result3:HIT5:coordd1:11:D1:21:9e4:prevd6:result4:MISS5:coordd1:11:J1:22:10e4:prevd6:result4:MISS5:coordd1:11:E1:21:3e4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:F1:21:9e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:B1:21:3e4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd4:prevd5:coordd1:11:B1:21:5e6:result4:MISS4:prevd5:coordd1:11:J1:21:7e6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:J1:21:1e4:prevd5:coordd1:11:G1:21:8e6:result4:MISS4:prevd5:coordd1:11:F1:21:2e6:result4:MISS4:prevd5:coordd1:11:C1:21:3e4:prevd4:prevd4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:J1:21:6e4:prevd5:coordd1:11:F1:21:8e6:result3:HIT4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:7e4:prevd5:coordd1:11:F1:21:1e6:result3:HIT4:prevd5:coordd1:11:I1:21:1e4:prevd5:coordd1:11:G1:22:10e4:prevd4:prevd4:prevd6:result3:HIT4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:8ee5:coordd1:11:I1:21:4ee5:coordd1:11:H1:21:6e6:result4:MISSe5:coordd1:11:C1:21:4ee5:coordd1:11:I1:21:7e6:result4:MISSe5:coordd1:11:C1:21:2e6:result4:MISSe6:result4:MISSe6:result4:MISSeee6:result3:HIT5:coordd1:11:C1:22:10eeee5:coordd1:11:D1:21:2e6:result4:MISSe5:coordd1:11:B1:21:8e6:result4:MISSe5:coordd1:11:A1:21:7e6:result4:MISSe5:coordd1:11:D1:21:8e6:result4:MISSe6:result4:MISSeeeeee6:result4:MISS5:coordd1:11:G1:21:2eeee5:coordd1:11:I1:21:2eee5:coordd1:11:E1:21:4ee6:result4:MISS5:coordd1:11:I1:22:10ee5:coordd1:11:I1:21:4e6:result3:HITeeee5:coordd1:11:B1:21:3e6:result4:MISSe6:result4:MISS5:coordd1:11:B1:21:9ee6:result3:HIT5:coordd1:11:E1:21:6eee5:coordd1:11:I1:21:6ee5:coordd1:11:B1:22:10e6:result4:MISSee5:coordd1:11:G1:21:6e6:result3:HITe5:coordd1:11:A1:21:7eee6:result4:MISSe5:coordd1:11:A1:21:1e6:result4:MISSeee5:coordd1:11:I1:21:1ee6:result3:HITeeee5:coordd1:11:H1:21:6eee5:coordd1:11:I1:21:9e6:result3:HITee5:coordd1:11:E1:21:8e6:result4:MISSe5:coordd1:11:D1:21:3ee5:coordd1:11:H1:21:9ee6:result4:MISS5:coordd1:11:I1:21:3eee5:coordd1:11:H1:21:4eee5:coordd1:11:B1:21:4ee5:coordd1:11:F1:21:4eee5:coordd1:11:B1:21:5e6:result4:MISSe5:coordd1:11:E1:21:9e6:result4:MISSe6:result4:MISSe5:coordd1:11:B1:21:2ee5:coordd1:11:G1:21:4ee5:coordd1:11:D1:21:5eee5:coordd1:11:F1:21:4ee5:coordd1:11:J1:21:2e6:result4:MISSe5:coordd1:11:I1:21:9eee5:coordd1:11:A1:21:4ee5:coordd1:11:C1:22:10eee6:result4:MISSe6:result4:MISSe6:result4:MISSe5:coordd1:11:D1:21:2ee5:coordd1:11:J1:21:4e6:result4:MISSe5:coordd1:11:J1:21:9e6:result4:MISSee6:result4:MISSe6:result4:MISSee5:coordd1:11:F1:21:1eee5:coordd1:11:I1:21:5ee5:coordd1:11:B1:21:7e6:result4:MISSe6:result4:MISS5:coordd1:11:H1:21:5ee5:coordd1:11:A1:21:1e6:result4:MISSe5:coordd1:11:G1:21:7e6:result4:MISSeee5:coordd1:11:G1:21:5ee6:result4:MISSe5:coordd1:11:J1:21:5e6:result4:MISSe6:result4:MISS5:coordd1:11:D1:21:7ee5:coordd1:11:J1:21:7e6:result4:MISSe5:coordd1:11:E1:21:1e6:result4:MISSe5:coordd1:11:D1:21:7ee6:result4:MISSe5:coordd1:11:A1:21:5ee6:result3:HIT5:coordd1:11:A1:21:6ee6:result4:MISS5:coordd1:11:J1:21:2ee6:result3:HITe5:coordd1:11:H1:21:1ee6:result4:MISS5:coordd1:11:H1:21:1ee5:coordd1:11:G1:21:2eee6:result4:MISSe6:result4:MISS5:coordd1:11:F1:22:10ee5:coordd1:11:E1:21:2eee6:result3:HITe5:coordd1:11:A1:21:3e6:result4:MISSe5:coordd1:11:C1:21:7ee5:coordd1:11:D1:21:8eee6:result4:MISS5:coordd1:11:I1:21:7ee6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3ee6:result3:HIT5:coordd1:11:I1:21:8ee6:result4:MISS5:coordd1:11:F1:21:5eeee6:result4:MISS5:coordd1:11:J1:21:4eee6:result3:HIT5:coordd1:11:H1:21:7eeee5:coordd1:11:E1:21:5ee6:result4:MISS5:coordd1:11:G1:21:8ee6:result4:MISS5:coordd1:11:C1:21:9eee5:coordd1:11:C1:21:8ee6:result4:MISSee5:coordd1:11:C1:21:3e6:result4:MISSe"
game1 = "d4:prevd5:coordd1:11:H1:21:5e6:result4:MISS4:prevd4:prevd5:coordd1:11:E1:21:9e4:prevd6:result3:HIT5:coordd1:11:C1:21:3e4:prevd6:result4:MISS5:coordd1:11:I1:21:6e4:prevd6:result3:HIT5:coordd1:11:I1:21:2e4:prevd4:prevd4:prevd5:coordd1:11:C1:21:1e4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:J1:21:7e4:prevd6:result4:MISS5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:I1:21:8e6:result4:MISS4:prevd5:coordd1:11:E1:21:8e6:result3:HIT4:prevd4:prevd4:prevd5:coordd1:11:C1:21:2ee5:coordd1:11:A1:21:7e6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3eeeeee5:coordd1:11:A1:21:3e6:result4:MISSe5:coordd1:11:B1:22:10ee6:result3:HITe5:coordd1:11:D1:21:9e6:result4:MISSe5:coordd1:11:F1:21:6e6:result4:MISSeeee6:result4:MISSe5:coordd1:11:D1:21:8e6:result4:MISSee6:result4:MISS5:coordd1:11:G1:21:8ee"
game2 = "d4:prevd5:coordd1:11:E1:21:3e6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:J1:21:1e4:prevd5:coordd1:11:E1:21:1e4:prevd5:coordd1:11:J1:21:6e4:prevd5:coordd1:11:A1:21:3e6:result4:MISS4:prevd5:coordd1:11:H1:22:10e6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:F1:21:4e4:prevd6:result4:MISS5:coordd1:11:A1:21:7e4:prevd6:result3:HIT4:prevd5:coordd1:11:I1:21:9e6:result4:MISS4:prevd5:coordd1:11:C1:21:5e6:result3:HIT4:prevd5:coordd1:11:G1:21:7e6:result4:MISS4:prevd5:coordd1:11:F1:21:2e6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:B1:21:8e4:prevd4:prevd6:result4:MISS5:coordd1:11:C1:22:10e4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:H1:21:3e4:prevd5:coordd1:11:J1:22:10e4:prevd5:coordd1:11:C1:21:6e4:prevd6:result4:MISS4:prevd5:coordd1:11:F1:21:5e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:H1:21:1e4:prevd5:coordd1:11:A1:21:1e4:prevd6:result4:MISS5:coordd1:11:E1:21:6e4:prevd4:prevd5:coordd1:11:F1:21:6e4:prevd5:coordd1:11:G1:21:3e4:prevd5:coordd1:11:I1:22:10e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:H1:21:3e6:result4:MISS4:prevd5:coordd1:11:D1:21:7e4:prevd5:coordd1:11:H1:21:5e6:result4:MISS4:prevd5:coordd1:11:J1:21:4e6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:9e4:prevd4:prevd6:result4:MISS5:coordd1:11:D1:21:3e4:prevd6:result4:MISS5:coordd1:11:F1:21:4e4:prevd4:prevd6:result4:MISS5:coordd1:11:I1:21:6e4:prevd4:prevd4:prevd5:coordd1:11:G1:21:1e4:prevd5:coordd1:11:H1:21:1e6:result4:MISS4:prevd5:coordd1:11:C1:21:9e4:prevd5:coordd1:11:B1:21:1e4:prevd6:result4:MISS4:prevd5:coordd1:11:H1:21:8e6:result4:MISS4:prevd5:coordd1:11:I1:21:3e6:result4:MISS4:prevd5:coordd1:11:H1:21:2e4:prevd6:result4:MISS4:prevd5:coordd1:11:G1:21:1e4:prevd5:coordd1:11:J1:21:8e6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:J1:21:4e4:prevd4:prevd4:prevd4:prevd6:result3:HIT5:coordd1:11:I1:21:5e4:prevd6:result4:MISS5:coordd1:11:A1:22:10e4:prevd6:result4:MISS5:coordd1:11:D1:21:7e4:prevd6:result3:HIT5:coordd1:11:C1:21:3e4:prevd5:coordd1:11:A1:21:5e4:prevd5:coordd1:11:I1:21:9e6:result4:MISS4:prevd5:coordd1:11:I1:21:3e4:prevd4:prevd6:result4:MISS5:coordd1:11:C1:21:3e4:prevd5:coordd1:11:A1:21:9e6:result4:MISS4:prevd5:coordd1:11:F1:21:5e6:result4:MISS4:prevd4:prevd4:prevd4:prevd4:prevd5:coordd1:11:B1:21:6e4:prevd5:coordd1:11:G1:21:2e4:prevd5:coordd1:11:I1:21:8ee6:result4:MISSe6:result4:MISSe5:coordd1:11:B1:21:4e6:result4:MISSe5:coordd1:11:C1:21:7e6:result4:MISSe6:result4:MISS5:coordd1:11:E1:21:5ee6:result4:MISS5:coordd1:11:E1:21:2eeeee5:coordd1:11:E1:21:8e6:result4:MISSe6:result4:MISSee6:result3:HITeeeee5:coordd1:11:G1:21:9e6:result4:MISSe5:coordd1:11:F1:21:8e6:result4:MISSe5:coordd1:11:H1:21:5e6:result4:MISSe6:result4:MISSe6:result4:MISS5:coordd1:11:I1:21:5ee5:coordd1:11:A1:21:6e6:result4:MISSee6:result4:MISSe5:coordd1:11:J1:21:5ee6:result4:MISSeee5:coordd1:11:A1:21:3ee6:result3:HITe6:result4:MISSee6:result4:MISSe5:coordd1:11:J1:21:6e6:result4:MISSe6:result4:MISS5:coordd1:11:F1:21:9eee6:result4:MISS5:coordd1:11:F1:21:3eeee6:result4:MISS5:coordd1:11:C1:21:9ee6:result4:MISSe5:coordd1:11:A1:21:2e6:result4:MISSeee6:result4:MISSee5:coordd1:11:B1:21:4ee5:coordd1:11:F1:22:10e6:result4:MISSee6:result3:HITe6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:8eee6:result4:MISSee5:coordd1:11:E1:21:2ee6:result4:MISSe5:coordd1:11:D1:22:10ee6:result4:MISSe6:result4:MISSee5:coordd1:11:B1:21:7ee6:result4:MISS5:coordd1:11:A1:21:6eee6:result3:HIT5:coordd1:11:D1:21:6eee6:result4:MISS5:coordd1:11:C1:21:2ee5:coordd1:11:H1:21:9eeeeee5:coordd1:11:C1:21:1eee6:result4:MISSe5:coordd1:11:G1:21:9eeee6:result3:HITe6:result4:MISSeee5:coordd1:11:E1:21:7e6:result4:MISSe"
-- Su klaida gale.
game3 = "d4:prevd4:prevd6:result3:HIT4:prevd5:coordd1:11:C1:21:9e4:prevd4:prevd4:prevd5:coordd1:11:D1:21:8e4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:7e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:D1:21:2e4:prevd5:coordd1:11:B1:21:6e6:result4:MISS4:prevd5:coordd1:11:C1:21:4e4:prevd4:prevd6:result4:MISS5:coordd1:11:G1:21:6e4:prevd4:prevd4:prevd5:coordd1:11:B1:21:8e4:prevd5:coordd1:11:F1:21:2e4:prevd6:result4:MISS5:coordd1:11:G1:21:2e4:prevd5:coordd1:11:I1:21:7e6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:3e4:prevd4:prevd5:coordd1:11:G1:21:3e4:prevd4:prevd5:coordd1:11:C1:21:5e4:prevd4:prevd6:result3:HIT5:coordd1:11:D1:22:10e4:prevd4:prevd5:coordd1:11:A1:21:5e4:prevd5:coordd1:11:E1:21:6e4:prevd6:result4:MISS5:coordd1:11:B1:21:6e4:prevd5:coordd1:11:F1:21:4e6:result4:MISS4:prevd4:prevd5:coordd1:11:I1:21:7e6:result4:MISS4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:6e4:prevd4:prevd4:prevd5:coordd1:11:D1:21:5e6:result4:MISS4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:D1:21:7e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:E1:21:6e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:F1:21:5e4:prevd5:coordd1:11:E1:21:9e4:prevd6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:J1:21:3e4:prevd5:coordd1:11:C1:21:8e6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:G1:21:5e4:prevd6:result4:MISS5:coordd1:11:F1:21:1e4:prevd4:prevd5:coordd1:11:J1:21:7e4:prevd6:result4:MISS5:coordd1:11:J1:21:2e4:prevd5:coordd1:11:B1:21:3e6:result4:MISS4:prevd5:coordd1:11:F1:21:3e4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:1e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:B1:21:2e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:D1:21:7e4:prevd5:coordd1:11:F1:21:4e4:prevd4:prevd5:coordd1:11:B1:21:1e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:C1:21:8e4:prevd5:coordd1:11:H1:21:4e4:prevd4:prevd4:prevd4:prevd6:result3:HIT5:coordd1:11:A1:21:1e4:prevd6:result3:HIT5:coordd1:11:I1:21:1e4:prevd4:prevd6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:G1:21:3e4:prevd5:coordd1:11:G1:21:8e4:prevd6:result4:MISS4:prevd5:coordd1:11:H1:21:4e4:prevd5:coordd1:11:A1:22:10e4:prevd5:coordd1:11:D1:21:3e6:result4:MISS4:prevd6:result3:HIT4:prevd5:coordd1:11:J1:22:10e6:result3:HIT4:prevd6:result3:HIT4:prevd4:prevd4:prevd4:prevd5:coordd1:11:J1:22:10e6:result4:MISS4:prevd5:coordd1:11:G1:22:10e6:result3:HIT4:prevd5:coordd1:11:B1:21:2e4:prevd4:prevd5:coordd1:11:H1:22:10e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:F1:21:9e6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:B1:21:4e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:A1:21:3e4:prevd6:result4:MISS5:coordd1:11:H1:21:3e4:prevd4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:E1:21:4e4:prevd6:result3:HIT4:prevd6:result3:HIT5:coordd1:11:I1:21:9e4:prevd6:result4:MISS5:coordd1:11:B1:21:9e4:prevd4:prevd4:prevd5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:H1:21:9e4:prevd5:coordd1:11:D1:21:9e6:result4:MISS4:prevd4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:G1:21:4e4:prevd5:coordd1:11:D1:21:4e4:prevd5:coordd1:11:H1:21:2e4:prevd4:prevd4:prevd5:coordd1:11:C1:21:2e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:I1:21:3e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT4:prevd5:coordd1:11:A1:21:2e6:result4:MISS4:prevd5:coordd1:11:G1:21:8e6:result4:MISS4:prevd5:coordd1:11:E1:21:8e6:result3:HIT4:prevd5:coordd1:11:I1:21:8e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:6e4:prevd6:result4:MISS4:prevd5:coordd1:11:J1:21:4e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:G1:21:9e6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:G1:21:7e4:prevd6:result4:MISS5:coordd1:11:H1:21:7e4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:B1:21:5e4:prevd5:coordd1:11:G1:21:4e6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:I1:22:10e6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:F1:21:7e4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:8e4:prevd4:prevd5:coordd1:11:B1:21:4e6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:G1:22:10e4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:E1:21:3e4:prevd6:result3:HIT4:prevd5:coordd1:11:H1:21:2e6:result4:MISS4:prevd4:prevd6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:A1:21:4e4:prevd5:coordd1:11:A1:21:4e6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:J1:21:2ee6:result3:HIT5:coordd1:11:H1:21:3ee5:coordd1:11:E1:21:3e6:result3:HITeee5:coordd1:11:I1:22:10ee6:result4:MISS5:coordd1:11:H1:22:10eee5:coordd1:11:H1:21:7eee6:result4:MISS5:coordd1:11:F1:22:10ee5:coordd1:11:I1:21:1e6:result4:MISSe5:coordd1:11:C1:21:1e6:result4:MISSe5:coordd1:11:B1:21:7e6:result4:MISSe5:coordd1:11:D1:21:6ee5:coordd1:11:I1:21:6ee6:result3:HIT5:coordd1:11:J1:21:6eee6:result4:MISS5:coordd1:11:E1:21:7eee6:result4:MISS5:coordd1:11:F1:21:8ee6:result4:MISSe5:coordd1:11:E1:21:2eeee5:coordd1:11:A1:21:9e6:result3:HITe5:coordd1:11:I1:21:2eee6:result3:HITe5:coordd1:11:A1:21:2e6:result4:MISSe5:coordd1:11:I1:21:6eee6:result4:MISSe5:coordd1:11:C1:21:6e6:result3:HITe5:coordd1:11:I1:21:8e6:result4:MISSee5:coordd1:11:C1:21:9e6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:6ee5:coordd1:11:E1:21:5e6:result4:MISSee5:coordd1:11:A1:21:6eee6:result3:HIT5:coordd1:11:G1:21:2ee5:coordd1:11:D1:21:6ee5:coordd1:11:B1:21:7e6:result4:MISSeeeee5:coordd1:11:G1:21:1ee5:coordd1:11:E1:21:1ee6:result4:MISS5:coordd1:11:A1:21:5eee5:coordd1:11:C1:21:4ee6:result4:MISS5:coordd1:11:F1:21:5eee6:result3:HIT5:coordd1:11:E1:22:10ee6:result4:MISS5:coordd1:11:C1:21:1ee6:result4:MISSe6:result4:MISSee6:result4:MISS5:coordd1:11:I1:21:5ee6:result4:MISS5:coordd1:11:H1:21:1ee5:coordd1:11:D1:21:8e6:result4:MISSee6:result4:MISSe6:result4:MISSe5:coordd1:11:F1:21:1e6:result4:MISSe6:result4:MISS5:coordd1:11:C1:21:3eeee5:coordd1:11:H1:21:1eee6:result4:MISS5:coordd1:11:F1:21:2ee5:coordd1:11:A1:21:3ee5:coordd1:11:J1:21:7e6:result3:HITeeee6:result4:MISS5:coordd1:11:I1:21:3ee5:coordd1:11:D1:21:1eee6:result4:MISS5:coordd1:11:A1:21:7ee5:coordd1:11:F1:21:8ee5:coordd1:11:C1:21:6ee6:result4:MISSe5:coordd1:11:B1:21:8e6:result4:MISSe6:result4:MISSeee6:result4:MISS5:coordd1:11:C1:21:7ee5:coordd1:11:B1:22:10e6:result4:MISSe5:coordd1:11:A1:22:10e6:result4:MISSe5:coordd1:11:E1:21:7eee5:coordd1:11:F1:22:10eee6:result4:MISSe6:result4:MISSe5:coordd1:11:E1:21:2ee6:result4:MISSee5:coordd1:11:J1:21:9ee5:coordd1:11:I1:21:9e6:result3:HITeee6:result4:MISS5:coordd1:11:J1:21:1ee6:result3:HIT5:coordd1:11:H1:21:5ee6:result4:MISS5:coordd1:11:H1:21:6ee6:result3:HITe6:result4:MISSe5:coordd1:11:B1:21:5e6:result4:MISSe5:coordd1:11:B1:21:9e6:result4:MISSe5:coordd1:11:D1:21:3e6:result3:HITee6:result4:MISS5:coordd1:11:H1:21:6ee6:result4:MISSee5:coordd1:11:J1:21:4ee5:coordd1:11:D1:21:2eeee5:coordd1:11:D1:21:4ee6:result4:MISSeee6:result4:MISSe5:coordd1:11:H1:21:8e6:result4:MISSeee5:coordd1:11:H1:21:9eeee5:coordd1:11:A1:21:6ee6:result4:MISSe6:result4:MISSe5:coordd1:11:H1:21:8ee5:coordd1:11:E1:21:4eee5:coordd1:11:C1:22:10e6:result4:MISSe5:coordd1:11:F1:21:9ee5:coordd1:11:D1:21:1eee6:result4:MISS5:coordd1:11:C1:21:3ee6:result3:HIT5:coordd1:11:A1:21:8eee5:coordd1:11:D1:21:5e6:result4:MISSe5:coordd1:11:D1:21:9e6:result4:MISSee6:result4:MISS5:coordd1:11:D1:22:10ee6:result4:MISS5:coordd1:11:J1:21:5eee6:result3:HIT5:coordd1:11:I1:21:4eeee6:result4:MISSe6:result4:MISSe6:result3:HIT5:coordd1:11:B1:21:3eee5:coordd1:11:A1:21:7e6:result4:MISSe6:result4:MISSe6:result4:MISS5:coordd1:11:C1:21:7ee6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:5eee5:coordd1:11:A1:21:8e6:result4:MISSeee6:result4:MISSe6:result4:MISSe5:coordd1:11:H1:21:5e6:result3:HITe5:coordd1:11:B1:21:1e6:result4:MISSee6:result3:HIT5:coordd1:11:I1:21:4ee6:result4:MISSee6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3ee5:coordd1:11:G1:21:9e6:result4:MISSe5:coordd1:11:E1:22:10ee5:coordd1:11:G1:21:5ee5:coordd1:11:I1:21:2ee5:coordd1:11:J1:21:8ee5:coordd1:11:C1:21:5eee6:result3:HIT5:coordd1:11:E1:21:9ee6:result4:MISSe5:coordd1:11:J1:21:9e6:result4:MISSe5:coordd1:11:C1:22:10e6:result4:MISSe6:result3:HITe5:coordd1:11:I1:21:5ee6:result4:MISS5:coordd1:11:G1:21:7ee5:coordde6:result3:HITe"
game4 = "d6:result4:MISS5:coordd1:11:J1:21:4e4:prevd4:prevd5:coordd1:11:J1:21:5e4:prevd6:result3:HIT4:prevd5:coordd1:11:F1:21:7e4:prevd4:prevd6:result4:MISS4:prevd4:prevd6:result3:HIT5:coordd1:11:I1:21:1e4:prevd4:prevd5:coordd1:11:E1:21:8e6:result4:MISS4:prevd4:prevd4:prevd4:prevd4:prevd6:result3:HIT4:prevd4:prevd5:coordd1:11:F1:21:8e6:result3:HIT4:prevd4:prevd4:prevd4:prevd5:coordd1:11:D1:21:7e4:prevd4:prevd5:coordd1:11:B1:21:4e6:result4:MISS4:prevd5:coordd1:11:H1:22:10e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:I1:21:7e4:prevd4:prevd5:coordd1:11:B1:21:7e4:prevd5:coordd1:11:A1:21:5e6:result4:MISS4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd5:coordd1:11:E1:21:2e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:B1:21:3e4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:3e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:H1:21:9e4:prevd5:coordd1:11:A1:22:10e6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:5e4:prevd4:prevd6:result3:HIT5:coordd1:11:J1:21:2e4:prevd4:prevd5:coordd1:11:E1:22:10e4:prevd4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:A1:21:3e4:prevd6:result4:MISS4:prevd5:coordd1:11:H1:21:5e6:result4:MISS4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:D1:21:3e4:prevd5:coordd1:11:G1:21:6e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:I1:21:4e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:C1:21:8e4:prevd6:result4:MISS5:coordd1:11:J1:21:7e4:prevd5:coordd1:11:G1:21:5e4:prevd6:result4:MISS5:coordd1:11:F1:21:1e4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:D1:21:9e4:prevd6:result4:MISS5:coordd1:11:I1:21:9e4:prevd5:coordd1:11:A1:21:8e6:result4:MISS4:prevd5:coordd1:11:B1:21:5e4:prevd6:result4:MISS5:coordd1:11:B1:21:4e4:prevd5:coordd1:11:G1:22:10e6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:3e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:F1:21:5e4:prevd5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:G1:21:7e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:9e4:prevd6:result3:HIT4:prevd5:coordd1:11:A1:21:4e4:prevd6:result3:HIT5:coordd1:11:J1:21:1e4:prevd4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:I1:21:5e6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:2e4:prevd6:result4:MISS5:coordd1:11:C1:21:7e4:prevd5:coordd1:11:A1:21:9e4:prevd4:prevd5:coordd1:11:A1:21:6ee5:coordd1:11:C1:21:4e6:result4:MISSe6:result4:MISSee6:result4:MISSe6:result4:MISS5:coordd1:11:J1:22:10ee5:coordd1:11:F1:21:4eee6:result4:MISS5:coordd1:11:G1:22:10ee5:coordd1:11:H1:21:7e6:result4:MISSee6:result4:MISS5:coordd1:11:G1:21:1ee5:coordd1:11:E1:21:9ee5:coordd1:11:J1:21:1e6:result4:MISSee6:result3:HITe5:coordd1:11:I1:21:7ee6:result4:MISSe5:coordd1:11:D1:21:6ee6:result4:MISS5:coordd1:11:C1:21:1eee6:result3:HITeee5:coordd1:11:C1:22:10e6:result4:MISSeee6:result4:MISSeeee5:coordd1:11:F1:21:3ee5:coordd1:11:H1:21:7e6:result4:MISSe5:coordd1:11:C1:21:9e6:result4:MISSee6:result4:MISSeeee6:result4:MISS5:coordd1:11:D1:21:6ee6:result4:MISS5:coordd1:11:C1:21:9ee5:coordd1:11:E1:21:3e6:result4:MISSeee5:coordd1:11:J1:21:8ee5:coordd1:11:G1:21:4e6:result4:MISSe5:coordd1:11:A1:22:10e6:result4:MISSe5:coordd1:11:H1:21:8ee5:coordd1:11:D1:21:1ee6:result4:MISS5:coordd1:11:G1:21:9ee6:result4:MISS5:coordd1:11:F1:21:6eee5:coordd1:11:G1:21:8eee5:coordd1:11:B1:21:2e6:result3:HITe5:coordd1:11:F1:22:10e6:result4:MISSe5:coordd1:11:I1:22:10e6:result4:MISSe6:result3:HITe6:result4:MISS5:coordd1:11:J1:21:2eee6:result3:HIT5:coordd1:11:C1:21:8eee5:coordd1:11:F1:21:2e6:result4:MISSee6:result3:HITe6:result4:MISS5:coordd1:11:I1:21:1ee5:coordd1:11:G1:21:4e6:result3:HITe6:result4:MISS5:coordd1:11:D1:21:5eee5:coordd1:11:C1:21:5eee5:coordd1:11:B1:21:3ee6:result4:MISSeee6:result3:HITe5:coordd1:11:I1:21:5e6:result4:MISSeeee6:result4:MISS5:coordd1:11:D1:21:2ee6:result4:MISSe5:coordd1:11:D1:21:3e6:result4:MISSe5:coordd1:11:A1:21:6e6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3eee5:coordd1:11:A1:21:4e6:result4:MISSe5:coordd1:11:G1:21:2ee5:coordd1:11:A1:21:3e6:result4:MISSe6:result3:HIT5:coordd1:11:J1:21:5ee6:result4:MISS5:coordd1:11:D1:21:8ee6:result4:MISS5:coordd1:11:J1:21:4eee6:result4:MISS5:coordd1:11:J1:21:9eee5:coordd1:11:I1:21:4e6:result3:HITe5:coordd1:11:H1:21:8ee6:result4:MISS5:coordd1:11:J1:21:3ee6:result3:HITe5:coordd1:11:F1:21:1ee6:result4:MISSe5:coordd1:11:B1:21:1e6:result4:MISSee"
-- Game 4 su pasikartojanciais coords
game5 = "d6:result4:MISS5:coordd1:11:J1:21:4e4:prevd4:prevd5:coordd1:11:J1:21:4e4:prevd6:result3:HIT4:prevd5:coordd1:11:F1:21:7e4:prevd4:prevd6:result4:MISS4:prevd4:prevd6:result3:HIT5:coordd1:11:I1:21:1e4:prevd4:prevd5:coordd1:11:E1:21:8e6:result4:MISS4:prevd4:prevd4:prevd4:prevd4:prevd6:result3:HIT4:prevd4:prevd5:coordd1:11:F1:21:8e6:result3:HIT4:prevd4:prevd4:prevd4:prevd5:coordd1:11:D1:21:7e4:prevd4:prevd5:coordd1:11:B1:21:4e6:result4:MISS4:prevd5:coordd1:11:H1:22:10e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:I1:21:7e4:prevd4:prevd5:coordd1:11:B1:21:7e4:prevd5:coordd1:11:A1:21:5e6:result4:MISS4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd5:coordd1:11:E1:21:2e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:B1:21:3e4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:3e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:H1:21:9e4:prevd5:coordd1:11:A1:22:10e6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:F1:21:5e4:prevd4:prevd6:result3:HIT5:coordd1:11:J1:21:2e4:prevd4:prevd5:coordd1:11:E1:22:10e4:prevd4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:A1:21:3e4:prevd6:result4:MISS4:prevd5:coordd1:11:H1:21:5e6:result4:MISS4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:D1:21:3e4:prevd5:coordd1:11:G1:21:6e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:I1:21:4e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:C1:21:8e4:prevd6:result4:MISS5:coordd1:11:J1:21:7e4:prevd5:coordd1:11:G1:21:5e4:prevd6:result4:MISS5:coordd1:11:F1:21:1e4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:D1:21:9e4:prevd6:result4:MISS5:coordd1:11:I1:21:9e4:prevd5:coordd1:11:A1:21:8e6:result4:MISS4:prevd5:coordd1:11:B1:21:5e4:prevd6:result4:MISS5:coordd1:11:B1:21:4e4:prevd5:coordd1:11:G1:22:10e6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:3e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:F1:21:5e4:prevd5:coordd1:11:A1:21:9e4:prevd5:coordd1:11:G1:21:7e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:9e4:prevd6:result3:HIT4:prevd5:coordd1:11:A1:21:4e4:prevd6:result3:HIT5:coordd1:11:J1:21:1e4:prevd4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:I1:21:5e6:result4:MISS4:prevd6:result3:HIT4:prevd4:prevd5:coordd1:11:H1:21:2e4:prevd6:result4:MISS5:coordd1:11:C1:21:7e4:prevd5:coordd1:11:A1:21:9e4:prevd4:prevd5:coordd1:11:A1:21:6ee5:coordd1:11:C1:21:4e6:result4:MISSe6:result4:MISSee6:result4:MISSe6:result4:MISS5:coordd1:11:J1:22:10ee5:coordd1:11:F1:21:4eee6:result4:MISS5:coordd1:11:G1:22:10ee5:coordd1:11:H1:21:7e6:result4:MISSee6:result4:MISS5:coordd1:11:G1:21:1ee5:coordd1:11:E1:21:9ee5:coordd1:11:J1:21:1e6:result4:MISSee6:result3:HITe5:coordd1:11:I1:21:7ee6:result4:MISSe5:coordd1:11:D1:21:6ee6:result4:MISS5:coordd1:11:C1:21:1eee6:result3:HITeee5:coordd1:11:C1:22:10e6:result4:MISSeee6:result4:MISSeeee5:coordd1:11:F1:21:3ee5:coordd1:11:H1:21:7e6:result4:MISSe5:coordd1:11:C1:21:9e6:result4:MISSee6:result4:MISSeeee6:result4:MISS5:coordd1:11:D1:21:6ee6:result4:MISS5:coordd1:11:C1:21:9ee5:coordd1:11:E1:21:3e6:result4:MISSeee5:coordd1:11:J1:21:8ee5:coordd1:11:G1:21:4e6:result4:MISSe5:coordd1:11:A1:22:10e6:result4:MISSe5:coordd1:11:H1:21:8ee5:coordd1:11:D1:21:1ee6:result4:MISS5:coordd1:11:G1:21:9ee6:result4:MISS5:coordd1:11:F1:21:6eee5:coordd1:11:G1:21:8eee5:coordd1:11:B1:21:2e6:result3:HITe5:coordd1:11:F1:22:10e6:result4:MISSe5:coordd1:11:I1:22:10e6:result4:MISSe6:result3:HITe6:result4:MISS5:coordd1:11:J1:21:2eee6:result3:HIT5:coordd1:11:C1:21:8eee5:coordd1:11:F1:21:2e6:result4:MISSee6:result3:HITe6:result4:MISS5:coordd1:11:I1:21:1ee5:coordd1:11:G1:21:4e6:result3:HITe6:result4:MISS5:coordd1:11:D1:21:5eee5:coordd1:11:C1:21:5eee5:coordd1:11:B1:21:3ee6:result4:MISSeee6:result3:HITe5:coordd1:11:I1:21:5e6:result4:MISSeeee6:result4:MISS5:coordd1:11:D1:21:2ee6:result4:MISSe5:coordd1:11:D1:21:3e6:result4:MISSe5:coordd1:11:A1:21:6e6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:3eee5:coordd1:11:A1:21:4e6:result4:MISSe5:coordd1:11:G1:21:2ee5:coordd1:11:A1:21:3e6:result4:MISSe6:result3:HIT5:coordd1:11:J1:21:5ee6:result4:MISS5:coordd1:11:D1:21:8ee6:result4:MISS5:coordd1:11:J1:21:4eee6:result4:MISS5:coordd1:11:J1:21:9eee5:coordd1:11:I1:21:4e6:result3:HITe5:coordd1:11:H1:21:8ee6:result4:MISS5:coordd1:11:J1:21:3ee6:result3:HITe5:coordd1:11:F1:21:1ee6:result4:MISSe5:coordd1:11:B1:21:1e6:result4:MISSee"

game = "d4:prevd4:prevd5:coordd1:11:I1:21:1e4:prevd6:result4:MISS5:coordd1:11:B1:21:7e4:prevd5:coordd1:11:C1:21:6e6:result4:MISS4:prevd4:prevd4:prevd4:prevd5:coordd1:11:A1:21:6e6:result4:MISS4:prevd5:coordd1:11:D1:21:4e6:result4:MISS4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:C1:21:3e4:prevd5:coordd1:11:I1:21:5e4:prevd6:result4:MISS5:coordd1:11:C1:21:1e4:prevd6:result4:MISS5:coordd1:11:C1:21:8e4:prevd6:result4:MISS4:prevd5:coordd1:11:A1:21:9e6:result4:MISS4:prevd5:coordd1:11:F1:21:1e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:F1:21:1e4:prevd6:result4:MISS4:prevd5:coordd1:11:F1:21:2e6:result3:HIT4:prevd6:result4:MISS5:coordd1:11:J1:21:3e4:prevd4:prevd4:prevd5:coordd1:11:E1:21:2e6:result4:MISS4:prevd5:coordd1:11:D1:21:3e4:prevd5:coordd1:11:B1:22:10e4:prevd4:prevd4:prevd4:prevd5:coordd1:11:I1:21:4e4:prevd6:result4:MISS5:coordd1:11:G1:21:8e4:prevd5:coordd1:11:J1:21:3e4:prevd4:prevd6:result4:MISS5:coordd1:11:J1:21:7e4:prevd6:result4:MISS4:prevd4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:H1:21:7e6:result3:HIT4:prevd4:prevd5:coordd1:11:I1:21:2e4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:E1:21:4e4:prevd6:result4:MISS5:coordd1:11:E1:21:6e4:prevd6:result4:MISS4:prevd4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:I1:21:3e4:prevd5:coordd1:11:F1:21:6e4:prevd4:prevd4:prevd4:prevd5:coordd1:11:D1:21:4e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:F1:21:8e4:prevd5:coordd1:11:G1:21:5e4:prevd6:result4:MISS5:coordd1:11:J1:21:6e4:prevd5:coordd1:11:D1:22:10e4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:E1:21:7e4:prevd5:coordd1:11:H1:21:8e6:result3:HIT4:prevd5:coordd1:11:I1:22:10e4:prevd4:prevd5:coordd1:11:H1:21:1e4:prevd5:coordd1:11:H1:21:5e4:prevd5:coordd1:11:J1:21:5e4:prevd4:prevd6:result4:MISS4:prevd5:coordd1:11:A1:21:2e4:prevd6:result4:MISS5:coordd1:11:D1:21:9e4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:G1:21:7e6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:A1:21:6e4:prevd6:result4:MISS4:prevd5:coordd1:11:E1:21:5e6:result4:MISS4:prevd4:prevd5:coordd1:11:J1:21:5e6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:I1:21:5e4:prevd5:coordd1:11:F1:21:7e6:result4:MISS4:prevd5:coordd1:11:G1:21:3e6:result4:MISS4:prevd4:prevd4:prevd5:coordd1:11:E1:21:4e6:result4:MISS4:prevd6:result4:MISS4:prevd4:prevd5:coordd1:11:D1:21:7e4:prevd4:prevd4:prevd5:coordd1:11:D1:21:2e6:result4:MISS4:prevd6:result3:HIT5:coordd1:11:E1:21:3e4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS5:coordd1:11:G1:22:10e4:prevd5:coordd1:11:H1:21:4e4:prevd4:prevd4:prevd4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:C1:21:4e6:result4:MISS4:prevd4:prevd6:result3:HIT4:prevd4:prevd4:prevd6:result4:MISS5:coordd1:11:H1:21:2e4:prevd5:coordd1:11:E1:21:1e6:result4:MISS4:prevd6:result4:MISS4:prevd5:coordd1:11:C1:21:5e4:prevd4:prevd5:coordd1:11:E1:21:7e4:prevd5:coordd1:11:A1:21:2e6:result4:MISS4:prevd4:prevd6:result4:MISS4:prevd4:prevd6:result4:MISS5:coordd1:11:I1:21:4e4:prevd6:result3:HIT4:prevd5:coordd1:11:C1:22:10ee5:coordd1:11:A1:21:7eee5:coordd1:11:D1:21:3e6:result4:MISSe5:coordd1:11:J1:21:8ee6:result4:MISS5:coordd1:11:J1:21:9eee6:result3:HITe6:result3:HIT5:coordd1:11:G1:22:10ee6:result4:MISSe5:coordd1:11:F1:21:2eeee5:coordd1:11:I1:21:1e6:result4:MISSe6:result4:MISS5:coordd1:11:J1:21:2ee5:coordd1:11:I1:21:8ee5:coordd1:11:B1:21:1e6:result3:HITee5:coordd1:11:F1:21:4ee5:coordd1:11:J1:21:6ee5:coordd1:11:B1:21:9ee5:coordd1:11:C1:21:7e6:result3:HITe5:coordd1:11:H1:21:6e6:result4:MISSe6:result3:HIT5:coordd1:11:E1:22:10ee6:result4:MISSee5:coordd1:11:G1:21:6ee5:coordd1:11:C1:21:2e6:result3:HITeee5:coordd1:11:A1:21:3e6:result4:MISSe6:result3:HIT5:coordd1:11:A1:21:8ee6:result4:MISSe5:coordd1:11:G1:21:8e6:result4:MISSe5:coordd1:11:E1:21:9eee5:coordd1:11:I1:21:9e6:result4:MISSe5:coordd1:11:H1:21:7e6:result3:HITeeeee6:result4:MISS5:coordd1:11:G1:21:4eee5:coordd1:11:F1:21:9eeee6:result3:HIT5:coordd1:11:J1:22:10ee5:coordd1:11:E1:21:1ee5:coordd1:11:A1:21:4eee6:result4:MISSe5:coordd1:11:I1:21:7ee6:result4:MISS5:coordd1:11:G1:21:2ee6:result4:MISSe6:result4:MISSe6:result4:MISSe5:coordd1:11:D1:21:1e6:result4:MISSe6:result4:MISSeee5:coordd1:11:F1:21:8e6:result4:MISSe6:result4:MISS5:coordd1:11:E1:21:6ee6:result4:MISSee6:result4:MISSe6:result4:MISSe5:coordd1:11:B1:21:1ee5:coordd1:11:B1:21:7ee6:result4:MISS5:coordd1:11:F1:21:4eee6:result4:MISS5:coordd1:11:B1:21:2ee5:coordd1:11:A1:21:5e6:result3:HITe5:coordd1:11:H1:21:2e6:result3:HITe6:result3:HITee5:coordd1:11:H1:21:3ee6:result4:MISS5:coordd1:11:G1:21:4ee6:result3:HIT5:coordd1:11:J1:21:7ee5:coordd1:11:A1:21:3e6:result4:MISSe5:coordd1:11:G1:21:9eeee5:coordd1:11:C1:21:6ee6:result4:MISSe6:result4:MISS5:coordd1:11:F1:21:6eee5:coordd1:11:C1:21:9ee5:coordd1:11:C1:21:8e6:result3:HITe6:result4:MISS5:coordd1:11:F1:21:5ee5:coordd1:11:C1:21:5eee6:result4:MISS5:coordd1:11:G1:21:1ee6:result4:MISSee6:result4:MISSe5:coordd1:11:A1:21:8e6:result4:MISSe5:coordd1:11:H1:21:4e6:result4:MISSe6:result4:MISS5:coordd1:11:B1:21:8ee6:result4:MISSe6:result4:MISSee5:coordd1:11:D1:21:6e6:result4:MISSe5:coordd1:11:H1:22:10e6:result4:MISSeee5:coordd1:11:A1:21:9eeeee5:coordd1:11:B1:21:2eeee6:result4:MISSee6:result4:MISS5:coordd1:11:B1:21:3ee5:coordd1:11:D1:22:10e6:result3:HITeee5:coordd1:11:B1:21:9e6:result4:MISSe6:result3:HIT5:coordd1:11:A1:21:7ee5:coordd1:11:D1:21:5e6:result4:MISSeee6:result3:HITe6:result3:HIT5:coordd1:11:D1:21:6ee5:coordd1:11:B1:22:10e6:result4:MISSe"

type Coordinates = (String, String)
data ResultType = HIT | MISS | NONE deriving (Eq,Ord,Enum,Show)

data Move = Empty | ValidMove { coords :: Coordinates
                        , result :: ResultType
                        , prev :: Move } deriving (Show, Eq)

emptyMove = ValidMove ("", "") NONE Main.Empty

main = do
    let opts = defaults & header "Accept" .~ ["application/relaxed-bencoding+nolists"]
    r <- getWith opts "http://battleship.haskell.lt/game/late2/player/B"
    print r

main2 = do
    let message = game
    -- At the end, tail should be empty
    let (lastParsedMove, _) = readMove emptyMove message
    case validateMovesForAB lastParsedMove of 
        Right _ -> do
            let numberOfMoves = show (getNumberOfMoves lastParsedMove)
            print $ "Number of moves: " ++ numberOfMoves
            let (scoreA, scoreB) = calculateScoreForPlayersAB lastParsedMove
            print $ "Score A: " ++ show scoreA ++ " B: " ++ show scoreB
        Left errorMessage -> error errorMessage



-- Error | (hits of A, hits of B)
calculateScoreForPlayersAB :: Move -> (Int, Int)
calculateScoreForPlayersAB move = do
    let numberOfMoves = getNumberOfMoves move
    let prevMove = prev move
    if isEven numberOfMoves then
        (calculateScore prevMove, calculateScore move)
    else
        (calculateScore move, calculateScore prevMove)



calculateScore :: Move -> Int
calculateScore move = do
    let lastMoveScore = incrementScoreIfHit move 0
    let (_, score) = getPrev move lastMoveScore
    score
    where
        getPrev :: Move -> Int -> (Move, Int)
        getPrev move score = do
            let prevPreMove = prev (prev move)
            if prev move /= Main.Empty && prevPreMove /= Main.Empty
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
            if prevMove /= Main.Empty
                then getPrev prevMove incrementedScore
            else (prevMove, incrementedScore)



validateMovesForAB :: Move -> Either String Bool
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
                if prev move /= Main.Empty && prevPreMove /= Main.Empty
                    then checkPrev prevPreMove appendedList
                else Right True
        areCoordsInList :: Coordinates -> [Coordinates] -> Bool
        areCoordsInList coordsToCheck coordList = coordsToCheck `elem` coordList



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
    -- else error $ createSyntaxError "Coords dictionary should be size of 2, but got: " ++ show dictionary ++ " in: " ++ message
    else (("0", "0"), tail)


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



createSyntaxError :: String -> String
createSyntaxError errorMessage = "Syntax error: " ++ errorMessage



splitAtFirst :: Eq a => a -> [a] -> ([a], [a])
splitAtFirst x = fmap (drop 1) . break (x ==)


appendList :: Eq a => a -> [a] -> [a]
appendList a = foldr (:) [a]



prependList :: Eq a => a -> [a] -> [a]
prependList element list = element:list


get1st (a, _) = a
get2nd (_, b) = b


isEven n = mod n 2 == 0
