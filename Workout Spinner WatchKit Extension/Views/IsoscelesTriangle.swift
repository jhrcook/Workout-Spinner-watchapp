//
//  IsoscelesTriangle.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/2/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI


struct IsoscelesTriangle: Shape {
    
    let angle: Angle
    
    
    
    func path(in rect: CGRect) -> Path {
        let b = calcB(rect: rect)
        var path = Path()
        
        path.move(to: rect.center)
        path.addLine(to: calcPointOne(rect, b: b))
        path.addLine(to: calcPointTwo(rect, b: b))
        path.addLine(to: rect.center)
        
        return path
    }
    
    private func calcPointOne(_ rect: CGRect, b: CGFloat) -> CGPoint {
        CGPoint(x: rect.minX + diffFromCorner(rect: rect, b: b), y: rect.minY)
    }
    
    private func calcPointTwo(_ rect: CGRect, b: CGFloat) -> CGPoint {
        CGPoint(x: rect.maxX - diffFromCorner(rect: rect, b: b), y: rect.minY)
    }
    
    private func diffFromCorner(rect: CGRect, b: CGFloat) -> CGFloat {
        0.5 * (rect.width - b)
    }
    
    private func calcB(rect: CGRect) -> CGFloat {
        2.0 * (rect.midX / 2.0) * CGFloat(tan(angle.degrees / 2.0))
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    var minSize: CGFloat {
        min(width, height)
    }
}


struct IsoscelesTriangle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IsoscelesTriangle(angle: .degrees(360.0 / 1.0))
                .foregroundColor(.blue)
                .padding()
                .previewLayout(.sizeThatFits)
            IsoscelesTriangle(angle: .degrees(360.0 / 8.0))
                .foregroundColor(.green)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
