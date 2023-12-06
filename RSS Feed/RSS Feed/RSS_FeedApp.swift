//
//  RSS_FeedApp.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import SwiftUI

@main
struct RSS_FeedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView() {
                    RSSFeedView(viewModel: RSSFeedViewModel())
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .tabItem {
                            Label("RSS Feeds", systemImage: "list.bullet.indent")
                        }
                        .tag(0)
                    
                    BookmarkListView(feeds: [])
                        .tabItem {
                            Label("Bookmark", systemImage: "bookmark")
                        }
                        .tag(1)
                    
                }.onAppear() {
                }
            }
        }
    }
}
