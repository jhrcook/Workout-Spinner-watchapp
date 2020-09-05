//
//  SpinnerRotationModifier.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SpinnerRotationModifier: AnimatableModifier {
    
    var rotation: Angle
    var onFinishedRotationAnimation: () -> () = {}
    var completionTolerance: Double = 0.00001
    
    private var targetRotation: Angle
    
    init(rotation: Angle) {
        self.rotation = rotation
        self.targetRotation = rotation
    }
    
    init(rotation: Angle, onFinishedRotationAnimation: @escaping () -> ()) {
        self.rotation = rotation
        self.targetRotation = rotation
        self.onFinishedRotationAnimation = onFinishedRotationAnimation
    }
    
    init(rotation: Angle, onFinishedRotationAnimation: @escaping () -> (), completionTolerance: Double) {
        self.rotation = rotation
        self.targetRotation = rotation
        self.onFinishedRotationAnimation = onFinishedRotationAnimation
        self.completionTolerance = completionTolerance
    }
    
    
    var animatableData: Double {
        get { rotation.degrees }
      set {
        rotation = .degrees(newValue)
        checkIfFinished()
      }
    }
    
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(rotation)
    }
    
    
    func checkIfFinished() {
        if abs(rotation.degrees - targetRotation.degrees) < completionTolerance {
            DispatchQueue.main.async { self.onFinishedRotationAnimation() }
        }
    }
}


struct SpinnerRotationModifier_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image(systemName: "trash")
                .font(.largeTitle)
                .foregroundColor(.gray)
            Image(systemName: "trash")
                .font(.largeTitle)
                .foregroundColor(.purple)
                .modifier(SpinnerRotationModifier(rotation: .degrees(90.0)))
        }
        .padding(50)
        .previewLayout(.sizeThatFits)
    }
}
