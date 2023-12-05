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
    private var arrBookmarks = Array<String>()
    
    //Intial constructor
    init() {
        arrBookmarks = loadSet()
    }

    // Save set to UserDefaults
    private func saveSet() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(arrBookmarks) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    // Retrieve set from UserDefaults
    private func loadSet() -> Array<String> {
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Array<String>.self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    // Add a bookmark to UserDefaults
    func addBookmark(bookmark: String) {
        arrBookmarks.append(bookmark)
        saveSet()
    }
    
    // Remove a bookmark to UserDefaults
    func removeBookmark(bookmark: String) {
        if let index: Int = arrBookmarks.firstIndex(of: bookmark) {
            arrBookmarks.remove(at: index)
        }
        saveSet()
    }
    
    // Check a bookmark exist in UserDefaults
    func containsBookmark(bookmark: String) -> Bool {
        let isContains = arrBookmarks.contains(bookmark)
        return isContains
    }
}
