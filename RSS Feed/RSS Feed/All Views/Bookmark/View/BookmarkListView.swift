//
//  BookmarkListView.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 06/12/23.
//

import SwiftUI
import CoreData

struct BookmarkListView: View {
    
    // Use this to only fire your block one time
    @State var feeds: [RSSFeed]
    
        
    var body: some View {
        NavigationView {
            //As we need activity indicator and list with same aspect ratio
            ZStack {
                //Table list
                List {
                    ForEach(feeds, id: \.id) { feed in
                        NavigationLink {
                            RSSFeedDetailView(viewModel: RSSFeedDetailViewModel(feed: feed))
                            
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(feed.title)
                                Text("By: \(feed.creator) on \(feed.pubDate)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                //Navigation title
                .navigationTitle("Bookmark Feed")
                //Here we can call business logic once view appears
                .onAppear {
                    //Log
                    Logger.shared.log(message: "BookmarkListView: onAppear")
                    
                    //Set data
                    self.feeds = UserDefaultsManager.shared.getBookmarkFeeds()
                }
            }
        }
    }
}

//Preview
struct BookmarkListView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkListView(feeds: [])
    }
}
