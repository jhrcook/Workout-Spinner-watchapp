//
//  GeometryProxy-extension.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/2/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

extension GeometryProxy {
    var minSize: CGFloat {
        return min(size.width, size.height)
    }
}
