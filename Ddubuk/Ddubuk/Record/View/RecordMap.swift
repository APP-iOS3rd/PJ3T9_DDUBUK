//
//  RecordMapView.swift
//  Ddubuk
//
//  Created by lkh on 1/22/24.
//

import SwiftUI
import MapKit

// MARK: - RecordMap
struct RecordMap: UIViewRepresentable {
    // MARK: - 프로퍼티s
    var userLocations: [CLLocationCoordinate2D]
    var isRecording: Bool
    var timerState: TimerState
    var route: Route?
    var locationManager: LocationManager?

    // MARK: - makeUIView
    // 뷰가 그려질 때 호출
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    // MARK: - updateUIView
    // 변경 시 업데이트 뷰
    func updateUIView(_ uiView: MKMapView, context: Context) {
            uiView.removeOverlays(uiView.overlays)
            
            // 사용자 위치 업데이트 로직
            if isRecording && userLocations.count > 1 {
                let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
                uiView.addOverlay(polyline)
                
                if let lastLocation = userLocations.last {
                    let region = MKCoordinateRegion(center: lastLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                    uiView.setRegion(region, animated: true)
                }
            }
            
            // Route 객체가 있을 경우
            if let route = route {
                let locations = route.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                let polyline = MKPolyline(coordinates: locations, count: locations.count)
                uiView.addOverlay(polyline)
                uiView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
            }
            
            // LocationManager 객체를 사용하는 경우
            if let locationManager = locationManager, let currentLocation = locationManager.currentLocation {
                let center = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
                uiView.setRegion(region, animated: true)
            }
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    }
