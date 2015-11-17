-- | Program configuration covering all the options.
module Nyanbda.Config where
import Nyanbda.Sources.Types
import Nyanbda.Types

data Config = Config {
    -- * Global configuration

    -- | Write any files to this directory. If @Nothing@, the current working
    --   directory is used.
    cfgOutdir      :: Maybe FilePath,

    -- | Sources to search.
    cfgSources     :: [Source],

    -- | Print episode names in which style?
    cfgNameStyle   :: Episode -> String,

    
    -- * Episode filters
    
    -- | Permissible seasons.
    cfgSeasons     :: [Int],

    -- | Permissible episodes.
    cfgEpisodes    :: [Int],

    -- | Always match the latest episode?
    --   If one or more seasons are given, this will always match the latest
    --   episode of each season. Otherwise, the latest episode of the latest
    --   season will be matched.
    cfgMatchLatest :: Bool,
    
    -- | Permissible file extensions.
    cfgExtensions  :: [String],

    -- | Permissible resolutions.
    cfgResolutions :: [Resolution],

    -- | Permissible release groups.
    cfgGroups      :: [String],

    -- | Allow several copies with different resolution, etc. of the same
    --   episode?
    cfgAllowDupes  :: Bool
  }

-- | Show an episode name appropriately according to config.
episodeName :: Config -> Episode -> String
episodeName = cfgNameStyle

-- | The default configuration.
defaultConfig :: Config
defaultConfig = Config {
    cfgOutdir      = Nothing,
    cfgSources     = [],
    cfgNameStyle   = episodeNameAnime,
    cfgSeasons     = [],
    cfgEpisodes    = [],
    cfgMatchLatest = False,
    cfgExtensions  = [],
    cfgResolutions = [],
    cfgGroups      = [],
    cfgAllowDupes  = False
  }
