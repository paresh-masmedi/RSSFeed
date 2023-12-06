//
//  UserDefaultsManager.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 04/12/23.
//

import Foundation

class UserDefaultsManager {
    //Singleton
    static let shared = UserDefaultsManager()
    
    //Save key
    private let key = "feeds_bookmarked"
    
    //Data
    private var arrBookmarks = Array<RSSFeed>()
    
    //Intial constructor
    init() {
        arrBookmarks = loadFeeds()
    }

    // Save set to UserDefaults
    private func saveFeeds() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(arrBookmarks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // Retrieve set from UserDefaults
    private func loadFeeds() -> [RSSFeed] {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([RSSFeed].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    func getBookmarkFeeds() -> [RSSFeed] {
        return arrBookmarks
    }
    
    // Add a bookmark to UserDefaults
    func addBookmark(feed: RSSFeed) {
        arrBookmarks.append(feed)
        saveFeeds()
    }
    
    // Remove a bookmark to UserDefaults
    func removeBookmark(feedGUID: String) {
        if let index: Int = arrBookmarks.firstIndex(where: { feed in
            return feed.guid == feedGUID
        }), index > -1 {
            arrBookmarks.remove(at: index)
        }
        saveFeeds()
    }
    
    // Check a bookmark exist in UserDefaults
    func containsBookmark(feedGUID: String) -> Bool {
        var isContains = false
        if let index: Int = arrBookmarks.firstIndex(where: { feed in
            return feed.guid == feedGUID
        }), index > -1 {
            isContains = true
        }
        return isContains
    }
}
