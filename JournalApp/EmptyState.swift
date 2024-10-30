//
//  EmptyState.swift
//  JournalApp
//

import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

// ViewModel
class EmptyStateViewModel: ObservableObject {
    @Published var isPresentingNewJournal = false
    
    func addNewJournal() {
        isPresentingNewJournal = true
    }
}

// View
struct EmptyState: View {
    @StateObject /*private*/ var viewModel = EmptyStateViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black // Set your desired background color here
                    .ignoresSafeArea() // This makes the color fill the entire screen
                
                VStack {
                    Spacer()
                    
                    Image(.journali)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Begin Your Journal")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#D4C8FF"))
                        .padding(.vertical, 5)
                    Text("Craft your personal diary, tap the plus icon to begin")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                
            }
            .navigationTitle("") // Set to empty to use custom title
            .toolbar {
                // Custom title aligned to the leading side
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Journal")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color.white) // Title color
                        .padding(.top, 80)
                }
                
                // First button on the right (Filter)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for filtering journal entries
                        print("Filter button tapped")
                    }) {
                        Image(systemName: "line.3.horizontal.decrease") // SF Symbol for filter
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color(hex: "#D4C8FF"))
                            .frame(width: 40, height: 40) // Set the size of the circle
                            .background(Color(hex: "#1F1F22")) // Gray background
                            .clipShape(Circle()) // Make it circular
                    }
                }
                
                // Second button on the right (Add)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addNewJournal()
                    }) {
                        Image(systemName: "plus") // SF Symbol for plus
                            .font(.system(size: 22, weight: .regular))
                            .foregroundColor(Color(hex: "#D4C8FF"))
                            .frame(width: 40, height: 40) // Set the size of the circle
                            .background(Color(hex: "#1F1F22")) // Gray background
                            .clipShape(Circle()) // Make it circular
                    }
                    .sheet(isPresented: $viewModel.isPresentingNewJournal) {
                        NewJournal()
                    }
                }
            }
        }
    }
}

#Preview {
    EmptyState()
}
