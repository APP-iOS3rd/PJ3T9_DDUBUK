//
//  FireStore.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/22.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Coordinate: Codable, Hashable {
    var latitude: Double
    var longitude: Double
    var timestamp: Timestamp

    init(from dict: [String: Any]) {
        self.latitude = dict["latitude"] as? Double ?? 0.0
        self.longitude = dict["longitude"] as? Double ?? 0.0
        if let date = dict["timestamp"] as? Date {
            self.timestamp = Timestamp(date: date)
        } else {
            self.timestamp = Timestamp()
        }
    }

    init(latitude: Double, longitude: Double, timestamp: Timestamp) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        let date = try container.decode(Date.self, forKey: .timestamp)
        self.timestamp = Timestamp(date: date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(timestamp.dateValue(), forKey: .timestamp)
    }

    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timestamp
    }
}


struct Route: Codable, Hashable {
    var information: String
    var coordinates: [Coordinate]

    init(from dict: [String: Any]) {
        self.information = dict["information"] as? String ?? ""
        self.coordinates = (dict["coordinates"] as? [[String: Any]])?.map { Coordinate(from: $0) } ?? []
    }

    init(information: String, coordinates: [Coordinate]) {
        self.information = information
        self.coordinates = coordinates
    }
}


class FireStoreManager: ObservableObject {
    static let shared = FireStoreManager()
    
    init() {}
    
    @Published var routes = [Route]()
    
    let db = Firestore.firestore()
    
   

    func fetchRoutes() {
        db.collection("routes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let newRoutes = querySnapshot?.documents.compactMap { document -> Route? in
                    let data = document.data()
                    let information = data["information"] as? String ?? ""
                    let coordinatesData = data["coordinates"] as? [[String: Any]] ?? []
                    let coordinates: [Coordinate] = coordinatesData.compactMap { dict -> Coordinate? in
                        guard let latitude = dict["latitude"] as? Double,
                              let longitude = dict["longitude"] as? Double,
                              let timestamp = (dict["timestamp"] as? Timestamp)?.dateValue() else {
                            return nil
                        }
                        return Coordinate(from: ["latitude": latitude, "longitude": longitude, "timestamp": timestamp])
                    }
                    return Route(from: ["information": information, "coordinates": coordinates])
                } ?? []
                DispatchQueue.main.async {
                    self.routes = newRoutes
                }
            }
        }
    }
    
    func addRoute(docName: String, route: Route) {
        let docData: [String: Any] = [
            "information" : route.information,
            "coordinates" : route.coordinates.map { ["latitude": $0.latitude, "longitude": $0.longitude, "timestamp": $0.timestamp.dateValue()] }
        ]
        addRoute(docName: docName, docData: docData)
    }
    
    private func addRoute(docName: String, docData: [String: Any]) {
        let docRef = db.collection("routes").document(docName)
        
        docRef.setData(docData) { error in
            if let error = error {print(error)
            } else {
                print("sucess: ", docName)
            }
        }
    }
}
//// Firestore에 데이터 저장 예시
//func saveRouteToFirestore(route: Route) {
//    do {
//        let db = Firestore.firestore()
//        try db.collection("routes").addDocument(from: route)
//    } catch {
//        print("Error saving route to Firestore: \(error.localizedDescription)")
//    }
//}
//
//// Firestore에서 데이터 가져오기 예시
//func fetchRouteFromFirestore(completion: @escaping (Route?) -> Void) {
//    let db = Firestore.firestore()
//    
//    // 예시로 collection("routes")에서 문서를 가져오는 방법입니다.
//    db.collection("routes").getDocuments { (querySnapshot, error) in
//        if let error = error {
//            print("Error fetching route from Firestore: \(error.localizedDescription)")
//            completion(nil)
//        } else {
//            var fetchedRoute: Route?
//            
//            for document in querySnapshot!.documents {
//                do {
//                    if let route = try document.data(as: Route.self) {
//                        fetchedRoute = route
//                    }
//                } catch {
//                    print("Error decoding route data: \(error.localizedDescription)")
//                }
//            }
//            
//            completion(fetchedRoute)
//        }
//    }
//}
//
//// 사용 예시
//let sampleRoute = Route(coordinates: [
//    Ddubuk(information: "Point 1", latitude: 37.7749, longitude: -122.4194, timestamp: Timestamp()),
//    Ddubuk(information: "Point 2", latitude: 34.0522, longitude: -118.2437, timestamp: Timestamp())
//], timestamp: Timestamp())
//
//// Firestore에 저장
//saveRouteToFirestore(route: sampleRoute)
//
//// Firestore에서 가져오기
//fetchRouteFromFirestore { (fetchedRoute) in
//    if let fetchedRoute = fetchedRoute {
//        print("Fetched Route: \(fetchedRoute)")
//    } else {
//        print("Failed to fetch route from Firestore.")
//    }
//}
