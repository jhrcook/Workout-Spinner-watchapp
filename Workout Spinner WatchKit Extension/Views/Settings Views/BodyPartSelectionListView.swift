//
//  BodyPartSelectionListView.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct BodyPartSelectionListView: View {
    @ObservedObject var bodyparts = BodyPartSelections(with: .userDefaults)

    var body: some View {
        List {
            ForEach(0 ..< bodyparts.bodyparts.count) { i in
                HStack {
                    Toggle(isOn: self.$bodyparts.bodyparts[i].enabled) {
                        Text(self.bodyparts.bodyparts[i].bodypart.rawValue.capitalized)
                    }
                }
            }
            ListViewDoneButton(text: "Save") {
                self.bodyparts.saveDataToUserDefaults()
            }
        }
    }
}

struct BodyPartSelectionListView_Previews: PreviewProvider {
    static var previews: some View {
        BodyPartSelectionListView()
    }
}
