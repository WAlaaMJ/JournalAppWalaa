//
//  NewJournal.swift
//  JournalApp
import SwiftUI
import SwiftData

// ViewModel
class NewJournalViewModel: ObservableObject {
    @Published var journalTitle = ""
    @Published var journalContent = ""
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: Date())
    }
}

// View
struct NewJournal: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = NewJournalViewModel()
    
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
                
                Text(viewModel.currentDate)
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
                        let newEntry = JournalEntry(title: viewModel.journalTitle, content: viewModel.journalContent, date: Date())
                        modelContext.insert(newEntry)

                        // Reset the input fields
                        viewModel.journalTitle = ""
                        viewModel.journalContent = ""

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
