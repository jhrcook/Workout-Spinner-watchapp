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
        let pastelRange = 140...255
        return Color(red: Int.random(in: pastelRange), green: Int.random(in: pastelRange), blue: Int.random(in: pastelRange))
    }
}


struct CustomColors_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(0..<10) { _ in
                Color.randomPastelColor().previewLayout(.fixed(width: 50, height: 50))
            }
        }
    }
}
