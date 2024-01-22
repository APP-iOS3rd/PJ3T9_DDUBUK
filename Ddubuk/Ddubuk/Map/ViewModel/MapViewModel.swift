//
//  MapViewModel.swift
//  Ddubuk
//
//  Created by 조민식 on 1/22/24.
//

import SwiftUI
import CoreLocation
import Combine

class MapViewModel: ObservableObject {
    @Published var myLocations: [MyLocation] = [MyLocation(title: "용마폭포 공원 밤에 가기 좋은 산책로", coordinate: CLLocationCoordinate2D(latitude: 37.574955, longitude: 127.089379), locations: [
        CLLocationCoordinate2D(latitude: 37.574955, longitude: 127.089379),
        CLLocationCoordinate2D(latitude: 37.574667, longitude: 127.089260),
        CLLocationCoordinate2D(latitude: 37.574072, longitude: 127.088965),
        CLLocationCoordinate2D(latitude: 37.573698, longitude: 127.088775),
        CLLocationCoordinate2D(latitude: 37.573203, longitude: 127.088884)
    ], address: "대한민국 서울특별시 중랑구 용마폭포공원"),
    MyLocation(title: "용마산 초보자도 걸을 수 있는!", coordinate: CLLocationCoordinate2D(latitude: 37.570372, longitude: 127.088408), locations: [
        CLLocationCoordinate2D(latitude: 37.570336, longitude: 127.088391),
        CLLocationCoordinate2D(latitude: 37.570558, longitude: 127.088952),
        CLLocationCoordinate2D(latitude: 37.570576, longitude: 127.089289)
    ], address: "대한민국 서울특별시 중랑구 면목동 75-3")]
    
    @Published var locations: [CLLocationCoordinate2D] = []
    @Published var address: String?
    
    @Published var meter: String = "이동거리 : 0m"

    func changeToClLocation(latitude: Double?, longitude: Double?) -> CLLocation? {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static func changeToAddress(location: CLLocation?) -> String {
        var address: String = ""
        
        if let location = location {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                if error == nil {
                    guard let placemarks = placemarks,
                          let placemark = placemarks.last else { return }

                    address = (placemark.addressDictionary?["FormattedAddressLines"] as? [String])?.first ?? ""
                    print(address)
                } else {
                    print("주소로 변환하지 못했습니다.")
                }
            })
        }
        
        return address
    }
}
