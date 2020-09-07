//
//  Settings.swift
//  Workout Spinner WatchKit Extension
//
//  Created by Joshua on 9/7/20.
//  Copyright © 2020 Joshua Cook. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    let imageName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
        }
    }
}

struct Settings: View {
    
    @State private var selectedExerciseIntensity = UserDefaults.standard.integer(forKey: UserDefaultsKeys.exerciseIntensityInt.rawValue)
    
    
    private var exerciseIntensities: [String] {
        var a = [String]()
        for ei in ExerciseIntensity.allCases {
            a.append(ei.rawValue)
        }
        return a
    }
    
    var body: some View {
        Form {
            Section(header: SectionHeader(imageName: "flame", text: "Exercise")) {
                Picker(selection: $selectedExerciseIntensity, label: Text("Intensity")) {
                    ForEach(0..<exerciseIntensities.count) { idx in
                        Text(self.exerciseIntensities[idx])
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .labelsHidden()
                
                NavigationLink(destination: Text("Whitelist")) {
                    HStack {
                        Text("Muscle groups")
                        Spacer()
                        Image(systemName: "chevron.right").opacity(0.5)
                    }
                }
            }
            
            Section(header: SectionHeader(imageName: "info.circle", text: "About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("0.0.0.9000")
                }
            }
        }
        .onDisappear() {
            self.saveUserDefualts()
        }
    }
}



extension Settings {
    func saveUserDefualts() {
        UserDefaults.standard.set(self.selectedExerciseIntensity,
        forKey: UserDefaultsKeys.exerciseIntensityInt.rawValue)
    }
}




struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
