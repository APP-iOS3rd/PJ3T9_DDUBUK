//
//  Coordinator.swift
//  Ddubuk
//
//  Created by lkh on 1/22/24.
//

import SwiftUI
import MapKit

// MARK: - Coordinator
class Coordinator: NSObject, MKMapViewDelegate {
    var mkView: RecordMap
    
    init(_ mkView: RecordMap) {
        self.mkView = mkView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .green
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
