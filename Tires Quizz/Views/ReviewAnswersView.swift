import SwiftUI

struct ReviewAnswersView: View {
    @ObservedObject var quizData: QuizData
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedQuestionIndex: Int? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.05), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            Text("Review Your Answers")
                                .font(.title2)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                            
                            HStack(spacing: 30) {
                                StatBadge(value: "\(quizData.score)", label: "Correct", color: .green)
                                StatBadge(value: "\(quizData.questions.count - quizData.score)", label: "Wrong", color: .red)
                                StatBadge(value: "\(Int(Double(quizData.score) / Double(quizData.questions.count) * 100))%", label: "Score", color: .blue)
                            }
                        }
                        .padding()
                        .background(Color.theme.cardBackground)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        ForEach(Array(quizData.questions.enumerated()), id: \.offset) { index, question in
                            ReviewQuestionCard(
                                questionNumber: index + 1,
                                question: question,
                                userAnswer: quizData.userAnswers[index],
                                isExpanded: selectedQuestionIndex == index
                            ) {
                                withAnimation {
                                    if selectedQuestionIndex == index {
                                        selectedQuestionIndex = nil
                                    } else {
                                        selectedQuestionIndex = index
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct StatBadge: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ReviewQuestionCard: View {
    let questionNumber: Int
    let question: Question
    let userAnswer: Int?
    let isExpanded: Bool
    let action: () -> Void
    
    var isCorrect: Bool {
        userAnswer == question.correctAnswer
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: action) {
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Text("\(questionNumber)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(question.category.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(question.text)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(isExpanded ? nil : 2)
                            .minimumScaleFactor(0.9)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.headline)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 15) {
                    Divider()
                    
                    ForEach(0..<question.options.count, id: \.self) { index in
                        HStack(spacing: 12) {
                            Image(systemName: getIcon(for: index))
                                .foregroundColor(getColor(for: index))
                                .font(.title3)
                            
                            Text(question.options[index])
                                .font(.body)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(getBackgroundColor(for: index))
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.orange)
                            Text("Explanation")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Text(question.explanation)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.theme.cardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    func getIcon(for index: Int) -> String {
        if index == question.correctAnswer {
            return "checkmark.circle.fill"
        } else if index == userAnswer {
            return "xmark.circle.fill"
        } else {
            return "circle"
        }
    }
    
    func getColor(for index: Int) -> Color {
        if index == question.correctAnswer {
            return .green
        } else if index == userAnswer {
            return .red
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    func getBackgroundColor(for index: Int) -> Color {
        if index == question.correctAnswer {
            return Color.green.opacity(0.1)
        } else if index == userAnswer {
            return Color.red.opacity(0.1)
        } else {
            return Color.clear
        }
    }
}

#Preview {
    ReviewAnswersView(quizData: QuizData())
        .environmentObject(ThemeManager())
}
