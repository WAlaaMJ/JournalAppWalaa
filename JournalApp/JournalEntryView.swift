//
//  JournalEntryView.swift
//  JournalApp
//
import SwiftUI
import Combine

// ViewModel
class JournalEntryViewModel: ObservableObject {
    @Published var isBookmarked: Bool
    var journalEntry: JournalEntry

    init(journalEntry: JournalEntry) {
        self.journalEntry = journalEntry
        self.isBookmarked = BookmarkManager.loadBookmarkState(entryId: journalEntry.title)
    }
    
    func toggleBookmark() {
        isBookmarked.toggle()
        BookmarkManager.saveBookmarkState(entryId: journalEntry.title, isBookmarked: isBookmarked)
    }
}

// View
struct JournalEntryView: View {
    @StateObject /*private*/ var viewModel: JournalEntryViewModel

    init(journalEntry: JournalEntry) {
        _viewModel = StateObject(wrappedValue: JournalEntryViewModel(journalEntry: journalEntry))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Journal Entry Title
                Text(viewModel.journalEntry.title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(Color(hex: "#D4C8FF"))
                
                Spacer() // Pushes bookmark to the right
                
                // Bookmark Icon (tap to toggle)
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(Color(hex: "#D4C8FF"))
                    .font(.system(size: 24, weight: .regular))
                    .onTapGesture {
                        viewModel.toggleBookmark() // Use ViewModel to toggle bookmark
                    }
            }

            // Journal Entry Date
            Text(viewModel.journalEntry.date.formatted(date: .numeric, time: .omitted))
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "#9F9F9F"))
            
            // Journal Entry Content Preview
            Text(viewModel.journalEntry.content)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color(hex: "#FFFFFF"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(hex: "#171719"))
        .cornerRadius(10)
    }
}
//#Preview {
//    JournalEntryView()
//}
