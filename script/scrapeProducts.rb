require 'feedzirra'

# fetching a single feed
feed = Feedzirra::Feed.fetch_and_parse("http://feeds.feedburner.com/PaulDixExplainsNothing")

# feed and entries accessors
feed.title          # => "Paul Dix Explains Nothing"
feed.url            # => "http://www.pauldix.net"
feed.feed_url       # => "http://feeds.feedburner.com/PaulDixExplainsNothing"
feed.etag           # => "GunxqnEP4NeYhrqq9TyVKTuDnh0"
feed.last_modified  # => Sat Jan 31 17:58:16 -0500 2009 # it's a Time object