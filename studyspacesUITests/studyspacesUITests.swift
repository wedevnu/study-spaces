//
//  studyspacesUITests.swift
//  studyspacesUITests
//
//  Created by dilan on 10/27/24.
//

import XCTest

final class studyspacesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testBasicTabBarExists() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test basic UI elements exist
        XCTAssertTrue(app.tabBars.firstMatch.exists, "Tab bar should exist")
        XCTAssertTrue(app.searchFields.firstMatch.exists, "Search field should exist")
        XCTAssertTrue(app.buttons["FilterButton"].exists, "Filter button should exist")
    }

    // Test Navigation Structure
    func testTabBarNavigation() throws {
        // Test each tab bar item exists and is tappable
        XCTAssertTrue(app.tabBars.buttons["Map"].exists)
        XCTAssertTrue(app.tabBars.buttons["Saved"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
        
        app.tabBars.buttons["Saved"].tap()
        // Verify we're on saved view
        XCTAssertTrue(app.navigationBars["Saved Spaces"].exists)
    }
    
    // Test Search Functionality
    func testSearchInteraction() throws {
        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("Library")
        
        // Verify search results appear
        XCTAssertTrue(app.tables["SearchResults"].exists)
    }
    
    // Test Filter Sheet
    func testFilterSheet() throws {
        let filterButton = app.buttons["FilterButton"]
        XCTAssertTrue(filterButton.exists)
        
        filterButton.tap()
        
        // Verify filter sheet elements
        let filterSheet = app.sheets["FilterSheet"]
        XCTAssertTrue(filterSheet.exists)
        XCTAssertTrue(filterSheet.segmentedControls["SpaceType"].exists)
        XCTAssertTrue(filterSheet.sliders["TimeRange"].exists)
    }
    
    // Test Map Interactions
    func testMapInteractions() throws {
        let mapView = app.maps.firstMatch
        XCTAssertTrue(mapView.exists)
        
        // Test pinch to zoom
        mapView.pinch(withScale: 2, velocity: 1)
        mapView.pinch(withScale: 0.5, velocity: -1)
        
        // Test map annotation interaction
        let annotation = mapView.pins.firstMatch
        annotation.tap()
        
        // Verify space detail sheet appears
        XCTAssertTrue(app.sheets["SpaceDetail"].exists)
    }
    
    // Test Space Detail View
    func testSpaceDetailView() throws {
        // Navigate to a space detail
        app.maps.pins.firstMatch.tap()
        
        let detailView = app.sheets["SpaceDetail"]
        XCTAssertTrue(detailView.exists)
        
        // Verify key elements exist
        XCTAssertTrue(detailView.images["SpaceImage"].exists)
        XCTAssertTrue(detailView.staticTexts["SpaceName"].exists)
        XCTAssertTrue(detailView.buttons["SaveSpace"].exists)
    }
    
    // Test Save Space Functionality
    func testSaveSpace() throws {
        // Save a space
        app.maps.pins.firstMatch.tap()
        app.sheets["SpaceDetail"].buttons["SaveSpace"].tap()
        
        // Navigate to saved spaces
        app.tabBars.buttons["Saved"].tap()
        
        // Verify space appears in saved list
        XCTAssertTrue(app.tables["SavedSpaces"].cells.count > 0)
    }
    
    // Test Location Permission Dialog
    func testLocationPermission() throws {
        let locationAlert = app.alerts.firstMatch
        XCTAssertTrue(locationAlert.exists)
        XCTAssertTrue(locationAlert.buttons["Allow"].exists)
        XCTAssertTrue(locationAlert.buttons["Don't Allow"].exists)
    }
    
    // Test Error Handling
    func testNetworkErrorHandling() throws {
        // Simulate no network connection
        // When we setup network handling, this will allows us to check for timeouts/errors
        
        // Verify error alert appears
        XCTAssertTrue(app.alerts["NetworkError"].exists)
        XCTAssertTrue(app.alerts["NetworkError"].buttons["Retry"].exists)
    }
    
    // Performance Test for the filter function
    func testFilterSheetPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let filterButton = app.buttons["FilterButton"]
            filterButton.tap()
            app.sheets["FilterSheet"].buttons["Close"].tap()
        }
    }
}
