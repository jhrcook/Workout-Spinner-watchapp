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
    static let workoutGreen = Color(red: 194, green: 255, blue: 60)
    static let workoutRed = Color(red: 214, green: 26, blue: 82)
    static let darkGray = Color(red: 40, green: 40, blue: 40)
    static let deepRed = Color(red: 232, green: 39, blue: 39)
    static let deepRed2 = Color(red: 200, green: 20, blue: 20)
    static let pastelDarkRed = Color(red: 230, green: 78, blue: 78)
    static let pastelDarkRed2 = Color(red: 209, green: 67, blue: 67)
}
