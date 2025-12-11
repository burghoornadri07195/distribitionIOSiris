//
//  ThemeManager.swift
//  Tires Quizz
//
//  Created on 12.12.25.
//

import SwiftUI
import Combine

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "circle.lefthalf.filled"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}

extension Color {
    static let darkThemeBackground = Color(hex: "191E3C")
    static let darkThemeSecondary = Color(hex: "242A45")
    static let darkThemeAccent = Color(hex: "2E3651")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    
    var isDarkMode: Bool {
        currentTheme == .dark || (currentTheme == .system && UITraitCollection.current.userInterfaceStyle == .dark)
    }
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme")
        self.currentTheme = AppTheme(rawValue: savedTheme ?? AppTheme.system.rawValue) ?? .system
    }
    
    func toggleTheme() {
        let allCases = AppTheme.allCases
        if let currentIndex = allCases.firstIndex(of: currentTheme) {
            let nextIndex = (currentIndex + 1) % allCases.count
            currentTheme = allCases[nextIndex]
            // Сохраняем в UserDefaults
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    func backgroundColor(_ colorScheme: ColorScheme) -> Color {
        if currentTheme == .dark || (currentTheme == .system && colorScheme == .dark) {
            return .darkThemeBackground
        }
        return Color(uiColor: .systemBackground)
    }
    
    func secondaryBackground(_ colorScheme: ColorScheme) -> Color {
        if currentTheme == .dark || (currentTheme == .system && colorScheme == .dark) {
            return .darkThemeSecondary
        }
        return Color(uiColor: .secondarySystemBackground)
    }
    
    func cardBackground(_ colorScheme: ColorScheme) -> Color {
        if currentTheme == .dark || (currentTheme == .system && colorScheme == .dark) {
            return .darkThemeAccent
        }
        return Color(uiColor: .systemBackground)
    }
}

