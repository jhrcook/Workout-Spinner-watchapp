//
//  Buttons.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/11/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct ListViewTextButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .listStyle(PlainListStyle())
        .listRowPlatterColor(.clear)
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        ListViewTextButton(label: "Button") {}
    }
}
