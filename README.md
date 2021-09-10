# news-repo

# Version

1.0

# Build and Runtime Requirements

1. Xcode 6.0 or later
2. iOS 8.0 or later

# Configuring the Project

Open the project in the Project navigator within Xcode and select each of the targets. Set the Team on the General tab to the team associated with your developer account.

Change the Bundle Identifier.
With the project's General tab still open, update the Bundle Identifier value. The project's News-View target ships with the value:

com.example.apple-samplecode.News-View

# Steps:

1. git clone https://github.com/andrew-lz/news-repo
2. Open news-repo/News-View/News-View.xcodeproj
3. In file NetworkDataFetcher set your own apiKey or use one of suggested apiKeys(you can make 100 requests per day using one apiKey). 
4. If you want to change default news topic(bitcoin), open Services/NetworkDataFetcher, in func formUrl change q parameter to your own topic.
5. Now you can run News-View application!!!
