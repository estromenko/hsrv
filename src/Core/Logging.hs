{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards #-}

module Core.Logging
  ( debug
  , err
  , info
  ) where

import qualified Colog
import qualified Data.Text                     as Text

fmtMessage :: Colog.Message -> Text.Text
fmtMessage Colog.Msg {..} = Colog.showSeverity msgSeverity <> msgText

logFunc
  :: (Text.Text -> Colog.LoggerT Colog.Message IO ()) -> Text.Text -> IO ()
logFunc func message = do
  let action = Colog.cmap fmtMessage Colog.logTextStdout
  Colog.usingLoggerT action $ func message

debug :: Text.Text -> IO ()
debug = logFunc Colog.logDebug

info :: Text.Text -> IO ()
info = logFunc Colog.logInfo

err :: Text.Text -> IO ()
err = logFunc Colog.logError
