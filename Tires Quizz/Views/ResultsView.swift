import SwiftUI

struct ResultsView: View {
    @ObservedObject var quizData: QuizData
    @Binding var showWelcome: Bool
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @State private var animateScore = false
    @State private var animateDetails = false
    @State private var showConfetti = false
    @State private var showReview = false
    
    var scorePercentage: Double {
        Double(quizData.score) / Double(quizData.questions.count) * 100
    }
    
    var performanceLevel: (title: String, color: Color, emoji: String, message: String) {
        switch scorePercentage {
        case 90...100:
            return ("Expert!", .green, "🏆", "You're a tire expert! Outstanding knowledge!")
        case 75..<90:
            return ("Great Job!", .blue, "⭐️", "Excellent performance! You know your tires well!")
        case 60..<75:
            return ("Good Work!", .orange, "👍", "Good job! Keep learning more about tire safety!")
        default:
            return ("Keep Learning!", .red, "📚", "Don't give up! Review the material and try again!")
        }
    }
    
    var body: some View {
        ZStack {
            if themeManager.currentTheme == .dark || (themeManager.currentTheme == .system && colorScheme == .dark) {
                LinearGradient(
                    gradient: Gradient(colors: [Color.darkThemeBackground, Color.darkThemeSecondary]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [performanceLevel.color.opacity(0.2), performanceLevel.color.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            ScrollView {
                VStack(spacing: 30) {
                    Text(performanceLevel.emoji)
                        .font(.system(size: 80))
                        .scaleEffect(animateScore ? 1.0 : 0.3)
                        .animation(.spring(response: 0.6, dampingFraction: 0.5), value: animateScore)
                    
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: animateScore ? scorePercentage / 100 : 0)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [performanceLevel.color, performanceLevel.color.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1.0), value: animateScore)
                        
                        VStack(spacing: 5) {
                            Text("\(quizData.score)")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(performanceLevel.color)
                            Text("out of \(quizData.questions.count)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical)
                    
                    VStack(spacing: 10) {
                        Text(performanceLevel.title)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(performanceLevel.color)
                            .minimumScaleFactor(0.7)
                            .lineLimit(2)
                        
                        Text(performanceLevel.message)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.8)
                            .lineLimit(3)
                            .padding(.horizontal, 40)
                    }
                    .opacity(animateDetails ? 1 : 0)
                    .offset(y: animateDetails ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: animateDetails)
                    
                    Text("\(Int(scorePercentage))%")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(performanceLevel.color)
                        .opacity(animateDetails ? 1 : 0)
                        .animation(.easeOut(duration: 0.6).delay(0.7), value: animateDetails)
                    
                    VStack(spacing: 20) {
                        StatRow(icon: "checkmark.circle.fill", label: "Correct Answers", value: "\(quizData.score)", color: .green)
                        StatRow(icon: "xmark.circle.fill", label: "Incorrect Answers", value: "\(quizData.questions.count - quizData.score)", color: .red)
                        StatRow(icon: "chart.bar.fill", label: "Accuracy", value: "\(Int(scorePercentage))%", color: .blue)
                        StatRow(icon: "list.bullet", label: "Total Questions", value: "\(quizData.questions.count)", color: .purple)
                    }
                    .padding()
                    .background(themeManager.cardBackground(colorScheme))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                    .padding(.horizontal)
                    .opacity(animateDetails ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.9), value: animateDetails)
                    
                    CategoryBreakdownView(quizData: quizData)
                        .padding(.horizontal)
                        .opacity(animateDetails ? 1 : 0)
                        .animation(.easeOut(duration: 0.6).delay(1.1), value: animateDetails)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            showReview = true
                        }) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                Text("Review All Answers")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            withAnimation {
                                quizData.reset()
                                showWelcome = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Retake Quiz")
                            }
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.cardBackground(colorScheme))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                        }
                        
                        Button(action: {
                            shareResults()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Results")
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.cardBackground(colorScheme))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .opacity(animateDetails ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(1.3), value: animateDetails)
                }
                .padding(.top, 30)
            }
        }
        .onAppear {
            animateScore = true
            animateDetails = true
        }
        .sheet(isPresented: $showReview) {
            ReviewAnswersView(quizData: quizData)
        }
    }
    
    func shareResults() {
        let text = "I scored \(quizData.score)/\(quizData.questions.count) (\(Int(scorePercentage))%) on the Tire Knowledge Quiz! 🚗"
        let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityController, animated: true)
        }
    }
}

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 30)
            
            Text(label)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct CategoryBreakdownView: View {
    @ObservedObject var quizData: QuizData
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
    
    var categoryScores: [(category: QuizCategory, correct: Int, total: Int)] {
        var scores: [QuizCategory: (correct: Int, total: Int)] = [:]
        
        for (index, question) in quizData.questions.enumerated() {
            let isCorrect = quizData.userAnswers[index] == question.correctAnswer
            let current = scores[question.category] ?? (0, 0)
            scores[question.category] = (current.correct + (isCorrect ? 1 : 0), current.total + 1)
        }
        
        return scores.map { ($0.key, $0.value.correct, $0.value.total) }.sorted { $0.category.rawValue < $1.category.rawValue }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Performance by Category")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(categoryScores, id: \.category) { item in
                CategoryRow(
                    category: item.category.rawValue,
                    correct: item.correct,
                    total: item.total
                )
            }
        }
        .padding()
        .background(themeManager.cardBackground(colorScheme))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10)
    }
}

struct CategoryRow: View {
    let category: String
    let correct: Int
    let total: Int
    
    var percentage: Double {
        total > 0 ? Double(correct) / Double(total) : 0
    }
    
    var color: Color {
        switch percentage {
        case 0.8...1.0: return .green
        case 0.6..<0.8: return .blue
        case 0.4..<0.6: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(correct)/\(total)")
                    .font(.subheadline)
                    .foregroundColor(color)
                    .fontWeight(.semibold)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    ResultsView(quizData: QuizData(), showWelcome: .constant(false))
        .environmentObject(ThemeManager())
}

