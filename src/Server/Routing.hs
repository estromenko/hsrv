{-# LANGUAGE OverloadedStrings #-}

module Server.Routing
  ( route
  ) where

import           Control.Monad.IO.Class         ( MonadIO(liftIO) )
import qualified Core.Config                   as Conf
import qualified Data.DateTime                 as DateTime
import qualified Data.Pool                     as Pool
import qualified Data.String                   as String
import qualified Database.PostgreSQL.Simple    as SQL
import           Web.Scotty                     ( ActionM
                                                , ScottyM
                                                , get
                                                , html
                                                , json
                                                , redirect
                                                )

handleRedirect :: ActionM ()
handleRedirect = redirect "/ping"

handlePing :: ActionM ()
handlePing = html "pong"

handleNow :: Pool.Pool SQL.Connection -> ActionM ()
handleNow pool = do
  rows <- liftIO $ Pool.withResource pool query
  html $ mconcat $ map (String.fromString . show . SQL.fromOnly) rows
 where
  query conn =
    SQL.query_ conn "select now()" :: IO [SQL.Only DateTime.DateTime]

handleConfig :: Conf.Config -> ActionM ()
handleConfig config = do
  json config

route :: Pool.Pool SQL.Connection -> Conf.Config -> ScottyM ()
route pool config = do
  get "/"     handleRedirect
  get "/ping" handlePing
  get "/now" $ handleNow pool
  get "/config" $ handleConfig config
