import SwiftUI

struct QuizView: View {
    @ObservedObject var quizData: QuizData
    @State private var selectedAnswer: Int? = nil
    @State private var showExplanation = false
    @State private var animateQuestion = false
    @State private var showMenu = false
    @Binding var showResults: Bool
    
    var currentQuestion: Question {
        quizData.questions[quizData.currentQuestionIndex]
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(spacing: 15) {
                    HStack {
                        Text("Question \(quizData.currentQuestionIndex + 1) of \(quizData.questions.count)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        Button(action: {
                            showMenu = true
                        }) {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        
                        Text(currentQuestion.category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    ProgressBar(progress: Double(quizData.currentQuestionIndex + 1) / Double(quizData.questions.count))
                }
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(currentQuestion.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                                .minimumScaleFactor(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(25)
                        .background(Color.theme.cardBackground)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        .opacity(animateQuestion ? 1 : 0)
                        .offset(y: animateQuestion ? 0 : 20)
                        
                        VStack(spacing: 15) {
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
                                .animation(.easeOut(duration: 0.3).delay(Double(index) * 0.1), value: animateQuestion)
                            }
                        }
                        .padding(.horizontal)
                        
                        if showExplanation {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Image(systemName: selectedAnswer == currentQuestion.correctAnswer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                                        .font(.title2)
                                    Text(selectedAnswer == currentQuestion.correctAnswer ? "Correct!" : "Incorrect")
                                        .font(.headline)
                                        .foregroundColor(selectedAnswer == currentQuestion.correctAnswer ? .green : .red)
                                }
                                
                        Text(currentQuestion.explanation)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .minimumScaleFactor(0.9)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            .background(
                                (selectedAnswer == currentQuestion.correctAnswer ? Color.green : Color.red)
                                    .opacity(0.15)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke((selectedAnswer == currentQuestion.correctAnswer ? Color.green : Color.red).opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(15)
                            .padding(.horizontal)
                            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                                   removal: .opacity))
                        }
                    }
                    .padding(.vertical)
                }
                
                HStack(spacing: 15) {
                    if quizData.currentQuestionIndex > 0 {
                        Button(action: {
                            previousQuestion()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Previous")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                        }
                    }
                    
                    if showExplanation {
                        Button(action: {
                            nextQuestion()
                        }) {
                            HStack {
                                Text(quizData.currentQuestionIndex < quizData.questions.count - 1 ? "Next" : "Finish")
                                Image(systemName: quizData.currentQuestionIndex < quizData.questions.count - 1 ? "chevron.right" : "checkmark")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
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
            return Color.gray.opacity(0.3)
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(letters[index])
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected || isCorrect ? .white : .blue)
                    .frame(width: 35, height: 35)
                    .background(
                        Circle()
                            .fill(isCorrect ? Color.green : (isWrong ? Color.red : (isSelected ? Color.blue : Color.blue.opacity(0.1))))
                    )
                
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .minimumScaleFactor(0.85)
                
                Spacer()
                
                if isCorrect || isWrong {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                        .font(.title3)
                }
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor, lineWidth: 2)
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
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 8)
                    .cornerRadius(4)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    QuizView(quizData: QuizData(), showResults: .constant(false))
}

