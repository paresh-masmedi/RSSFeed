//
//  RSSFeedDetail.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 02/12/23.
//

import SwiftUI

struct RSSFeedDetail: View {
    
    @State var feed: RSSFeed

    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            Text(feed.title)
                .font(.system(size: 18))
            Text("By: \(feed.creator) on \(feed.pubDate)")
                .font(.system(size: 12))
            
            WebView(htmlString: generateHTMLString(body: feed.content ?? ""))
                .ignoresSafeArea(edges: .bottom)
        }
        .padding(16)
    }
    
    func generateHTMLString(body: String) -> String {
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
                                                  color: \(Theme.default.textSecondary.hex);
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
                                                  <body>
                                                      \(body)
                                                  </body>
                                                  </html>
                                                  """
    }
}

struct RSSFeedDetail_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedDetail(feed: RSSFeed(guid: "1", title: "Sample", link: "", pubDate: "", creator: "")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
