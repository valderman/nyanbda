-- | Nyanbda torrent sources.
module Nyanbda.Sources (Source (..), SourceOpt, supportedSources) where
import Nyanbda.Sources.Types
import Nyanbda.Sources.Nyaa
import Nyanbda.Sources.RSS

-- | A list of all supported sources.
supportedSources :: [Source]
supportedSources = [nyaaSource, rssSource]