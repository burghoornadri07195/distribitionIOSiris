import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @State private var animateTitle = false
    @State private var animateSubtitle = false
    @State private var animateButton = false
    
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
                    gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "car.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .scaleEffect(animateTitle ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateTitle)
                
                Text("Tire Knowledge Quiz")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 20)
                    .opacity(animateTitle ? 1 : 0)
                    .offset(y: animateTitle ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: animateTitle)
                
                VStack(spacing: 15) {
                    Text("Test Your Knowledge")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    
                    Text("50 exciting questions about tires, safety, maintenance, and more!")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 40)
                }
                .opacity(animateSubtitle ? 1 : 0)
                .offset(y: animateSubtitle ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: animateSubtitle)
                
                Spacer()
                
                VStack(spacing: 15) {
                    FeatureRow(icon: "checkmark.circle.fill", text: "50 Challenging Questions")
                    FeatureRow(icon: "chart.bar.fill", text: "Track Your Progress")
                    FeatureRow(icon: "lightbulb.fill", text: "Detailed Explanations")
                    FeatureRow(icon: "star.fill", text: "Score & Performance")
                }
                .opacity(animateSubtitle ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: animateSubtitle)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showWelcome = false
                    }
                }) {
                    HStack {
                        Text("Start Quiz")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.8)
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title2)
                    }
                    .foregroundColor(themeManager.currentTheme == .dark || (themeManager.currentTheme == .system && colorScheme == .dark) ? .white : .blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.currentTheme == .dark || (themeManager.currentTheme == .system && colorScheme == .dark) ? Color.darkThemeAccent : Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
                .padding(.horizontal, 40)
                .padding(.horizontal, 20)
                .scaleEffect(animateButton ? 1.0 : 0.8)
                .opacity(animateButton ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.8), value: animateButton)
                
                Spacer()
            }
        }
        .onAppear {
            animateTitle = true
            animateSubtitle = true
            animateButton = true
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .font(.title3)
            Text(text)
                .foregroundColor(.white)
                .font(.body)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    WelcomeView(showWelcome: .constant(true))
        .environmentObject(ThemeManager())
}

