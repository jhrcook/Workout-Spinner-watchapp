//
//  NumericType.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 1/28/21.
//  Copyright © 2021 Joshua Cook. All rights reserved.
//

import Foundation

protocol NumericType: Comparable {
    static func + (lhs: Self, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self) -> Self
    static func * (lhs: Self, rhs: Self) -> Self
    static func / (lhs: Self, rhs: Self) -> Self
}

extension Double: NumericType {}
extension Int: NumericType {}
