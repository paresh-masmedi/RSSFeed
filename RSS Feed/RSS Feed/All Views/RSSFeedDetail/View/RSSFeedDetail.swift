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
        Text("")
            .navigationBarTitle("", displayMode: .inline)
            .foregroundColor(.primary)
        
        ScrollViewReader { value in
            ScrollView (.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(feed.title)
                        .font(.system(size: 18))
                    Text("By: \(feed.creator) on \(feed.pubDate)")
                        .font(.system(size: 12))
                    Text(feed.content ?? "")
                        .font(.system(size: 14))
                }
                .padding(16)
            }
        }
    }
}

struct RSSFeedDetail_Previews: PreviewProvider {
    static var previews: some View {
        RSSFeedDetail(feed: RSSFeed(guid: "1", title: "Sample", link: "", pubDate: "", creator: "")).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

