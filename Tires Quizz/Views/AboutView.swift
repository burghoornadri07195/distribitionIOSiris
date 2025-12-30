import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Image(systemName: "car.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                            .scaleEffect(animateContent ? 1.0 : 0.8)
                            .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateContent)
                        
                        VStack(spacing: 15) {
                            Text("Tire Knowledge Quiz")
                                .font(.system(size: 32, weight: .bold))
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.6)
                                .lineLimit(2)
                                .padding(.horizontal, 20)
                            
                            Text("Version 1.0")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: animateContent)
                        
                        VStack(spacing: 20) {
                            InfoCard(
                                icon: "questionmark.circle.fill",
                                title: "What is This Quiz?",
                                description: "An interactive educational quiz designed to test and improve your knowledge about tire maintenance, safety, and technical specifications. Perfect for drivers, automotive enthusiasts, and anyone interested in vehicle safety.",
                                color: .blue
                            )
                            
                            InfoCard(
                                icon: "target",
                                title: "Quiz Features",
                                description: "• 50 comprehensive questions\n• 5 different categories\n• Instant feedback with explanations\n• Progress tracking\n• Performance analysis\n• Review all answers\n• Safety tips and resources",
                                color: .green
                            )
                            
                            InfoCard(
                                icon: "book.fill",
                                title: "Categories Covered",
                                description: "• Tire Basics - Understanding tire specifications\n• Maintenance - Proper care and upkeep\n• Safety - Emergency procedures and prevention\n• Technical - Advanced specifications\n• Seasonal - Weather and climate considerations",
                                color: .orange
                            )
                            
                            InfoCard(
                                icon: "star.fill",
                                title: "Why Take This Quiz?",
                                description: "Proper tire knowledge can save lives, reduce costs, and improve vehicle performance. Understanding tire maintenance helps you make informed decisions about your vehicle's safety and efficiency.",
                                color: .purple
                            )
                            
                            InfoCard(
                                icon: "lightbulb.fill",
                                title: "Learning Outcomes",
                                description: "After completing this quiz, you'll understand tire sizing, know when to replace tires, recognize safety risks, interpret technical ratings, and apply seasonal considerations for optimal tire performance.",
                                color: .yellow
                            )
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "wrench.and.screwdriver.fill")
                                        .foregroundColor(.blue)
                                    Text("Built with SwiftUI")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                                HStack {
                                    Image(systemName: "checkmark.shield.fill")
                                        .foregroundColor(.green)
                                    Text("Educational Content Verified")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                    Text("Made for Safety Awareness")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color.theme.cardBackground)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        .padding(.horizontal)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.4), value: animateContent)
                        
                        VStack(spacing: 8) {
                            Text("Stay Safe on the Road!")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Regular tire maintenance is essential for vehicle safety")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 20)
                        .opacity(animateContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.6), value: animateContent)
                    }
                    .padding(.vertical, 30)
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
        .onAppear {
            animateContent = true
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                
                Spacer()
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.9)
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

#Preview {
    AboutView()
        .environmentObject(ThemeManager())
}
