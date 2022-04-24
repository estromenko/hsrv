{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module Core.Config where

import qualified Core.Environment              as Env
import qualified Data.Aeson                    as Aeson
import qualified GHC.Generics                  as Generics

data Config = Config
  { debug                    :: Bool
  , port                     :: Int
  , secretKey                :: String
  , dbDsn                    :: String
  , dbStripes                :: Int
  , dbResourcesPerStripe     :: Int
  , dbUnusedResourceLifetime :: Int
  }
  deriving (Generics.Generic, Show)

instance Aeson.ToJSON Config where
  toEncoding = Aeson.genericToEncoding Aeson.defaultOptions

getConfig :: IO Config
getConfig =
  Config
    <$> Env.getBoolDefault "DEBUG" False
    <*> Env.getInt "PORT"
    <*> Env.getString "SECRET_KEY"
    <*> Env.getString "DB_DSN"
    <*> Env.getIntDefault "DB_STRIPES" 25
    <*> Env.getIntDefault "DB_RESOURCES_PER_STRIPE" 25
    <*> Env.getIntDefault "DB_UNUSED_RESOURCE_LIFETIME" 300
