//
//  DetailSheetView.swift
//  studyspaces
//
//  Created by Josh Cho on 11/12/24.
//

// Required frameworks
import SwiftUI    // For UI components
import MapKit     // For map and location functionality

// Main view for displaying details about selected location
struct DetailSheetView: View {
    // Bindings to communicate with parent view
    @Binding var mapSelection: MKMapItem?    // Selected location on the map
    @Binding var show: Bool                  // Controls sheet visibility
    @State private var lookAroundScene: MKLookAroundScene?    // Stores Apple's street view like preview
    @Binding var getDirections: Bool         // Triggers navigation
    
    var body: some View {
        VStack {
            // Header section with location name and close button
            HStack {
                VStack(alignment: .leading) {
                    // Location name in large text
                    Text(mapSelection?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    // Location address in smaller, gray text
                    Text(mapSelection?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                    
                Spacer()
                    
                // Close button (X) in top right
                Button {
                    show = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Look Around preview section (similar to Google Street View)
            if let scene = lookAroundScene {
                // Display Look Around preview if available
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .cornerRadius(12)
                    .padding()
            } else {
                // Show placeholder when preview is unavailable
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
            
            // Action buttons container
            HStack(spacing: 24) {
                // Open in Maps button
                Button {
                    if let mapSelection {
                        mapSelection.openInMaps()    // Opens location in Apple Maps
                    }
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .cornerRadius(12)
                }
                
                // Get Directions button
                Button {
                    getDirections = true     // Trigger navigation
                    show = false             // Dismiss sheet
                } label: {
                    Text("Get Directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
        // Fetch Look Around preview when view appears
        .onAppear {
            print("DEBUG: Did Call on appear")
            fetchLookAroundPreview()
        }
        // Refresh Look Around preview when selected location changes
        .onChange(of: mapSelection) { oldValue, newValue in
            print("DEBUG: Did call on change")
            fetchLookAroundPreview()
        }
    }
}

// MARK: - Helper Methods
extension DetailSheetView {
    // Fetches Look Around preview for selected location
    func fetchLookAroundPreview() {
        if let mapSelection {
            lookAroundScene = nil    // Clear existing preview
            Task {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene    // Fetch new preview asynchronously
            }
        }
    }
}

// Preview provider for SwiftUI canvas
#Preview {
    DetailSheetView(mapSelection: .constant(nil), show: .constant(false), getDirections: .constant(false))
}
