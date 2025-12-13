import SwiftUI

struct QuizView: View {
    @ObservedObject var quizData: QuizData
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var animateQuestion = false
    @State private var showMenu = false
    @Binding var showResults: Bool
    
    var currentQuestion: Question {
        quizData.questions[quizData.currentQuestionIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 15) {
                    // Header
                    VStack(spacing: 12) {
                        HStack {
                            ProgressBar(progress: Double(quizData.currentQuestionIndex + 1) / Double(quizData.questions.count))
                            
                            Text(currentQuestion.category.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Question Card
                            VStack(alignment: .leading, spacing: 15) {
                                Text(currentQuestion.text)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                            .opacity(animateQuestion ? 1 : 0)
                            .offset(y: animateQuestion ? 0 : 20)
                            
                            // Answer Options
                            VStack(spacing: 12) {
                                ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                                    AnswerButton(
                                        text: currentQuestion.options[index],
                                        isSelected: selectedAnswer == index,
                                        isCorrect: showExplanation && index == currentQuestion.correctAnswer,
                                        isWrong: showExplanation && selectedAnswer == index && index != currentQuestion.correctAnswer,
                                        index: index
                                    ) {
                                        selectAnswer(index)
                                    }
                                    .opacity(animateQuestion ? 1 : 0)
                                    .offset(y: animateQuestion ? 0 : 20)
                                    .animation(.easeOut(duration: 0.3).delay(Double(index) * 0.08), value: animateQuestion)
                                }
                            }
                            
                            // Explanation
                            if showExplanation {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: selectedAnswer == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                                            .font(.title3)
                                        Text(selectedAnswer == currentQuestion.correctAnswer ? "Correct!" : "Incorrect")
                                            .font(.headline)
                                            .foregroundColor(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                                    }
                                    
                                    Text(currentQuestion.explanation)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(
                                    (selectedAnswer == currentQuestion.correctAnswer ? Color.green : Color.red)
                                        .opacity(0.1)
                                )
                                .cornerRadius(12)
                                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                                       removal: .opacity))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }
                    
                    // Navigation Buttons
                    HStack(spacing: 12) {
                        if quizData.currentQuestionIndex > 0 {
                            Button(action: {
                                previousQuestion()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.left")
                                    Text("Previous")
                                }
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.gray.opacity(0.15))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                            }
                        }
                        
                        if showExplanation {
                            Button(action: {
                                nextQuestion()
                            }) {
                                HStack(spacing: 6) {
                                    Text(quizData.currentQuestionIndex < quizData.questions.count - 1 ? "Next" : "Finish")
                                    Image(systemName: quizData.currentQuestionIndex < quizData.questions.count - 1 ? "chevron.right" : "checkmark")
                                }
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
            .navigationTitle("Question \(quizData.currentQuestionIndex + 1) of \(quizData.questions.count)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showMenu = true
                    }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            loadQuestion()
        }
        .sheet(isPresented: $showMenu) {
            QuizMenuView(showMenu: $showMenu, quizData: quizData)
                .presentationDetents([.medium, .large])
        }
    }
    
    func loadQuestion() {
        animateQuestion = false
        selectedAnswer = quizData.userAnswers[quizData.currentQuestionIndex]
        showExplanation = selectedAnswer != nil
        
        withAnimation(.easeOut(duration: 0.4)) {
            animateQuestion = true
        }
    }
    
    func selectAnswer(_ index: Int) {
        guard selectedAnswer == nil else { return }
        
        selectedAnswer = index
        quizData.selectAnswer(index)
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showExplanation = true
        }
    }
    
    func nextQuestion() {
        if quizData.currentQuestionIndex < quizData.questions.count - 1 {
            quizData.nextQuestion()
            loadQuestion()
        } else {
            showResults = true
        }
    }
    
    func previousQuestion() {
        quizData.previousQuestion()
        loadQuestion()
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let index: Int
    let action: () -> Void
    
    let letters = ["A", "B", "C", "D"]
    
    var backgroundColor: Color {
        if isCorrect {
            return Color.green.opacity(0.15)
        } else if isWrong {
            return Color.red.opacity(0.15)
        } else if isSelected {
            return Color.blue.opacity(0.15)
        } else {
            return Color.theme.cardBackground
        }
    }
    
    var borderColor: Color {
        if isCorrect {
            return Color.green
        } else if isWrong {
            return Color.red
        } else if isSelected {
            return Color.blue
        } else {
            return Color.gray.opacity(0.2)
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(letters[index])
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected || isCorrect ? .white : .blue)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isCorrect ? Color.green : (isWrong ? Color.red : (isSelected ? Color.blue : Color.blue.opacity(0.1))))
                    )
                
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if isCorrect || isWrong {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title3)
                }
            }
            .padding(14)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isCorrect || isWrong)
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 6)
                    .cornerRadius(3)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 6)
                    .cornerRadius(3)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 6)
    }
}

#Preview {
    QuizView(quizData: QuizData(), showResults: .constant(false))
        .environmentObject(ThemeManager())
}
