docpadConfig = {

    outPath: "../OUTPUT"

    plugins:
        sitemap:
            cachetime: 600000
            changefreq: "weekly"
            priority: 0.5
            filePath: "sitemap.xml"
            collectionName: "posts"

    templateData:
        site:
            url: "http://sharovatov.github.io"
            services:
               twitterTweetButton: "sharovatov"
               twitterFollowButton: "sharovatov"
               githubFollowButton: "sharovatov"
               disqus: "sharovatov"

    collections:
        posts: ->
            @getCollection("html").findAllLive({relativeOutDirPath: 'posts'},[{date:-1}])
        books: ->
            @getCollection("html").findAllLive({relativeOutDirPath: 'books'},[{date:-1}])


}

module.exports = docpadConfig