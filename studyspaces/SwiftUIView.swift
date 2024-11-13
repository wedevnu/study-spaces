//
//  SwiftUIView.swift
//  studyspaces
//
//  Created by Josh Cho on 11/12/24.
//
import MapKit
import SwiftUI


extension SwiftUIView {
    func clearRoute() {
        withAnimation(.easeInOut) {
            routeDisplaying = false
            route = nil
            routeDestination = nil
            mapSelection = nil
            cameraPosition = .region(.userRegion)
        }
    }
    
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = .userRegion
        
        //This line populates the 'results' array with MKMapItems
        // Each MKMapItem represents a location that matches the searcy query
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
        
        
    }
    
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
            request.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                routeDestination = mapSelection
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}


extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 25.7602, longitude: -80.1959)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
    }
}


struct SwiftUIView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    
    var body: some View {
        Map(position: $cameraPosition, selection: $mapSelection) {
//            Marker("My location", systemImage: "paperplane", coordinate: .userLocation).tint(.blue)
            
            // blue circle that indicating my current location
            Annotation("Your Location", coordinate: .userLocation) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue.opacity(0.25))
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.blue)
                }
            }
            
            ForEach(results, id: \.self) { item in
                if routeDisplaying {
                    if item == routeDestination {
                        let placemark = item.placemark
                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    }
                } else {
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                }

            }
            
            if let route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .overlay(alignment: .top) {
            TextField("Search for a location...", text: $searchText)
                .font(.subheadline)
                .padding(12)
                .background(.white)
                .padding()
                .shadow(radius: 10)
                .onChange(of: searchText) { oldValue, newValue in
                    if newValue.isEmpty {
                        // Clear results immediately when search text is empty
                        results = []
                    }
                }
        }
        .overlay(alignment: .bottomTrailing) {
            VStack {
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
                
                // Existing location reset button
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
        .onSubmit(of: .text) {
            //This triggers the search when the user submits the search text
            Task { await searchPlaces() }
        }
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
                getDirections = false // Reset getDirections after fetching the route
            }
        })
        .onChange(of: mapSelection, { oldValue, newValue in
            showDetails = newValue != nil
        })
        .sheet(isPresented: $showDetails, content: {
            LocationDetailsView(mapSelection: $mapSelection,
                                show: $showDetails,
                                getDirections: $getDirections)
                .presentationDetents([.height(340)])
                .presentationBackgroundInteraction(.enabled(upThrough:.height(340)))
                .presentationCornerRadius(12)
        })
        .mapControls {
            MapCompass()
        }
    }
}

#Preview {
    SwiftUIView()
}
