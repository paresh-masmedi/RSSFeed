//
//  RSSFeedDetail.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 02/12/23.
//

import SwiftUI

struct RSSFeedDetail: View {
    //Know current device color
    @Environment(\.colorScheme) var colorScheme

    //Single feed data
    @State var feed: RSSFeed
    //Know html text changes
    @State var strHTML: String = ""
    
    //Static message
    let constNoContent: String = "No content found!"

    var body: some View {
        //Show vertical views
        VStack(alignment: .leading, spacing: 16) {
            //Tile
            Text(feed.title)
                .font(.system(size: 18))
            
            //Author and date together
            Text("By: \(feed.creator) on \(feed.pubDate)")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
            
            //Check has feed data
            WebView(htmlString: $strHTML)
                .ignoresSafeArea(edges: .bottom)
                .onChange(of: colorScheme) { newValue in
                    print("Theme changes: \(newValue)")
                    
                    if colorScheme != newValue {
                        strHTML = generateHTMLString(body: feed.content, changedColorScheme: newValue)
                    }
                    
                }
        }
        .padding([.leading, .trailing], 16)
        .onAppear {
            //Log
            print("RSSFeedDetail: onAppear")
            
            strHTML = generateHTMLString(body: feed.content)
            //print("strHTML: \(strHTML)")
        }
    }
    
    //As we have implement based on theme so need to use custom CSS to load data in webview
    func generateHTMLString(body: String?, changedColorScheme: ColorScheme? = nil) -> String {
        //Text
        let curBody = body ?? constNoContent
        
        //Its for html body color
        var curThemeColor = "black"
        if let curColorScheme = changedColorScheme {
            curThemeColor = curColorScheme == .dark ? "black" : "white"
        } else {
            curThemeColor = colorScheme == .dark ? "black" : "white"
        }
        print("curThemeColor: \(curThemeColor)")
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
                                                  font-size: 250%;
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
                                                  <body bgcolor="\(curThemeColor)">
                                                      \(curBody)
                                                  </body>
                                                  </html>
                                                  """
    }
}

//Preview
struct RSSFeedDetail_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedDetail(feed: RSSFeed(guid: "1234567890", title: "Breakings news: Storm is coming", link: "http://www.google.com", pubDate: "Sat, 02 Dec 2023 02:58:46 GMT", creator: "Paresh Navadiya")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
