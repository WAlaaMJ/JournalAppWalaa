//
//  JournalAppApp.swift
//  JournalApp
//
//

import SwiftUI

@main
struct JournalAppApp: App {
    
    // Register the model container for JournalEntry
    var body: some Scene {
        WindowGroup {
            SplashScreen() // This is your main view
                .modelContainer(for: [JournalEntry.self]) // Register the model container for the JournalEntry class
        }
    }
}
