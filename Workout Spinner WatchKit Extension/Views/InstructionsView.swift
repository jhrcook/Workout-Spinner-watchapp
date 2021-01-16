//
//  InstructionsView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/18/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct InstructionsView: View {
    struct Instruction: View {
        let idx: Int
        let text: String
        var body: some View {
            HStack(spacing: 3) {
                VStack {
                    Image(systemName: "\(idx).circle")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                        .frame(width: 20)
                        .padding(.top, 2)
                    Spacer()
                }
                Text(text)
            }
            .padding(2)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.darkGray)
            )
            .padding(2)
        }
    }

    var body: some View {
        ScrollView {
            Instruction(idx: 1, text: "Use the crown to spin the wheel.")
            Instruction(idx: 2, text: "Perform the exercise that is selected and tap 'Done' when completed.")
            Instruction(idx: 3, text: "To finish a workout, tap and hold the wheel.")
        }
    }
}

#if DEBUG
    struct InstructionsView_Previews: PreviewProvider {
        static var previews: some View {
            InstructionsView()
        }
    }
#endif
