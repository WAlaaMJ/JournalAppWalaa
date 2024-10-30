//
//  MainPage.swift
//  JournalApp
//
import SwiftUI
import SwiftData

class MainPageViewModel: ObservableObject {
    @Published  var searchText = ""
    @Published  var isPresentingNewJournal = false
    // State variable for the dropdown menu
    @Published  var isMenuOpen = false
    @Published var showOnlyBookmarked = false // New property

    
    
}

struct MainPage: View {
    @StateObject /*private*/ var viewModel = MainPageViewModel()
//    @State private var searchText = ""
//    @State private var isPresentingNewJournal = false
//    // State variable for the dropdown menu
//    @State private var isMenuOpen = false
    @Query var journalEntries: [JournalEntry] = []
    @Environment(\.modelContext) private var modelContext // Access the model context
    @State private var entryToEdit: JournalEntry? // Track the entry to edit
    
    var filteredEntries: [JournalEntry] {
        if viewModel.searchText.isEmpty {
            return journalEntries
        } else {
            return journalEntries.filter { entry in
                entry.title.localizedCaseInsensitiveContains(viewModel.searchText) ||
                entry.content.localizedCaseInsensitiveContains(viewModel.searchText)
            }
        }
    }

    var body: some View {
        
        if journalEntries.isEmpty {
            // Show EmptyState if there are no journal entries
            EmptyState()
        } else {
            NavigationView {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer().frame(height: 60)
                        
                        // Custom Search Bar
                        ZStack(alignment: .leading) {
                            if viewModel.searchText.isEmpty {
                                Text("Search")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(Color(hex: "#EBEBF5")?.opacity(0.6))
                                    .padding(.leading, 45)
                            }
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.gray)
                                .padding(.leading, 20)
                            
                            TextField("", text: $viewModel.searchText)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color(hex: "#FFFFFF"))
                                .padding(.leading, 30)
                                .padding(.vertical, 10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 12)
                        Spacer()
                        
                        // Using List for Swipe Actions
                        List {
                            ForEach(filteredEntries) { entry in
                                JournalEntryView(journalEntry: entry)
                                    .frame(maxWidth: .infinity) // Full width for JournalEntryView
                                    .listRowBackground(Color.black) // Set the row background to black
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button(action: {
                                            // Set the entry to edit and present the edit view
                                            entryToEdit = entry
                                        }) {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 20, weight: .regular))
                                                .foregroundColor(.white) // Change text color to white
                                        }
                                        .tint(Color(hex: "#7F81FF")) // Set the background color for the button
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(action: {
                                            // Action for right swipe (delete)
                                            modelContext.delete(entry) // Delete from model context
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 20, weight: .regular))
                                                .foregroundColor(.white) // Change text color to white
                                        }
                                        .tint(Color(hex: "#FF453A")) // Set the background color for the button
                                    }
                            }
                        }
                        .listStyle(.plain) // To remove default list styles
                        .scrollContentBackground(.hidden) // Hide the default list background
                        .sheet(item: $entryToEdit) { entry in
                            EditJournal(journalEntry: Binding<JournalEntry>(get: { entry }, set: { entryToEdit = $0 }))
                        }
                        
                        Spacer()
                    }
                }
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Journal")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundColor(Color.white)
                            .padding(.top, 80)
                    }
                    // First button on the right (Filter)
                    // Dropdown Menu Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                viewModel.isMenuOpen.toggle()
                                print("Menu toggled: \(viewModel.isMenuOpen)")
                            }
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(Color(hex: "#D4C8FF"))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: "#1F1F22"))
                                .clipShape(Circle())
                        }
                    }
                    
                    // New Journal Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.isPresentingNewJournal = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .regular))
                                .foregroundColor(Color(hex: "#D4C8FF"))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: "#1F1F22"))
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $viewModel.isPresentingNewJournal) {
                            NewJournal()
                        }
                    }
                }
                .overlay(
                    Group {
                        if viewModel.isMenuOpen {
                            VStack(spacing: 0) {
                                Button(action: {
                                    print("Bookmark selected")
                                    viewModel.isMenuOpen = false
                                }) {
                                    Text("Bookmark")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .frame(maxWidth: .infinity) // Full width for easy tapping
                                }
                                
                                Divider()
                                    .background(Color(hex: "#2F2F2F")) // Set the color of the divider
                                
                                Button(action: {
                                    print("Journal Date selected")
                                    viewModel.isMenuOpen = false
                                }) {
                                    Text("Journal Date")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .frame(maxWidth: .infinity) // Full width for easy tapping
                                }
                            }
                            .padding(.top, 5)
                            .background(Color(hex: "#202022")) // Background for the menu
                            .cornerRadius(8)
                            .shadow(radius: 5) // Optional shadow
                            .frame(width: 150) // Optional: set a width for the menu
                            .offset(y: -300) // Adjust this value to control the vertical position
                            .zIndex(1) // Ensure the dropdown appears above other views
                            .padding(.trailing, -50) // Optional: align the menu with the button
                        }
                    }
                )

            }
        }
    }
}

#Preview {
    MainPage()
}
