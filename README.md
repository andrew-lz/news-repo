# news-repo

# Version

1.0

# Build and Runtime Requirements

1. Xcode 6.0 or later
2. iOS 8.0 or later

# Steps:

1. git clone https://github.com/andrew-lz/news-repo
2. Open news-repo/News-View/News-View.xcodeproj
3. In file NetworkDataFetcher set your own apiKey or use one of suggested apiKeys(you can make 100 requests per day using one apiKey). 
4. If you want to change default news topic(bitcoin), open Services/NetworkDataFetcher, in func formUrl change q parameter to your own topic.
5. Now you can run News-View application!!!
