{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_fp_first (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/danieliusritvas/.cabal/bin"
libdir     = "/Users/danieliusritvas/.cabal/lib/x86_64-osx-ghc-8.8.1/fp-first-0.1.0.0-inplace-fp-first-exe"
dynlibdir  = "/Users/danieliusritvas/.cabal/lib/x86_64-osx-ghc-8.8.1"
datadir    = "/Users/danieliusritvas/.cabal/share/x86_64-osx-ghc-8.8.1/fp-first-0.1.0.0"
libexecdir = "/Users/danieliusritvas/.cabal/libexec/x86_64-osx-ghc-8.8.1/fp-first-0.1.0.0"
sysconfdir = "/Users/danieliusritvas/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "fp_first_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "fp_first_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "fp_first_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "fp_first_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "fp_first_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "fp_first_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
