import SwiftUI

struct ContentView: View {
    @StateObject private var quizData = QuizData()
    @State private var showWelcome = true
    @State private var showResults = false
    
    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView(showWelcome: $showWelcome)
                    .transition(.opacity)
            } else if showResults {
                ResultsView(quizData: quizData, showWelcome: $showWelcome)
                    .transition(.opacity)
                    .onAppear {
                        showResults = false
                    }
            } else {
                QuizView(quizData: quizData, showResults: $showResults)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showWelcome)
        .animation(.easeInOut(duration: 0.3), value: showResults)
        .onChange(of: showWelcome) { oldValue, newValue in
            if newValue {
                showResults = false
            }
        }
        .onChange(of: showResults) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showResults = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
