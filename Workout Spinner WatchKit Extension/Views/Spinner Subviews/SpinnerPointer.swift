//
//  SpinnerPointer.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/4/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct PointerTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct SpinnerPointer: View {
    var body: some View {
        PointerTriangle()
            .foregroundColor(.workoutRed)
            .shadow(color: .black, radius: 5, x: 3, y: 3)
    }
}

struct SpinnerPointer_Previews: PreviewProvider {
    static var previews: some View {
        SpinnerPointer()
            .padding()
            .background(Color.gray)
            .previewLayout(.fixed(width: 100, height: 100))
    }
}
