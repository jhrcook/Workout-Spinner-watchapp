//
//  PlotHVGridText.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct PlotHVGridText: View {
    let value: Double
    let horizontal: Bool
    let graphData: HeartRateGraphData
    let size: CGSize

    let fontSize: CGFloat = 10

    var position: CGPoint {
        var mappedValue = 0.0
        if horizontal {
            mappedValue = graphData.convert(y: value, toMin: Double(size.height), toMax: 0)
        } else {
            mappedValue = graphData.convert(x: value, toMin: 0, toMax: Double(size.width))
        }
        return CGPoint(x: horizontal ? 5 : mappedValue, y: horizontal ? mappedValue : 5)
    }

    var body: some View {
        Text("\(value, specifier: "%.0f")")
            .padding(0)
            .font(.system(size: fontSize))
            .position(position)
    }
}
