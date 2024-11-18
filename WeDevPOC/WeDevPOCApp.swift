// WeDevPOCApp.swift

import SwiftUI
import SwiftData
import Observation

@main
struct WeDevApp: App {
    var manager = StudySpaceManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            SearchLocation.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                StudySpaceListView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                FilterView(manager: manager)
                    .tabItem {
                        Label("Filters", systemImage: "slider.horizontal.3")
                    }
            }
            .environment(manager) 
        }
        .modelContainer(sharedModelContainer)
    }
}
