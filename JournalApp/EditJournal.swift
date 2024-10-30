//
//  EditJournal.swift
//  JournalApp

import SwiftUI
import SwiftData

// ViewModel
class EditJournalViewModel: ObservableObject {
    @Published var journalEntry: JournalEntry
    @Published var journalTitle: String
    @Published var journalContent: String
    
    init(journalEntry: JournalEntry) {
        self.journalEntry = journalEntry
        self.journalTitle = journalEntry.title
        self.journalContent = journalEntry.content
    }
    
    // Method to save changes
    func save() {
        journalEntry.title = journalTitle
        journalEntry.content = journalContent
    }
    
    // Format the date for display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: journalEntry.date)
    }
}

// View
struct EditJournal: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext

    @ObservedObject var viewModel: EditJournalViewModel

    init(journalEntry: Binding<JournalEntry>) {
        self.viewModel = EditJournalViewModel(journalEntry: journalEntry.wrappedValue)
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    if viewModel.journalTitle.isEmpty {
                        Text("Title")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(hex: "#3E3E3E"))
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    TextField("", text: $viewModel.journalTitle)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 10)
                }

                // Display the date
                Text(viewModel.formattedDate)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(hex: "#A39A9A"))
                    .padding(.horizontal, 20)

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.journalContent)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .regular))
                        .padding(.horizontal)
                        .background(Color.black)
                        .cornerRadius(8)
                        .padding(.top, 10)
                        .frame(maxHeight: .infinity)
                        .scrollContentBackground(.hidden)
                    if viewModel.journalContent.isEmpty {
                        Text("Type your Journal...")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(Color(hex: "#4F4F4F"))
                            .padding(.horizontal)
                            .padding(.vertical, 20)
                    }
                }

                Spacer()
            }
            .background(Color.black)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(Color(hex: "#A499FF"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(Color(hex: "#A499FF"))
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}
