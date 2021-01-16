//
//  CannotSpinView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 12/15/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct CannotSpinView: View {
    @ObservedObject var workoutManager: WorkoutManager
    @ObservedObject var exerciseOptions: ExerciseOptions

    @Binding var presentationMode: PresentationMode

    private var reasons: [String] {
        createListOfReasonsTheSpinnerIsUnavailable()
    }

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Text("The spinner is currently unavailable. The most likely reasons are listed below.")
                    .font(.body)
                    .bold()
                    .foregroundColor(.pastelDarkRed)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                ForEach(0 ..< reasons.count, id: \.self) { i in
                    Text(reasons[i])
                        .font(.body)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(style: StrokeStyle(lineWidth: 4))
                                .foregroundColor(.lighterDarkGray)
                        )
                }
                .padding(.vertical, 5)
                Spacer()
                DoneButton(text: "Back") {
                    presentationMode.dismiss()
                }
            }
        }
    }
}

extension CannotSpinView {
    func createListOfReasonsTheSpinnerIsUnavailable() -> [String] {
        var reasons = [String]()
        if exerciseOptions.numberOfExercisesFiltered < 5 {
            // Not enough exercises to choose from.
            reasons.append("With your current settings, there are not enough exercises to build the spinner. Please check that your settings are not too restrictive or create new exercises that fit your needs.")
        }

        return reasons
    }
}

#if DEBUG
    struct CannotSpinView_Previews: PreviewProvider {
        @Environment(\.presentationMode) static var presentationMode
        static var previews: some View {
            CannotSpinView(workoutManager: WorkoutManager(), exerciseOptions: ExerciseOptions(), presentationMode: presentationMode)
        }
    }
#endif
