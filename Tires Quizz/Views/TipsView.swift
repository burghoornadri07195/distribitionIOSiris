import SwiftUI

struct TipsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var animateCards = false
    
    let tips = [
        TipItem(
            icon: "gauge.with.dots.needle.bottom.50percent",
            title: "Check Tire Pressure Monthly",
            description: "Proper tire pressure improves fuel economy, extends tire life, and ensures optimal handling. Check when tires are cold.",
            category: .maintenance,
            color: .blue
        ),
        TipItem(
            icon: "arrow.triangle.2.circlepath",
            title: "Rotate Tires Regularly",
            description: "Rotate your tires every 5,000-7,500 miles to ensure even wear and maximize tire life.",
            category: .maintenance,
            color: .green
        ),
        TipItem(
            icon: "ruler",
            title: "Check Tread Depth",
            description: "Use the penny test: insert a penny with Lincoln's head upside down. If you can see his entire head, it's time for new tires.",
            category: .safety,
            color: .orange
        ),
        TipItem(
            icon: "snowflake",
            title: "Switch to Winter Tires",
            description: "When temperatures consistently drop below 45°F (7°C), winter tires provide better traction and shorter stopping distances.",
            category: .seasonal,
            color: .cyan
        ),
        TipItem(
            icon: "align.vertical.center",
            title: "Get Wheel Alignment Checked",
            description: "Have alignment checked annually or if you notice uneven tire wear, pulling to one side, or after hitting a pothole.",
            category: .maintenance,
            color: .purple
        ),
        TipItem(
            icon: "exclamationmark.triangle.fill",
            title: "Don't Ignore Warning Signs",
            description: "Vibrations, unusual noises, or pulling to one side are signs of tire problems. Get them checked immediately.",
            category: .safety,
            color: .red
        ),
        TipItem(
            icon: "calendar",
            title: "Check Tire Age",
            description: "Tires should be replaced after 10 years, regardless of tread depth. Check the DOT code on the sidewall for manufacturing date.",
            category: .basics,
            color: .indigo
        ),
        TipItem(
            icon: "eye.fill",
            title: "Inspect Tires Regularly",
            description: "Look for cuts, bulges, cracks, or objects stuck in the tread. These can lead to tire failure if not addressed.",
            category: .safety,
            color: .pink
        ),
        TipItem(
            icon: "road.lanes",
            title: "Avoid Sudden Maneuvers",
            description: "Aggressive driving, hard braking, and fast cornering increase tire wear and reduce tire life.",
            category: .safety,
            color: .mint
        ),
        TipItem(
            icon: "figure.walk",
            title: "Don't Mix Tire Types",
            description: "Using different tire types or brands on the same axle can cause handling problems. Always replace tires in pairs.",
            category: .technical,
            color: .teal
        ),
        TipItem(
            icon: "sun.max.fill",
            title: "Protect from UV Damage",
            description: "Park in shade when possible and use tire covers for long-term storage to prevent dry rot and cracking.",
            category: .maintenance,
            color: .yellow
        ),
        TipItem(
            icon: "scalemass.fill",
            title: "Don't Overload Your Vehicle",
            description: "Exceeding your vehicle's load capacity puts extra stress on tires and can cause overheating and failure.",
            category: .safety,
            color: .brown
        )
    ]
    
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
                        VStack(spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.yellow)
                                .scaleEffect(animateCards ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: animateCards)
                            
                            Text("Tire Safety Tips")
                                .font(.title)
                                .fontWeight(.bold)
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                            
                            Text("Essential knowledge for tire maintenance and safety")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.8)
                                .lineLimit(2)
                                .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        .opacity(animateCards ? 1 : 0)
                        .animation(.easeOut(duration: 0.6), value: animateCards)
                        
                        LazyVStack(spacing: 15) {
                            ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                                TipCard(tip: tip)
                                    .opacity(animateCards ? 1 : 0)
                                    .offset(y: animateCards ? 0 : 20)
                                    .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.05), value: animateCards)
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
        .onAppear {
            animateCards = true
        }
    }
}

struct TipItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let category: QuizCategory
    let color: Color
}

struct TipCard: View {
    let tip: TipItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(tip.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: tip.icon)
                        .font(.title2)
                        .foregroundColor(tip.color)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(tip.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                    
                    Text(tip.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(tip.color.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            
            Text(tip.description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .minimumScaleFactor(0.9)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    TipsView()
}

