// StudySpaceListView.swift

import SwiftUI
import Observation

struct StudySpaceListView: View {
    @Environment(StudySpaceManager.self) var manager

    var body: some View {
        NavigationStack {
            List(manager.filteredSpaces) { space in
                NavigationLink(destination: StudySpaceDetailView(space: space)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(space.name)
                                .font(.headline)
                            Text(space.location)
                                .font(.subheadline)
                            Text("⭐️ \(space.rating, specifier: "%.1f") (\(space.reviews) reviews)")
                                .font(.caption)
                        }
                        Spacer()
                        Text(space.isOpen ? "Open" : "Closed")
                            .foregroundColor(space.isOpen ? .green : .red)
                    }
                }
            }
            .navigationTitle("Suggested Spaces")
        }
    }
}

