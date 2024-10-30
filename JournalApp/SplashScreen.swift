//
//  SplashScreen.swift
//  JournalApp
//

//
import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    var body: some View {
        Group {
            if isActive {
                MainPage()
            } else {
                ZStack {
                    Color.black // Set your desired background color here
                        .ignoresSafeArea() // This makes the color fill the entire screen
                    VStack {
                        Image(.journali)
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Text("Journali")
                            .font(.system(size: 42,weight: .black))
                            .foregroundColor(Color.white)
                            .padding(.vertical,5)
                        Text("Your thoughts, your story")
                            .font(.system(size: 18,weight: .light))
                            .foregroundColor(Color.white)
                    }
                }
                .onAppear {
                    // Transition to JournalView after 5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
