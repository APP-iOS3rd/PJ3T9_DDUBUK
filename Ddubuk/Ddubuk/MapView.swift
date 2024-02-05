//
//  MapView.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

//import UIKit
//import SwiftUI
//import MapKit
//
//struct MapView: UIViewRepresentable {
//    var route: Route?
//    var locationManager: LocationManager?
//    
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.removeOverlays(uiView.overlays)
//        
//        if let route = route {
//            // Route 기반으로 지도 업데이트
//            let locations = route.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
//            let polyline = MKPolyline(coordinates: locations, count: locations.count)
//            uiView.addOverlay(polyline)
//            uiView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
//        } else if let locationManager = locationManager {
//            // LocationManager 기반으로 지도 업데이트
//            guard let currentLocation = locationManager.currentLocation else { return }
//            let center = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
//            let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
//            uiView.setRegion(region, animated: true)
//        }
//    }
//    
//}
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//}


