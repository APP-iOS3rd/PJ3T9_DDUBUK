//
//  MapView.swift
//  Ddubuk
//
//  Created by 조민식 on 1/31/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapMakerView: View {
    let locations: [CLLocationCoordinate2D]
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.574955, longitude: 127.089379), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    init(_ locations: [CLLocationCoordinate2D]) {
        self.locations = locations
    }
    var body: some View {
        Map(initialPosition: .region(MKCoordinateRegion(center: locations[0], span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))) {
            Marker("", coordinate: locations[0])
                .tint(.blue)
            MapPolyline(coordinates: locations)
                .stroke(.blue, lineWidth: 3.0)
        }
    }
}

#Preview {
    MapMakerView([
        CLLocationCoordinate2D(latitude: 37.574955, longitude: 127.089379),
        CLLocationCoordinate2D(latitude: 37.574667, longitude: 127.089260),
        CLLocationCoordinate2D(latitude: 37.574072, longitude: 127.088965),
        CLLocationCoordinate2D(latitude: 37.573698, longitude: 127.088775),
        CLLocationCoordinate2D(latitude: 37.573203, longitude: 127.088884)
    ])
}
