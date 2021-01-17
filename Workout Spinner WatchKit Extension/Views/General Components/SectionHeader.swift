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

struct SpinningImageSectionHeader: View {
    let imageName: String
    let text: String

    @State private var angle: Angle = .degrees(0.0)

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .rotationEffect(angle)
                .animation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false))
                .onAppear {
                    self.angle = .degrees(360)
                }
            Text(text)
        }
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SectionHeader(imageName: "mustache", text: "Text")
            SpinningImageSectionHeader(imageName: "mustache", text: "Text")
        }
    }
}
