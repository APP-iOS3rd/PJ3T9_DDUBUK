//
//  LocationManager.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/22.
//

import Foundation
import CoreLocation
import FirebaseFirestore




class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var currentLocation: GeoPoint = GeoPoint(latitude: 0, longitude: 0)
    private var isUpdatingLocation = false
    private let locationManager = CLLocationManager()
    private var timer: Timer? = nil
    private let interval: TimeInterval = 5.0 // 5 seconds
    private var information: String = ""
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, isUpdatingLocation else { return }
        self.currentLocation = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.saveLocation(location)
    }
    
    private var coordinates: [[String: Any]] = []

        private func saveLocation(_ location: CLLocation) {
            guard !self.information.isEmpty else { return }
            
            let newCoordinateData: [String: Any] = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude,
                "timestamp": Timestamp(date: Date()).dateValue()
            ]
            
            coordinates.append(newCoordinateData)
        }
    
    
    func startTimer() {
        guard !isUpdatingLocation else { return }
        isUpdatingLocation = true
        self.locationManager.startUpdatingLocation()
        self.timer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true) { [weak self] _ in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    func stopTimer() {
        isUpdatingLocation = false
        self.timer?.invalidate()
        self.timer = nil
        self.locationManager.stopUpdatingLocation()
        
        if !self.information.isEmpty {
            let docData: [String: Any] = [
                "information": self.information,
                "coordinates": coordinates
            ]
            let route = Route(from: docData)
            FireStoreManager.shared.addRoute(docName: self.information, route: route)
        }
    }
    
    func updateInformation(info: String) {
        self.information = info
    }
    
    func resetData() {
            coordinates = []
            information = ""
        }
}
