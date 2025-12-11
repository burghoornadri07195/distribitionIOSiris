import SwiftUI

struct QuizMenuView: View {
    @Binding var showMenu: Bool
    @ObservedObject var quizData: QuizData
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showTips = false
    @State private var showReview = false
    @State private var showAbout = false
    @State private var animateButtons = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMenu = false
                    }
                }
            
            VStack(spacing: 0) {
                HStack {
                    Text("Quiz Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showMenu = false
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.theme.cardBackground)
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 15) {
                        ProgressSummaryCard(quizData: quizData)
                            .padding(.horizontal)
                            .padding(.top)
                            .opacity(animateButtons ? 1 : 0)
                            .offset(y: animateButtons ? 0 : 20)
                            .animation(.easeOut(duration: 0.4), value: animateButtons)
                        
                        ThemeToggleButton(themeManager: themeManager)
                            .padding(.horizontal)
                            .opacity(animateButtons ? 1 : 0)
                            .offset(y: animateButtons ? 0 : 20)
                            .animation(.easeOut(duration: 0.4).delay(0.05), value: animateButtons)
                        
                        MenuButton(
                            icon: "lightbulb.fill",
                            title: "Tire Safety Tips",
                            description: "Learn essential tire maintenance tips",
                            color: .orange
                        ) {
                            showTips = true
                        }
                        .opacity(animateButtons ? 1 : 0)
                        .offset(y: animateButtons ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.15), value: animateButtons)
                        
                        MenuButton(
                            icon: "doc.text.fill",
                            title: "Review Answers",
                            description: "See all questions and explanations",
                            color: .blue
                        ) {
                            showReview = true
                        }
                        .opacity(animateButtons ? 1 : 0)
                        .offset(y: animateButtons ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.25), value: animateButtons)
                        
                        MenuButton(
                            icon: "arrow.clockwise.circle.fill",
                            title: "Restart Quiz",
                            description: "Start over with new questions",
                            color: .purple
                        ) {
                            quizData.reset()
                            showMenu = false
                        }
                        .opacity(animateButtons ? 1 : 0)
                        .offset(y: animateButtons ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.35), value: animateButtons)
                        
                        MenuButton(
                            icon: "info.circle.fill",
                            title: "About This Quiz",
                            description: "Learn about tire knowledge quiz",
                            color: .green
                        ) {
                            showAbout = true
                        }
                        .opacity(animateButtons ? 1 : 0)
                        .offset(y: animateButtons ? 0 : 20)
                        .animation(.easeOut(duration: 0.4).delay(0.45), value: animateButtons)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .background(Color(uiColor: .systemGroupedBackground))
            }
            .frame(maxWidth: 500)
            .background(Color.theme.background)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
            .transition(.move(edge: .bottom))
        }
        .sheet(isPresented: $showTips) {
            TipsView()
        }
        .sheet(isPresented: $showReview) {
            ReviewAnswersView(quizData: quizData)
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .onAppear {
            animateButtons = true
        }
    }
}

struct ProgressSummaryCard: View {
    @ObservedObject var quizData: QuizData
    
    var answeredCount: Int {
        quizData.userAnswers.filter { $0 != nil }.count
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Your Progress")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack(spacing: 20) {
                ProgressStatItem(
                    value: "\(quizData.currentQuestionIndex + 1)/\(quizData.questions.count)",
                    label: "Current",
                    color: .blue
                )
                
                ProgressStatItem(
                    value: "\(answeredCount)",
                    label: "Answered",
                    color: .green
                )
                
                ProgressStatItem(
                    value: "\(quizData.score)",
                    label: "Correct",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color.theme.secondaryBackground)
        .cornerRadius(15)
    }
}

struct ProgressStatItem: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MenuButton: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .minimumScaleFactor(0.85)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ThemeToggleButton: View {
    @ObservedObject var themeManager: ThemeManager
    @State private var isAnimating = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isAnimating = true
                themeManager.toggleTheme()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
        }) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(themeManager.isDarkMode ? Color.yellow.opacity(0.2) : Color.blue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.title2)
                        .foregroundColor(themeManager.isDarkMode ? .yellow : .blue)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(themeManager.isDarkMode ? "Light Mode" : "Dark Mode")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    Text(themeManager.isDarkMode ? "Switch to light theme" : "Switch to dark theme")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .minimumScaleFactor(0.85)
                        .lineLimit(2)
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(themeManager.isDarkMode ? Color.yellow.opacity(0.2) : Color.blue.opacity(0.2))
                        .frame(width: 50, height: 30)
                    
                    Circle()
                        .fill(themeManager.isDarkMode ? Color.yellow : Color.blue)
                        .frame(width: 24, height: 24)
                        .offset(x: themeManager.isDarkMode ? 10 : -10)
                }
            }
            .padding()
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    QuizMenuView(showMenu: .constant(true), quizData: QuizData())
        .environmentObject(ThemeManager())
}

