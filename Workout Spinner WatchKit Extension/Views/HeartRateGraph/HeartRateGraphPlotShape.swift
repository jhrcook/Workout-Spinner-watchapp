//
//  HeartRateGraphPlotShape.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/5/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct HeartRateGraphPlotShape: Shape {
    let graphData: HeartRateGraphData

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = Double(rect.size.width)
        let height = Double(rect.size.height)

        let xData = graphData.convertedXData(toMin: 0.0, toMax: width)
        let yData = graphData.convertedYData(toMin: height, toMax: 0.0)

        path.move(to: CGPoint(x: xData[0], y: yData[0]))
        for (x, y) in zip(xData, yData) {
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}

#if DEBUG
    struct HeartRateGraphPlotShape_Previews: PreviewProvider {
        static var previews: some View {
            VStack {
                HeartRateGraphPlotShape(graphData: HeartRateGraphData(workoutTraker: WorkoutTracker()))
            }
        }
    }
#endif
