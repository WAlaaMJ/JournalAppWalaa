//
//  JournalEntry.swift
//  JournalApp
//
//

import SwiftData
import Foundation

@Model
class JournalEntry {
    var title: String
    var content: String
    var date: Date
    
    

    init(title: String, content: String, date: Date) {
        self.title = title
        self.content = content
        self.date = date
    }
}
