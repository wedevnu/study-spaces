
import SwiftUI
import Observation

struct FilterView: View {
    @Bindable var manager: StudySpaceManager

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Type of Space")) {
                    Picker("Select Type", selection: $manager.selectedType) {
                        ForEach(StudySpace.SpaceType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Time Range")) {
                    DatePicker("Select Time", selection: .constant(Date()),
                               displayedComponents: .hourAndMinute)
                }

                Section(header: Text("Preferences")) {
                    Toggle("Quiet", isOn: $manager.isQuiet)
                    Toggle("Food Available", isOn: $manager.hasFood)
                }
            }
            .navigationTitle("Filters")
        }
    }
}


