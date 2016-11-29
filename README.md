# QuickMemes
QuickMemes is an iOS application that provides the user with a handful of trending memes on Twitter. The app only displays up to 25 memes per section (Popular, New, and Top). The idea is to get a quick fix for your meme-addiction without wasting more time than necessary to stay up to date with the latest memes.

## Application Details
QuickMemes is pulling data down from one of Reddit's subreddit via URLSession, downloads and caches the images with [SDWebImage](https://github.com/rs/SDWebImage), and is displayed and filtered using [BetterSegmentedControl](https://github.com/gmarm/BetterSegmentedControl)
