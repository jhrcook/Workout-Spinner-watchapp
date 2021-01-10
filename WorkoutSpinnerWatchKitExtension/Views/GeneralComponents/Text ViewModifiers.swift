//
//  Text ViewModifiers.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 12/3/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct DoneButtonText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded))
            .foregroundColor(.white)
            .frame(minWidth: 0, maxWidth: .infinity)
    }
}
