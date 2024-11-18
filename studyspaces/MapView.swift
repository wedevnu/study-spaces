//
//  MapView.swift
//  studyspaces
//
//  Created by Josh Cho on 11/12/24.
//

// Import required frameworks
import MapKit  // For map functionality
import SwiftUI // For UI components

// MARK: - MapView Extension (Helper Functions)
extension MapView {
    // Clears the current route and resets map state
    func clearRoute() {
        withAnimation(.easeInOut) {
            routeDisplaying = false     // Hide the route display
            route = nil                 // Remove the route data
            routeDestination = nil      // Clear the destination
            mapSelection = nil          // Clear the selected location
            cameraPosition = .region(.userRegion)  // Reset camera to default view
        }
    }
    
    // Performs location search based on user input
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText  // Set search query from user input
        request.region = .userRegion              // Set search region to current map view
        
        // Perform search and update results
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []    // Update results, empty array if search fails
    }
    
    // Calculate and display route to selected destination
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))  // Start from user location
            request.destination = mapSelection     // End at selected location
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first      // Get the primary route
                routeDestination = mapSelection   // Save destination
                
                withAnimation(.snappy) {
                    routeDisplaying = true        // Show the route
                    showDetails = false           // Hide detail sheet
                    
                    // Adjust camera to show the entire route
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}

// MARK: - Location Extensions
extension CLLocationCoordinate2D {
    // Set default user location to Northeastern University
    // Coordinates for Northeastern's campus center
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 42.339918, longitude: -71.089797)
    }
}

extension MKCoordinateRegion {
    // Define default map region centered on Northeastern
    static var userRegion: MKCoordinateRegion {
        return .init(
            center: .userLocation,
            latitudinalMeters: 1000,     // Initial zoom level - smaller for campus view
            longitudinalMeters: 1000      // Keep aspect ratio square
        )
    }
}

// MARK: - Main MapView Structure
struct MapView: View {
    // MARK: - State Variables
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)  // Controls map view position
    @State private var searchText = ""           // Holds search input text
    @State private var results = [MKMapItem]()   // Stores search results
    @State private var mapSelection: MKMapItem?  // Currently selected location
    @State private var showDetails = false       // Controls detail sheet visibility
    @State private var getDirections = false     // Triggers route calculation
    @State private var routeDisplaying = false   // Controls route visibility
    @State private var route: MKRoute?           // Stores active route
    @State private var routeDestination: MKMapItem?  // Stores route destination
    
    // MARK: - View Body
    var body: some View {
        // Main map view configuration
        Map(position: $cameraPosition, selection: $mapSelection) {
            
            // Custom annotation for user location
            Annotation("Your Location", coordinate: .userLocation) {
                ZStack {
                    // Outer blue circle (halo effect)
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue.opacity(0.25))
                    
                    // Middle white circle
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                    // Inner blue circle (location dot)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.blue)
                }
            }
            
            // Display markers for search results
            ForEach(results, id: \.self) { item in
                if routeDisplaying {
                    // Only show destination marker when displaying route
                    if item == routeDestination {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                } else {
                    // Show all result markers when not displaying route
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }
            }
            
            // Display route line if available
            if let route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        // MARK: - Overlays
        // Search bar overlay at top
        .overlay(alignment: .top) {
            TextField("Search for a location...", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 10)
                .onChange(of: searchText) { oldValue, newValue in
                    if newValue.isEmpty {
                        results = []    // Clear results when search is empty
                    }
                }
        }
        // Control buttons overlay at bottom-right
        .overlay(alignment: .bottomTrailing) {
            VStack {
                // Clear route button (only shown when route is displayed)
                if routeDisplaying {
                    Button(action: clearRoute) {
                        Image(systemName: "xmark.circle.fill")
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 8)
                }
                
                // Recenter to user location button
                Button(action: {
                    cameraPosition = .region(.userRegion)
                }) {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .padding()
        }
        
        // MARK: - Event Handlers
        // Trigger search when user submits
        .onSubmit(of: .text) {
            Task { await searchPlaces() }
        }
        // Handle get directions request
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
                getDirections = false    // Reset after fetching route
            }
        })
        // Show location details when selection changes
        .onChange(of: mapSelection, { oldValue, newValue in
            showDetails = newValue != nil
        })
        // Location details sheet
        .sheet(isPresented: $showDetails, content: {
            DetailSheetView(mapSelection: $mapSelection,
                              show: $showDetails,
                              getDirections: $getDirections)
                .presentationDetents([.height(340)])    // Set sheet height
                .presentationBackgroundInteraction(.enabled(upThrough:.height(340)))
                .presentationCornerRadius(12)
        })
        // Add compass to map
        .mapControls {
            MapCompass()    // Shows when map is rotated
        }
    }
}

// SwiftUI preview provider
#Preview {
    MapView()
}
