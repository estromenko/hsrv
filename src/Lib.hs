module Lib
  ( main
  ) where

import qualified Configuration.Dotenv          as Dotenv
import qualified Core.Config                   as Conf
import qualified Core.Logging                  as Log
import qualified Data.DB                       as DB
import qualified Data.String                   as String
import qualified Network.Wai.Handler.Warp      as Warp
import qualified Server.Routing                as Routing
import qualified Web.Scotty                    as Scotty

main :: IO ()
main = do
  _      <- Dotenv.loadFile Dotenv.defaultConfig
  config <- Conf.getConfig
  pool   <- DB.getPool config
  Log.info $ String.fromString $ "Listening on " ++ show (Conf.port config)
  app <- Scotty.scottyApp $ Routing.route pool config
  let settings = Warp.setPort (Conf.port config) Warp.defaultSettings
  Warp.runSettings settings app
