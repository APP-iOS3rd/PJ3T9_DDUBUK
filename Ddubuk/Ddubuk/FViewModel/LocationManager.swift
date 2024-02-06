//
//  LocationManager.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var currentLocation: Coordinate?
    @Published var durationString: String = ""
    @Published var distanceTraveled: Double = 0
    @Published var tempDistanceTraveled: Double = 0
    
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var isUpdatingLocation = false
    private var timer: Timer? = nil
    private let interval: TimeInterval = 5.0 // 5 seconds
    private var startTime: Date?
    private var endTime: Date?
    public var title: String = ""
    public var address: String? = nil
    public var memo: String = ""
    
    public var imageUrl: URL? = nil
    public var selectedTypes: [WalkingType] = []
    
    // 임시 경로 데이터 저장
    var tempCoordinates: [Coordinate] = []
    var tempDurationString: String = ""
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10 // 10미터 이상 이동할떄마다 위치업데이트를 받음
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // 10미터 이내 정확도
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            
        print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
            if let lastLocation = lastLocation {
                let distance = location.distance(from: lastLocation)
                distanceTraveled += distance
            }
            
            lastLocation = location
            
            let newCoordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: Date())
            self.currentLocation = newCoordinate
            self.saveLocation(location)
            
            // 임시로 현재 위치를 tempCoordinate에 저장
            let temp = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: Date())
            tempCoordinates.append(temp)
            
            // 필요한 처리를 한 후에 currentLocation 업데이트
            self.currentLocation = temp
            self.saveLocation(location)
        }
    
    public var coordinates: [Coordinate] = []
    
    private func saveLocation(_ location: CLLocation) {
        let newCoordinate = Coordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            timestamp: Date() // 현재 시간을 할당
        )
        coordinates.append(newCoordinate)
    }
    
    func resumeLocationUpdates() {
        guard !isUpdatingLocation else { return }
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
        // 필요한 경우 타이머 재설정
//        self.timer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true) { [weak self] _ in
//            self?.locationManager.startUpdatingLocation()
//        }
    }
    func startTimer() {
        guard !isUpdatingLocation else { return }
        isUpdatingLocation = true
        startTime = Date() // 타이머 시작 시간을 기록
        self.timer = Timer.scheduledTimer(withTimeInterval: self.interval, repeats: true) { [weak self] _ in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    func stopTimer() {
            guard isUpdatingLocation, let startTime = self.startTime else { return }
            isUpdatingLocation = false
            endTime = Date() // 타이머 종료 시간을 기록
            self.timer?.invalidate()
            self.timer = nil
            self.locationManager.stopUpdatingLocation()
            
            let durationSeconds = Int(endTime!.timeIntervalSince(startTime))
            let minutes = durationSeconds / 60
            let seconds = durationSeconds % 60
            self.durationString = String(format: "%02d:%02d", minutes, seconds)
            
            // 임시 이동 거리 저장
            self.tempDistanceTraveled = self.distanceTraveled
        }
    
    
    func updateTitle(title: String) {
        self.title = title
    }
    
    func updateMemo(memo: String) {
        self.memo = memo
    }
    
    func resetData() {
        coordinates = []
        tempCoordinates = []
        title = ""
        imageUrl = nil
        address = nil
        memo = ""
        durationString = ""
        tempDurationString = ""
        selectedTypes = []
        
        // 타이머 관련 프로퍼티 초기화
        self.timer?.invalidate()
        self.timer = nil
        self.startTime = nil
        self.endTime = nil
        self.isUpdatingLocation = false
    }
    
    func resetTimer() {
        self.timer?.invalidate()
        self.timer = nil
        self.startTime = nil
        self.endTime = nil
        self.durationString = "00:00"
    }
    
    func changeToClLocation(latitude: Double?, longitude: Double?) -> CLLocation? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static func changeToAddress(location: CLLocation?, completion: @escaping (String) -> Void) {
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                if let placemarks = placemarks, let placemark = placemarks.first {
                    var addressString = ""
                    if let street = placemark.thoroughfare {
                        addressString += street
                    }
                    if let city = placemark.locality {
                        addressString += ", \(city)"
                    }
                    if let country = placemark.country {
                        addressString += ", \(country)"
                    }
                    completion(addressString)
                } else {
                    print("주소로 변환하지 못했습니다.")
                    completion("주소를 찾을 수 없습니다.")
                }
            })
        } else {
            completion("위치 정보가 없습니다.")
        }
    }
}
