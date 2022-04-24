module Core.Environment where

import qualified Core.Logging                  as Log
import           Data.String                    ( IsString(fromString) )
import           System.Environment             ( lookupEnv )
import qualified System.Environment.MrEnv      as MrEnv
import           System.Exit                    ( exitFailure )
import           Text.Read                      ( readMaybe )

getIntDefault :: String -> Int -> IO Int
getIntDefault = MrEnv.envAsInt

getInt :: String -> IO Int
getInt name = do
  envVar <- lookupEnv name
  case envVar of
    Nothing -> do
      Log.err $ fromString $ mconcat [name, " env variable is not provided"]
      exitFailure
    Just value -> case readMaybe value of
      Nothing -> do
        Log.err $ fromString $ mconcat
          ["Value of env vaariable ", name, " is invalid"]
        exitFailure
      Just intValue -> return intValue

getStringDefault :: String -> String -> IO String
getStringDefault = MrEnv.envAsString

getString :: String -> IO String
getString name = do
  envVar <- lookupEnv name
  case envVar of
    Nothing -> do
      Log.err $ fromString $ mconcat [name, " env variable is not provided"]
      exitFailure
    Just s -> return s

getBoolDefault :: String -> Bool -> IO Bool
getBoolDefault = MrEnv.envAsBool
