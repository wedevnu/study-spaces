//
//  MapViewViewModel.swift
//  studyspaces
//
//  Created by Josh Cho on 11/17/24.
//

import Foundation
import MapKit

class MapViewViewModel: ObservableObject {
    @Published var cameraPosition: MKCoordinateRegion = .userRegion
    
    public enum Action {
        case clearRoute
        case searchPlaces(String)
        case fetchRoute
    }
    
    func perform(action: Action) async {
        switch action {
            case .clearRoute:
                clearRoute()
            case .searchPlaces(let searchText):
            await searchPlaces()
            case .fetchRoute:
                fetchRoute()
        }
    }
    
    func clearRoute() {
//        withAnimation(.easeInOut) {

//        route = nil
//        routeDestination = nil
//        mapSelection = nil
        cameraPosition = .userRegion
//        }
    }
    
    func searchPlaces() async {
        return
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchText
//        request.region = .userRegion
//        
//        //This line populates the 'results' array with MKMapItems
//        // Each MKMapItem represents a location that matches the searcy query
//        let results = try? await MKLocalSearch(request: request).start()
//        self.results = results?.mapItems ?? []
        
        
    }
    
    func fetchRoute() {
        return
//        if let mapSelection {
//            let request = MKDirections.Request()
//            request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
//            request.destination = mapSelection
//            
//            Task {
//                let result = try? await MKDirections(request: request).calculate()
//                route = result?.routes.first
//                routeDestination = mapSelection
//                
//                withAnimation(.snappy) {
//                    routeDisplaying = true
//                    showDetails = false
//                    
//                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
//                        cameraPosition = .rect(rect)
//                    }
//                }
//            }
//        }
    }
}
