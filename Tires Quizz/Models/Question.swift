import Foundation
import Combine

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let category: QuizCategory
}

enum QuizCategory: String, CaseIterable {
    case basics = "Tire Basics"
    case maintenance = "Maintenance"
    case safety = "Safety"
    case technical = "Technical"
    case seasonal = "Seasonal"
}

class QuizData: ObservableObject {
    @Published var questions: [Question] = [
        // Tire Basics
        Question(
            text: "What does the number '205' represent in a tire size like 205/55R16?",
            options: ["Tire width in millimeters", "Tire diameter in inches", "Load capacity", "Speed rating"],
            correctAnswer: 0,
            explanation: "The first number (205) represents the tire's width in millimeters from sidewall to sidewall.",
            category: .basics
        ),
        Question(
            text: "What does 'R' stand for in tire size designation 205/55R16?",
            options: ["Racing tire", "Radial construction", "Reinforced", "Recommended"],
            correctAnswer: 1,
            explanation: "The 'R' stands for Radial construction, which is the most common tire construction type today.",
            category: .basics
        ),
        Question(
            text: "What is the recommended minimum tread depth for safe driving?",
            options: ["1/16 inch (1.6mm)", "2/32 inch (1.6mm)", "4/32 inch (3.2mm)", "6/32 inch (4.8mm)"],
            correctAnswer: 1,
            explanation: "The legal minimum in most places is 2/32 inch (1.6mm), though many experts recommend replacing tires at 4/32 inch.",
            category: .basics
        ),
        Question(
            text: "What is tire rotation and why is it important?",
            options: ["Spinning the tire on the wheel", "Moving tires to different positions on the vehicle", "Balancing the tires", "Inflating the tires"],
            correctAnswer: 1,
            explanation: "Tire rotation means moving tires to different positions on your vehicle to ensure even wear and extend tire life.",
            category: .basics
        ),
        
        // Maintenance
        Question(
            text: "How often should you check your tire pressure?",
            options: ["Once a year", "Every 6 months", "Once a month", "Only when the TPMS light comes on"],
            correctAnswer: 2,
            explanation: "You should check tire pressure at least once a month and before long trips. Proper inflation is crucial for safety and fuel efficiency.",
            category: .maintenance
        ),
        Question(
            text: "When should you check your tire pressure?",
            options: ["When tires are hot after driving", "When tires are cold (before driving)", "It doesn't matter", "After driving for 30 minutes"],
            correctAnswer: 1,
            explanation: "Always check tire pressure when tires are cold, as heat from driving increases pressure and gives inaccurate readings.",
            category: .maintenance
        ),
        Question(
            text: "What can cause uneven tire wear?",
            options: ["Improper wheel alignment", "Incorrect tire pressure", "Worn suspension components", "All of the above"],
            correctAnswer: 3,
            explanation: "All these factors can cause uneven tire wear. Regular maintenance and proper alignment are essential for tire longevity.",
            category: .maintenance
        ),
        Question(
            text: "How often should tires be rotated?",
            options: ["Every 3,000 miles", "Every 5,000-7,500 miles", "Every 10,000 miles", "Only when they look worn"],
            correctAnswer: 1,
            explanation: "Tires should typically be rotated every 5,000-7,500 miles, or as recommended in your vehicle's owner's manual.",
            category: .maintenance
        ),
        
        // Safety
        Question(
            text: "What is hydroplaning?",
            options: ["Tire overheating", "Loss of traction on wet surfaces", "Tire explosion", "Excessive tire wear"],
            correctAnswer: 1,
            explanation: "Hydroplaning occurs when a layer of water builds between the tire and road surface, causing loss of traction and steering control.",
            category: .safety
        ),
        Question(
            text: "What should you do if you experience a tire blowout while driving?",
            options: ["Brake hard immediately", "Gradually ease off the gas and steer straight", "Turn sharply to the shoulder", "Speed up to maintain control"],
            correctAnswer: 1,
            explanation: "In a blowout, grip the steering wheel firmly, gradually ease off the gas, keep straight, and gently brake once you've slowed down.",
            category: .safety
        ),
        Question(
            text: "What is the 'penny test' used for?",
            options: ["Testing tire pressure", "Checking tread depth", "Testing wheel balance", "Checking tire age"],
            correctAnswer: 1,
            explanation: "The penny test checks tread depth. Insert a penny upside down into the tread; if you can see Lincoln's head, it's time for new tires.",
            category: .safety
        ),
        Question(
            text: "Under-inflated tires can cause:",
            options: ["Better fuel economy", "Improved handling", "Increased tire wear and overheating", "Smoother ride"],
            correctAnswer: 2,
            explanation: "Under-inflated tires wear faster on the edges, generate excess heat, reduce fuel economy, and can lead to tire failure.",
            category: .safety
        ),
        Question(
            text: "What does TPMS stand for?",
            options: ["Tire Performance Monitoring System", "Tire Pressure Monitoring System", "Tire Position Management System", "Total Pressure Measurement System"],
            correctAnswer: 1,
            explanation: "TPMS stands for Tire Pressure Monitoring System, which alerts you when tire pressure is too low.",
            category: .safety
        ),
        
        // Technical
        Question(
            text: "What is the aspect ratio in tire size 205/55R16?",
            options: ["205", "55", "16", "R"],
            correctAnswer: 1,
            explanation: "The aspect ratio (55) is the height of the sidewall as a percentage of the tire's width. In this case, 55% of 205mm.",
            category: .technical
        ),
        Question(
            text: "What does the load index indicate?",
            options: ["Maximum speed", "Maximum weight capacity", "Tire width", "Air pressure"],
            correctAnswer: 1,
            explanation: "The load index is a number that indicates the maximum weight each tire can safely carry when properly inflated.",
            category: .technical
        ),
        Question(
            text: "What does a 'Y' speed rating mean?",
            options: ["Up to 100 mph", "Up to 149 mph", "Up to 186 mph", "Up to 200 mph"],
            correctAnswer: 2,
            explanation: "A 'Y' speed rating indicates the tire is designed for speeds up to 186 mph (300 km/h).",
            category: .technical
        ),
        Question(
            text: "What is tire balance?",
            options: ["Equal tread depth on all tires", "Equal air pressure", "Equal weight distribution around the tire", "Equal temperature"],
            correctAnswer: 2,
            explanation: "Tire balance ensures the weight of the tire and wheel is evenly distributed around the axle, preventing vibration.",
            category: .technical
        ),
        Question(
            text: "What causes a tire to 'feather'?",
            options: ["Over-inflation", "Toe misalignment", "Driving too fast", "Old age"],
            correctAnswer: 1,
            explanation: "Feathering (tire edge wear) is typically caused by incorrect toe alignment, where tires point in or out.",
            category: .technical
        ),
        
        // Seasonal
        Question(
            text: "At what temperature should you consider winter tires?",
            options: ["Below 32°F (0°C)", "Below 45°F (7°C)", "Below 20°F (-7°C)", "Only when there's snow"],
            correctAnswer: 1,
            explanation: "Winter tires are recommended when temperatures consistently drop below 45°F (7°C), as their rubber compound works better in cold.",
            category: .seasonal
        ),
        Question(
            text: "What makes winter tires different from all-season tires?",
            options: ["They're just thicker", "Different rubber compound and tread pattern", "They have metal studs", "They're painted white"],
            correctAnswer: 1,
            explanation: "Winter tires use a softer rubber compound that stays flexible in cold temperatures, plus deeper tread patterns for snow traction.",
            category: .seasonal
        ),
        Question(
            text: "Can you use winter tires year-round?",
            options: ["Yes, they work great all year", "No, they wear quickly in warm weather", "Only on 4WD vehicles", "Yes, but only on the front"],
            correctAnswer: 1,
            explanation: "Winter tires wear much faster in warm weather due to their softer rubber compound and provide less optimal performance.",
            category: .seasonal
        ),
        Question(
            text: "What is the mountain snowflake symbol on a tire?",
            options: ["Decoration only", "Severe snow service certification", "All-season tire marking", "Summer tire warning"],
            correctAnswer: 1,
            explanation: "The Three-Peak Mountain Snowflake symbol indicates the tire meets specific snow traction performance requirements.",
            category: .seasonal
        ),
        Question(
            text: "What is tire dry rot?",
            options: ["Cracks in tire from age and UV exposure", "Rust on the wheel", "Worn tread pattern", "Flat tire"],
            correctAnswer: 0,
            explanation: "Dry rot is cracking and deterioration of tire rubber due to age, UV exposure, and environmental factors, even if tread looks good.",
            category: .seasonal
        ),
        Question(
            text: "How old is too old for a tire?",
            options: ["5 years", "10 years", "15 years", "20 years"],
            correctAnswer: 1,
            explanation: "Most manufacturers recommend replacing tires after 10 years, regardless of tread depth, due to rubber degradation over time.",
            category: .seasonal
        ),
        
        Question(
            text: "What does 'XL' or 'Extra Load' mean on a tire?",
            options: ["Extra large size", "Higher load capacity", "Extra layers of rubber", "Extended life"],
            correctAnswer: 1,
            explanation: "XL or Extra Load means the tire can carry more weight than a standard tire of the same size when properly inflated.",
            category: .technical
        ),
        Question(
            text: "What is tire camber wear?",
            options: ["Wear on tire shoulders", "Center tread wear", "One-sided tire wear", "Random wear pattern"],
            correctAnswer: 2,
            explanation: "Camber wear shows as excessive wear on one side of the tire, caused by improper wheel camber angle alignment.",
            category: .technical
        ),
        Question(
            text: "What does a 'W' speed rating indicate?",
            options: ["Up to 168 mph", "Up to 149 mph", "Up to 130 mph", "Up to 118 mph"],
            correctAnswer: 0,
            explanation: "A 'W' speed rating means the tire is designed for speeds up to 168 mph (270 km/h).",
            category: .technical
        ),
        Question(
            text: "What causes tire cupping or scalloping?",
            options: ["Overinflation", "Worn suspension components", "Excessive speed", "Wrong tire size"],
            correctAnswer: 1,
            explanation: "Tire cupping is typically caused by worn shock absorbers or other suspension components that allow the tire to bounce.",
            category: .maintenance
        ),
        Question(
            text: "Should you replace tires in pairs or all four?",
            options: ["One at a time is fine", "Always replace all four", "Pairs on the same axle", "Replace only the worst one"],
            correctAnswer: 2,
            explanation: "Tires should be replaced in pairs on the same axle to maintain balanced handling and traction.",
            category: .safety
        ),
        Question(
            text: "What is the purpose of tire siping?",
            options: ["Reduce noise", "Improve wet traction", "Increase tire life", "Reduce weight"],
            correctAnswer: 1,
            explanation: "Siping (small slits in the tread) increases the number of biting edges, improving traction on wet and icy roads.",
            category: .technical
        ),
        Question(
            text: "What does DOT stand for on a tire?",
            options: ["Date of Tire", "Department of Transportation", "Durability over Time", "Design of Tread"],
            correctAnswer: 1,
            explanation: "DOT stands for Department of Transportation. The DOT code includes manufacturing information and date.",
            category: .basics
        ),
        Question(
            text: "How do you read the tire date code?",
            options: ["First 2 digits: week, last 2: year", "Last 4 digits: week and year", "First 4 digits: month and year", "Middle numbers only"],
            correctAnswer: 1,
            explanation: "The last 4 digits of the DOT code show manufacture date: first 2 are the week, last 2 are the year (e.g., 2319 = 23rd week of 2019).",
            category: .basics
        ),
        Question(
            text: "What is aquaplaning speed?",
            options: ["Speed limit in rain", "Speed at which hydroplaning begins", "Maximum safe speed", "Speed rating in water"],
            correctAnswer: 1,
            explanation: "Aquaplaning (hydroplaning) speed is the velocity at which a tire loses contact with the road surface due to water buildup.",
            category: .safety
        ),
        Question(
            text: "What is run-flat tire technology?",
            options: ["Tires that never go flat", "Tires that can drive temporarily after air loss", "Extra thick sidewalls", "Self-inflating tires"],
            correctAnswer: 1,
            explanation: "Run-flat tires have reinforced sidewalls allowing you to drive limited distances (typically 50 miles) at reduced speed after air loss.",
            category: .technical
        ),
        Question(
            text: "What does 'M+S' marking mean?",
            options: ["Maximum Speed", "Mud and Snow", "Mountain Safe", "Multi Season"],
            correctAnswer: 1,
            explanation: "M+S (or M&S) stands for Mud and Snow, indicating the tire has some capability in these conditions, but it's not as rigorous as the mountain snowflake symbol.",
            category: .seasonal
        ),
        Question(
            text: "What is nitrogen inflation and its benefit?",
            options: ["Makes tires lighter", "Reduces pressure loss over time", "Increases speed rating", "Improves fuel economy directly"],
            correctAnswer: 1,
            explanation: "Nitrogen molecules are larger than oxygen, so they permeate through tire rubber more slowly, maintaining pressure longer. However, regular air works fine too.",
            category: .maintenance
        ),
        Question(
            text: "What is the ideal tread depth for winter driving?",
            options: ["2/32 inch", "4/32 inch", "6/32 inch or more", "8/32 inch"],
            correctAnswer: 2,
            explanation: "For winter driving, 6/32 inch or more tread depth is recommended for adequate snow and ice traction, even though legal minimum is 2/32 inch.",
            category: .seasonal
        ),
        Question(
            text: "What causes tire sidewall bulges?",
            options: ["Overinflation", "Impact damage to internal structure", "Manufacturing defect only", "Normal wear"],
            correctAnswer: 1,
            explanation: "Bulges are usually caused by impact damage (hitting potholes, curbs) that breaks the internal cords, allowing air pressure to push out the sidewall.",
            category: .safety
        ),
        Question(
            text: "What is tire aspect ratio 55 in 205/55R16?",
            options: ["55mm sidewall height", "55% of width", "55mph rating", "55kg load"],
            correctAnswer: 1,
            explanation: "The aspect ratio (55) means the sidewall height is 55% of the tire's width (205mm), so the sidewall is about 113mm tall.",
            category: .basics
        ),
        Question(
            text: "Can you mix different tire brands on your vehicle?",
            options: ["Never mix brands", "Same brand on each axle", "Any mix is fine", "Only premium brands together"],
            correctAnswer: 1,
            explanation: "While it's best to use the same brand/model on all four, at minimum you should have matching tires on the same axle for balanced handling.",
            category: .safety
        ),
        Question(
            text: "What is tire treadwear rating?",
            options: ["Speed limit of tire", "Comparative measure of tire life", "Load capacity", "Temperature resistance"],
            correctAnswer: 1,
            explanation: "Treadwear rating is a comparative number (e.g., 300, 400, 500) indicating expected tire life. Higher numbers suggest longer tread life.",
            category: .technical
        ),
        Question(
            text: "Why should new tires be installed on the rear?",
            options: ["They wear slower there", "Better handling in rain", "Required by law", "Cheaper installation"],
            correctAnswer: 1,
            explanation: "New tires on the rear help maintain stability and prevent oversteer/fishtailing in wet conditions, which is harder to control than understeer.",
            category: .safety
        ),
        Question(
            text: "What is directional tire tread pattern?",
            options: ["Tread pointing forward only", "Can rotate any direction", "Symmetric pattern", "Different left and right"],
            correctAnswer: 0,
            explanation: "Directional tires have a V-shaped tread pattern that must rotate in a specific direction (marked with an arrow) for optimal performance, especially water evacuation.",
            category: .technical
        ),
        Question(
            text: "What temperature affects tire pressure most?",
            options: ["Every 1°F change affects pressure", "Every 10°F change affects pressure", "Temperature doesn't affect it", "Only extreme heat matters"],
            correctAnswer: 1,
            explanation: "Tire pressure changes about 1 PSI for every 10°F temperature change. Cold weather lowers pressure; hot weather increases it.",
            category: .maintenance
        ),
        Question(
            text: "What is the recommended tire rotation pattern for AWD vehicles?",
            options: ["Front to back only", "X-pattern", "Back to front only", "No rotation needed"],
            correctAnswer: 1,
            explanation: "AWD vehicles typically use an X-pattern rotation (each tire moves to the opposite corner) to ensure even wear across all four tires.",
            category: .maintenance
        ),
        Question(
            text: "What does 'staggered fitment' mean?",
            options: ["Different tire sizes front and rear", "Uneven tire wear", "Installation error", "Alternating tire brands"],
            correctAnswer: 0,
            explanation: "Staggered fitment means wider tires on the rear than front, common on performance vehicles but limits rotation options.",
            category: .technical
        ),
        Question(
            text: "When should you check tire condition beyond pressure?",
            options: ["Once a year only", "Every oil change", "Monthly visual inspection", "Only when problems occur"],
            correctAnswer: 2,
            explanation: "You should visually inspect tires monthly for cuts, bulges, objects, and uneven wear, in addition to checking pressure.",
            category: .maintenance
        ),
        Question(
            text: "What is a tire's temperature rating?",
            options: ["Operating temperature range", "Heat resistance capability (A, B, or C)", "Cold weather performance", "Storage temperature"],
            correctAnswer: 1,
            explanation: "Temperature rating (A, B, or C) indicates the tire's resistance to heat generation at speed. A is highest, C is minimum acceptable.",
            category: .technical
        ),
        Question(
            text: "What causes tire vibration at highway speeds?",
            options: ["Always low pressure", "Out of balance or damaged tire", "Normal at high speeds", "Wrong tire size"],
            correctAnswer: 1,
            explanation: "Vibration at highway speeds usually indicates an out-of-balance tire, tire damage, or a bent wheel that needs professional inspection.",
            category: .safety
        ),
        Question(
            text: "What is tire load range?",
            options: ["Weight capacity classification", "Tread depth range", "Speed capability", "Size variation"],
            correctAnswer: 0,
            explanation: "Load range (e.g., SL, XL, C, D, E) indicates the tire's load-carrying capacity and required inflation pressure, especially important for trucks.",
            category: .basics
        ),
        Question(
            text: "Should tire pressure be higher when carrying heavy loads?",
            options: ["No, keep it the same", "Yes, increase per vehicle manual", "Lower pressure for better grip", "Only for truck tires"],
            correctAnswer: 1,
            explanation: "When carrying heavy loads or towing, you should increase tire pressure according to your vehicle's manual recommendations to safely support the extra weight.",
            category: .safety
        )
    ]
    
    @Published var currentQuestionIndex = 0
    @Published var userAnswers: [Int?] = []
    @Published var showingExplanation = false
    @Published var score = 0
    
    init() {
        questions.shuffle()
        userAnswers = Array(repeating: nil, count: questions.count)
    }
    
    func selectAnswer(_ answerIndex: Int) {
        userAnswers[currentQuestionIndex] = answerIndex
        if answerIndex == questions[currentQuestionIndex].correctAnswer {
            score += 1
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func reset() {
        currentQuestionIndex = 0
        userAnswers = Array(repeating: nil, count: questions.count)
        score = 0
        questions.shuffle()
    }
    
    var progress: Double {
        let answeredCount = userAnswers.filter { $0 != nil }.count
        return Double(answeredCount) / Double(questions.count)
    }
    
    var isQuizComplete: Bool {
        userAnswers.allSatisfy { $0 != nil }
    }
}

