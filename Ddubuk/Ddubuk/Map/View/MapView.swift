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
    @State private var position: MapCameraPosition = .automatic
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var viewModel: RecordViewModel
    
    var body: some View {
        ZStack {
            //
            Map(initialPosition: position, selection: $selection) {
                ForEach(routes.routes) { location in
                    Marker("", coordinate: CLLocationCoordinate2D(latitude: location.coordinates[0].latitude, longitude: location.coordinates[0].longitude))
                        .tint(.blue)
                    
                }
                
                if let selection {
                    if let item = routes.routes.first(where: { $0.id == selection }) {
                        //                        ForEach(item.coordinates) { coordinate in
                        //                            locations.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
                        //                        }
                        let coordinates = item.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                        MapPolyline(coordinates: coordinates)
                            .stroke(.blue, lineWidth: 3.0)
                    }
                }
            }
        }
        VStack {
            Spacer()
            
            if let selection {
               
                if let item = routes.routes.first(where: { $0.id == selection }) {
                    RoundedRectangle(cornerRadius: 10)
                        .padding([.bottom, .horizontal])
                        .frame(width: 350, height: 150)
                        .foregroundColor(.white)
                        .overlay (
                            MapMarkerDetail(seletedResult: item)
                                .frame(height: 128)
                        )
                }
            }
        }
        .onAppear {
            routes.fetchRoutes()
        }
    }
        
}



//func changeToCLL2D(_ location: [Coordinate]){
//    location.forEach { coordinate in
//        location.append(CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
//    }


#Preview {
    MapView()
}
