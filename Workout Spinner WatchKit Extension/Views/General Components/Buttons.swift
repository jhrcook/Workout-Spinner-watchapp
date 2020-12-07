//
//  Buttons.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 11/11/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct CleanListViewButtonModifications: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(PlainListStyle())
            .listRowPlatterColor(.clear)
    }
}

struct ListViewTextButton: View {
    var text: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.black)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .modifier(CleanListViewButtonModifications())
    }
}

struct ListViewDoneButton: View {
    var text: String = "Done"
    var action: () -> Void
    var verticalTextPadding: CGFloat = 3

    var body: some View {
        Button(action: action) {
            Text(text)
                .bold()
                .padding(.vertical, verticalTextPadding)
                .modifier(DoneButtonText())
        }
        .modifier(CleanListViewButtonModifications())
        .buttonStyle(DoneButtonStyle())
    }
}

struct DoneButton: View {
    var text: String = "Done"
    var action: () -> Void
    var verticalTextPadding: CGFloat = 3

    var body: some View {
        Button(action: action) {
            Text(text)
                .bold()
                .padding(.vertical, verticalTextPadding)
                .modifier(DoneButtonText())
        }
        .buttonStyle(DoneButtonStyle())
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        ListViewTextButton(text: "Button") {}
    }
}
