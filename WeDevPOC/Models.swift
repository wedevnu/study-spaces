// StudySpaceManager.swift

import SwiftData
import Observation
import Foundation
import MapKit

@Observable
class StudySpaceManager {
    var studySpaces: [StudySpace] = []
    var selectedType: StudySpace.SpaceType = .any // defaults to 'Any Space'
    var isQuiet: Bool = false
    var hasFood: Bool = false

    init() {
        Task {
            await fetchSpaces()
        }
    }

    func fetchSpaces() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        self.studySpaces = [
            StudySpace(
                name: "Snell Library",
                location: "1st Floor",
                rating: 4.5,
                isOpen: true,
                reviews: 120,
                type: .campus,
                coordinate: CLLocationCoordinate2D(latitude: 42.3389, longitude: -71.0887),
                isQuiet: true,
                hasFood: false
            ),
            StudySpace(
                name: "Curry Student Center",
                location: "3rd Floor",
                rating: 4.0,
                isOpen: false,
                reviews: 85,
                type: .campus,
                coordinate: CLLocationCoordinate2D(latitude: 42.3395, longitude: -71.0883),
                isQuiet: false,
                hasFood: true
            ),
            StudySpace(
                name: "Boston Public Library",
                location: "Copley Square",
                rating: 4.7,
                isOpen: true,
                reviews: 230,
                type: .offsite,
                coordinate: CLLocationCoordinate2D(latitude: 42.3493, longitude: -71.0785),
                isQuiet: true,
                hasFood: false
            )
            
        ]
    }

    var filteredSpaces: [StudySpace] {
        studySpaces.filter { space in
            (selectedType == .any || space.type == selectedType) &&
            (!isQuiet || space.isQuiet) &&
            (!hasFood || space.hasFood)
        }
    }
}


struct StudySpace: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let rating: Double
    let isOpen: Bool
    let reviews: Int
    let type: SpaceType
    let coordinate: CLLocationCoordinate2D
    let isQuiet: Bool
    let hasFood: Bool

    enum SpaceType: String, CaseIterable, Identifiable {
        case any = "Any Space"
        case campus = "Campus"
        case offsite = "Offsite"

        var id: String { self.rawValue }
    }
}


