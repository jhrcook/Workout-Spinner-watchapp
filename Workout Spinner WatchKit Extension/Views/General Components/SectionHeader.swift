//
//  SwiftUIView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/13/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    let imageName: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
        }
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(imageName: "mustache", text: "Text")
    }
}
