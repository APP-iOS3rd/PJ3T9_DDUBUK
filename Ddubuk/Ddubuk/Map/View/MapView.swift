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
    @State private var currentPosition: CLLocationCoordinate2D?
    @State private var selection: UUID?
    @State private var position: MapCameraPosition = .automatic
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var viewModel: RecordViewModel
    
    var body: some View {
        ZStack {
            //
            Map(position: $position, selection: $selection) {
//                if let currentPosition = currentPosition {
//                    Marker("marker", coordinate: currentPosition)
//                }
                ForEach(routes.routes) { location in
//                    Marker("", image: "mapmarker",coordinate: CLLocationCoordinate2D(latitude: location.coordinates[0].latitude, longitude: location.coordinates[0].longitude))
//                        .tint(Color.MainColor)
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: location.coordinates[0].latitude, longitude: location.coordinates[0].longitude)) {
                        Image("mapmarker")
                            .resizable()
                            .frame(width: 30, height: 30)
                            
                    }
                    .tint(Color.MainColor)
                
                    
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
            VStack {
                Spacer()
                
                if let selection {
                    
                    if let item = routes.routes.first(where: { $0.id == selection }) {
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.bottom)
                            .frame(width: 360, height: 165)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                            .overlay (
                                MapMarkerDetail(seletedResult: item)
                                    .frame(width: 395,height: 182)
                                    .padding(.bottom)
                            )
                    }
                }
            }
        }
        .onAppear {
            routes.fetchRoutes()
            locationManager.getCurrentLocation()
        }
        .onChange(of: locationManager.currentLocation) {
            if let lat = locationManager.currentLocation?.latitude, let lon = locationManager.currentLocation?.longitude {
                self.currentPosition = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                position = .item(MKMapItem(placemark: .init(coordinate: currentPosition!)))
            }
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
