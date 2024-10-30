//
//  BookmarkManager.swift
//  JournalApp
//
//

import Foundation

struct BookmarkManager {
    static func saveBookmarkState(entryId: String, isBookmarked: Bool) {
        UserDefaults.standard.set(isBookmarked, forKey: entryId)
    }

    static func loadBookmarkState(entryId: String) -> Bool {
        return UserDefaults.standard.bool(forKey: entryId)
    }
}
