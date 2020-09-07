//
//  BodyPartSelectionListView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct BodyPartSelectionListView: View {
    
    var bodyParts: [String] {
        var a = [String]()
        for bp in ExerciseBodyPart.allCases {
            a.append(bp.rawValue)
        }
        return a
    }
    
    var body: some View {
        List {
            ForEach(bodyParts, id: \.self) { bp in
                HStack {
                    Text(bp.capitalized)
                    Spacer()
                    Text("I/O")
                }
            }
        }
    }
}

struct BodyPartSelectionListView_Previews: PreviewProvider {
    static var previews: some View {
        BodyPartSelectionListView()
    }
}



// TODO: need a Publisher and such for array of values for toggle switches
