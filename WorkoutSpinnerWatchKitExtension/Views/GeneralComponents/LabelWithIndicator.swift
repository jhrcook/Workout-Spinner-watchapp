//
//  LabelWithIndicator.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/13/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct LabelWithIndicator: View {
    let text: String
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            Image(systemName: "chevron.right").opacity(0.5)
        }
    }
}

struct LabelWithIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LabelWithIndicator(text: "Label")
    }
}
