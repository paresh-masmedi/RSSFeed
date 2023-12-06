//
//  RSSFeedDetailViewModel.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 05/12/23.
//

import Foundation

class RSSFeedDetailViewModel: ObservableObject {
    //RSS Feed data
    @Published var feed: RSSFeed
    
    //Constant message
    let constNoContent: String = "No content found!"
    
    init(feed: RSSFeed) {
        self.feed = feed
        
        //Set bookmark value
        self.feed.bookmark = UserDefaultsManager.shared.containsBookmark(feedGUID: self.feed.guid)
    }
    
    //User bookmark a feed or not
    func bookmarkChanges() {
        if self.feed.bookmark == false {
            UserDefaultsManager.shared.addBookmark(feed: feed)
        } else {
            UserDefaultsManager.shared.removeBookmark(feedGUID: feed.guid)
        }
        
        feed.bookmark = !feed.bookmark
    }
    
    //As we have implement based on theme so need to use custom CSS to load data in webview
    func generateHTMLTextBasedOnTheme(_ themeColor: String) -> String {
        //Text
        let curBody = feed.content ?? constNoContent
        return """
                                                  <!doctype html>
                                                  <html lang="en">
                                                  <head>
                                                  <meta charset="utf-8">
                                                  <style type="text/css">
                                                  /*
                                                  Custom CSS styling of HTML formatted text.
                                                  Note, only a limited number of CSS features are supported by NSAttributedString/UITextView.
                                                  */
                                                  
                                                  body {
                                                  font: -apple-system-body;
                                                  font-size: 300%;
                                                  color: \(Theme.default.textPrimary.hex);
                                                  }
                                                  
                                                  h1, h2, h3, h4, h5, h6 {
                                                  color: \(Theme.default.textPrimary.hex);
                                                  }
                                                  
                                                  a {
                                                  color: \(Theme.default.textInteractive.hex);
                                                  }
                                                  
                                                  li:last-child {
                                                  margin-bottom: 1em;
                                                  }
                                                      </style>
                                                  </head>
                                                  <body bgcolor="\(themeColor)">
                                                      \(curBody)
                                                  </body>
                                                  </html>
                                                  """
    }
}
