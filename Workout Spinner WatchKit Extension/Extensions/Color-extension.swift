//
//  File.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/2/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

extension Color {
    init(red: Int, green: Int, blue: Int) {
        func f(_ x: Int) -> Double {
            return Double(x) / 255.0
        }
        self.init(red: f(red), green: f(green), blue: f(blue))
    }

    static func randomPastelColor() -> Color {
        let pastelRange = 140 ... 255
        return Color(red: Int.random(in: pastelRange), green: Int.random(in: pastelRange), blue: Int.random(in: pastelRange))
    }
}

extension Color {
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
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct CustomColors_Previews: PreviewProvider {
    static var customColors: [Color] = [.workoutGreen, .darkGray, .deepRed, .deepRed2, .pastelDarkRed, .pastelDarkRed2]

    static var previews: some View {
        Group {
            ForEach(0 ..< 10) { _ in
                Color.randomPastelColor().previewLayout(.fixed(width: 50, height: 50))
            }
            ForEach(0 ..< CustomColors_Previews.customColors.count) { i in
                CustomColors_Previews.customColors[i].previewLayout(.fixed(width: 50, height: 50))
            }
        }
    }
}

extension Color {
    static let workoutGreen = Color(red: 175, green: 245, blue: 58)
    static let darkWorkoutRed = Color(red: 227, green: 2, blue: 25)
    static let workoutRed = Color(red: 237, green: 20, blue: 66)
    static let lightWorkoutRed = Color(red: 249, green: 39, blue: 110)
    static let darkGray = Color(red: 40, green: 40, blue: 40)
    static let deepRed = Color(red: 232, green: 39, blue: 39)
    static let deepRed2 = Color(red: 200, green: 20, blue: 20)
    static let pastelDarkRed = Color(red: 230, green: 78, blue: 78)
    static let pastelDarkRed2 = Color(red: 209, green: 67, blue: 67)
    static let lighterDarkGray = Color(red: 79, green: 33, blue: 33)
}
