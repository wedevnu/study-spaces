
import Foundation
import MapKit

// This handles search completion suggestions
class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var completionHandler: ([MKLocalSearchCompletion]) -> Void

    init(completionHandler: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.completionHandler = completionHandler
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // When new results come in, pass them to our handler
        completionHandler(completer.results)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
        completionHandler([]) // If it fails, clear results
    }
}
