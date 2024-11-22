// StudySpaceDetailView.swift

import SwiftUI

struct StudySpaceDetailView: View {
    let space: StudySpace

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(space.name)
                    .font(.largeTitle)
                Text(space.location)
                    .font(.title2)
                HStack {
                    Text("⭐️ \(space.rating, specifier: "%.1f")")
                    Spacer()
                    Text(space.isOpen ? "Open" : "Closed")
                        .foregroundColor(space.isOpen ? .green : .red)
                }
                Divider()
                Text("Reviews (\(space.reviews))")
                    .font(.headline)
                ForEach(0..<5) { _ in
                    Text("This is a review...")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
    }
}

