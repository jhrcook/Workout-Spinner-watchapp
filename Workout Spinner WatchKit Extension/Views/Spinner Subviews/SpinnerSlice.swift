//
//  SpinnerSlice.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/3/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SpinnerSliceShape: Shape {
    let radius: CGFloat
    let angle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: radius,
                    startAngle: angle * 0.5,
                    endAngle: angle * (-0.5),
                    clockwise: true)
        return path
    }
}

struct SpinnerSlice: View {
    let idx: Int
    let numberOfSlices: Int
    let width: CGFloat

    var sliceAngle: Angle {
        Angle.degrees(360.0 / Double(numberOfSlices))
    }

    var rotationAngle: Angle {
        Angle.degrees(Double(idx) * 360.0 / Double(numberOfSlices))
    }

    var body: some View {
        ZStack {
//            Color.darkGray
            LinearGradient(gradient: Gradient(colors: [.gray, .darkGray]), startPoint: .leading, endPoint: .trailing)
                .clipShape(SpinnerSliceShape(radius: width / 2.0, angle: sliceAngle))
            SpinnerSliceShape(radius: width / 2.0, angle: sliceAngle)
                .stroke(Color.white, lineWidth: 3)
                .frame(width: width, height: width)
        }
        .rotationEffect(rotationAngle)
    }
}

struct SpinnerSlice_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(3 ..< 8) { i in
                SpinnerSlice(idx: 1, numberOfSlices: i, width: 100)
                    .padding()
            }
        }.previewLayout(.sizeThatFits)
    }
}
