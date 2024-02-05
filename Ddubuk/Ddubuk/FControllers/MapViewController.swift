//
//  MapViewController.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import UIKit
import SwiftUI
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var locations: [CLLocation] = []
    
    var route: Route? {
        didSet {
            drawRoute()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        view = mapView
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapCenter(_:)), name: NSNotification.Name("UpdateMapCenter"), object: nil)
    }
    
    @objc func updateMapCenter(_ notification: Notification) {
        if let userInfo = notification.userInfo, let newCenter = userInfo["newCenter"] as? CLLocationCoordinate2D {
            let region = MKCoordinateRegion(center: newCenter, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func startTrackingUser() {
        self.locations.removeAll() // 경로 추적을 시작하기 전에 기존 경로를 제거합니다.
        locationManager.startUpdatingLocation()
    }
    
    func stopTrackingUser() {
        locationManager.stopUpdatingLocation()
        drawRoute() // 사용자의 이동 경로를 그립니다.
    }
    
    func drawRoute() {
        guard let route = route else { return }
        
        // 기존의 경로를 제거합니다.
        mapView.removeOverlays(mapView.overlays)
        
        // 새로운 경로를 그립니다.
        let coordinates = route.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        
        // 경로가 있는 영역을 확대하여 보여줍니다.
        mapView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 콘솔에 위치 정보 출력
        print("위치 업데이트: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        // 새 위치를 locations 배열에 추가합니다.
        self.locations.append(location)
        
        // 사용자의 현재 위치로 지도의 중심을 이동합니다.
        NotificationCenter.default.post(name: NSNotification.Name("UpdateMapCenter"), object: nil, userInfo: ["newCenter": location.coordinate])
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}
