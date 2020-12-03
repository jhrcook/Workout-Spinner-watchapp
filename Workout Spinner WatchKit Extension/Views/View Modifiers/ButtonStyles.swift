//
//  ButtonStyles.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/11/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct DoneButtonStyle: ButtonStyle {
    var padding: CGFloat = 5.0
    var cornerRadius: CGFloat = 5.0
    var color = Color.workoutRed

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(color)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.linear(duration: 0.2))
    }
}

struct StartWorkoutButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.darkGray)
            )
    }
}

struct DoneButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded))
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                Button(action: {}) { Text("Button") }
                    .buttonStyle(DoneButtonStyle())
                Button(action: {}) { Text("Button") }
                    .buttonStyle(StartWorkoutButtonStyle())
            }
        }
    }
}
