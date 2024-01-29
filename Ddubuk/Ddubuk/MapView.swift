//
//  MapViewTest.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/23.
//
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
        if let location = locations.last {
            self.locations.append(location)
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)

            let polyline = MKPolyline(coordinates: self.locations.map { $0.coordinate }, count: self.locations.count)
            mapView.addOverlay(polyline)
        }
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

struct MapView: UIViewControllerRepresentable {
    @Binding var route: Route?
    
    func makeUIViewController(context: Context) -> MapViewController {
        let mapViewController = MapViewController()
        mapViewController.route = route
        return mapViewController
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        uiViewController.route = route
    }
}
