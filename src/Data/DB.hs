module Data.DB
  ( getPool
  ) where

import qualified Core.Config                   as Conf
import qualified Data.Fixed                    as Fixed
import qualified Data.Pool                     as Pool
import qualified Data.String                   as String
import qualified Data.Time.Clock               as Time
import qualified Database.PostgreSQL.Simple    as PG

toNominalDiffTime :: Integer -> Time.NominalDiffTime
toNominalDiffTime =
  Time.secondsToNominalDiffTime . Fixed.MkFixed . (* 1000000000000)

getPool :: Conf.Config -> IO (Pool.Pool PG.Connection)
getPool config =
  let stripes = Conf.dbStripes config
      unusedResourceLifetime =
        (toNominalDiffTime . toInteger) $ Conf.dbUnusedResourceLifetime config
      resourcesPerStripe = Conf.dbResourcesPerStripe config
  in  Pool.createPool connect
                      PG.close
                      stripes
                      unusedResourceLifetime
                      resourcesPerStripe
  where connect = PG.connectPostgreSQL $ String.fromString (Conf.dbDsn config)
