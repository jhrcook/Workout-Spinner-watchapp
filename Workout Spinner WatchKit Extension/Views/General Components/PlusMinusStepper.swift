//
//  PlusMinusStepper.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 1/28/21.
//  Copyright © 2021 Joshua Cook. All rights reserved.
//

import SwiftUI

struct PlusMinusStepper<T: NumericType>: View {
    @Binding var value: T
    let step: T
    var min: T? = nil
    var max: T? = nil
    var label: Text
    var extraDownAction: (() -> Void)? = nil
    var extraUpAction: (() -> Void)? = nil

    private let buttonFrameWidth: CGFloat = 40

    var body: some View {
        HStack {
            Button(action: {
                value = value - step
                if let f = extraDownAction { f() }
            }, label: {
                Image(systemName: "minus.circle").foregroundColor(.red).font(.system(size: 25))
            })
                .disabled(min != nil ? (value - step) < min! : false)
                .buttonStyle(PlainButtonStyle())
                .padding(2)
                .frame(width: buttonFrameWidth)

            Spacer()

            label.padding(3)

            Spacer()

            Button(action: {
                value = value + step
                if let f = extraUpAction { f() }
            }, label: {
                Image(systemName: "plus.circle").foregroundColor(.green).font(.system(size: 25))
            })
                .disabled(max != nil ? (value + step) > max! : false)
                .buttonStyle(PlainButtonStyle())
                .padding(2)
                .frame(width: buttonFrameWidth)
        }
    }
}

#if DEBUG
    struct PlusMinusStepper_Previews: PreviewProvider {
        static var previews: some View {
            PlusMinusStepper<Int>(value: .constant(3), step: 1, label: Text("3")).previewLayout(.fixed(width: 100, height: 50))
        }
    }
#endif
