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
            RSSFeedView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
