module Main where

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar (MVar, newEmptyMVar, putMVar, takeMVar)
import Control.Monad (forM_, replicateM)

worker :: Int -> MVar () -> IO ()
worker i done = do
  forM_ [1 .. 5 :: Int] $ \step -> do
    putStrLn $ "worker " ++ show i ++ " step " ++ show step
    threadDelay 100000
  putMVar done ()

main :: IO ()
main = do
  let n = 4
  dones <- replicateM n newEmptyMVar
  forM_ (zip [1 .. n] dones) $ \(i, done) -> do
    _ <- forkIO (worker i done)
    pure ()
  forM_ dones takeMVar
  putStrLn "all done"


