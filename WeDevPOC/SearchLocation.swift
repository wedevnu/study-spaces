

import Foundation
import SwiftData
import CoreLocation

// This is the model we're using to store search history
@Model
final class SearchLocation: Identifiable {
    @Attribute(.unique) var name: String // The name of the search (like "Snell Library")
    var latitude: Double // Coordinates for the search result
    var longitude: Double
    var timestamp: Date // When the search was performed

    init(name: String, latitude: Double, longitude: Double, timestamp: Date = Date()) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
