//
//  mapView.swift
//  Ddubuk
//
//  Created by 조민식 on 1/18/24.
//
import SwiftUI
import MapKit
import CoreLocation

struct MyLocation: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let locations: [CLLocationCoordinate2D]
    let address: String
    
    static func == (lhs: MyLocation, rhs: MyLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MapView: View {
    
    @State private var selection: UUID?
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.575000, longitude: 127.089390), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))), selection: $selection) {
                ForEach(mapViewModel.myLocations) { location in
                    Marker("", coordinate: location.coordinate)
                        .tint(.blue)
                }
                if let selection {
                    if let item = mapViewModel.myLocations.first(where: { $0.id == selection }) {
                        MapPolyline(coordinates: item.locations)
                            .stroke(.blue, lineWidth: 3.0)
                    }
                }
            }
            VStack {
                Spacer()
                
                if let selection {
                    if let item = mapViewModel.myLocations.first(where: { $0.id == selection }) {
                        RoundedRectangle(cornerRadius: 10)
                            .padding([.bottom, .horizontal])
                            .frame(width: 350, height: 150)
                            .foregroundColor(.white)
                            .overlay(
                                MapMarkerDetail(selectedResult: item)
                                    .frame(height: 128)
                                    
                            )
                    }
                }
            }
        }
    }
}
