//
//  PageManager.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 10/26/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct PagerManager<Content: View>: View {
    let pageCount: Int
    @Binding var currentPageIndex: Int
    let content: Content
    
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentPageIndex = currentIndex
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                content.frame(width: geo.size.width)
            }
            .frame(width: geo.size.width, alignment: .leading)
            .offset(x: -CGFloat(currentPageIndex) * geo.size.width)
        }
    }
}
