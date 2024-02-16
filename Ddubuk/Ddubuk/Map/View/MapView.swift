//
//  MapView.swift
//  Ddubuk
//
//  Created by 조민식 on 2/13/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Firebase

struct MapView: View {
    
    @ObservedObject var routes = FireStoreManager.shared
    @State private var selection: UUID?
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        ZStack {
            //
            Map(coordinateRegion: $region, showsUserLocation: true)
        }
        .onAppear {
            routes.fetchRoutes()
            print("dfdf")
        }
    }
}

#Preview {
    MapView()
}
