
import SwiftUI
import MapKit
import Observation
import SwiftData

// Our main view to show the map and search functionality
struct MapView: View {
    @Environment(StudySpaceManager.self) var manager
    @Environment(\.modelContext) private var modelContext // Gotta grab the model context for SwiftData stuff
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3401, longitude: -71.0894), // Starting point, Northeastern area
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Just a bit zoomed in
    )
    
    // State vars for search stuff
    @State private var searchText = "" // holds whatever's in the search bar
    @State private var searchResults: [MKLocalSearchCompletion] = [] // This is where we store the suggestions
    @State private var isSearching = false
    @FocusState private var isSearchFieldFocused: Bool // handles whether search bar is focused or not

    @Query(sort: \SearchLocation.timestamp, order: .reverse) private var storedLocations: [SearchLocation] // fetch stored searches, newest first

    private var searchCompleter = MKLocalSearchCompleter()
    @State private var searchCompleterDelegate: SearchCompleterDelegate? // handles updates from the search completer

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // The search bar at the top
                    TextField("Search for a place", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: searchText) { _ in
                            // update search suggestions as user types
                            searchCompleter.queryFragment = searchText
                        }
                        .focused($isSearchFieldFocused)
                    
                    // Only show the Cancel button if user is searching
                    if isSearching {
                        Button("Cancel") {
                            // Reset search
                            searchText = ""
                            isSearching = false
                            searchResults = []
                            isSearchFieldFocused = false
                        }
                    }
                }
                .padding()

                // Display either search results or stored history
                List {
                    if searchResults.isEmpty && isSearchFieldFocused && !searchText.isEmpty {
                        Text("No results")
                    } else if isSearchFieldFocused && searchText.isEmpty {
                        // Show search history from SwiftData
                        ForEach(storedLocations) { location in
                            Button(action: {
                                // When a history item is tapped, update the map
                                region = MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                                isSearching = false
                                searchText = ""
                                isSearchFieldFocused = false

                                // Refresh timestamp to move it to the top of history list
                                location.timestamp = Date()
                            }) {
                                Text(location.name)
                            }
                        }
                    } else {
                        // Show real-time search suggestions
                        ForEach(searchResults, id: \.title) { result in
                            Button(action: {
                                search(for: result)
                            }) {
                                Text(result.title)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .opacity(isSearchFieldFocused ? 1 : 0)

                // Show the actual map
                Map(coordinateRegion: $region, annotationItems: manager.filteredSpaces) { space in
                    MapAnnotation(coordinate: space.coordinate) {
                        NavigationLink(destination: StudySpaceDetailView(space: space)) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                    }
                }
                .ignoresSafeArea()
            }
            .navigationTitle("Study Spaces")
            .onAppear {
                setupSearchCompleter() // set up the search completer delegate
            }
        }
    }

    private func setupSearchCompleter() {
        searchCompleterDelegate = SearchCompleterDelegate { completions in
            // Every time new suggestions come in, we update our searchResults
            self.searchResults = completions
        }
        searchCompleter.delegate = searchCompleterDelegate
    }

    private func search(for completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, error in
            if let coordinate = response?.mapItems.first?.placemark.coordinate {
                // Update the map region when a search result is chosen
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                isSearching = false
                searchText = ""
                searchResults = []
                isSearchFieldFocused = false

                // Save this search to SwiftData
                let locationName = completion.title
                let newSearchLocation = SearchLocation(
                    name: locationName,
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
                modelContext.insert(newSearchLocation)
                do {
                    try modelContext.save() // save the new search
                } catch {
                    print("Failed to save search: \(error)")
                }
            }
        }
    }
}
