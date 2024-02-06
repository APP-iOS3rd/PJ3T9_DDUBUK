//
//  FireStoreManager.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/02/02.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreManager: ObservableObject {
    static let shared = FireStoreManager()
    
    @Published var routes = [Route]()
    
    private let db = Firestore.firestore()
    
    func fetchRoutes() {
        db.collection("routes").getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("문서 가져오는 중 오류: \(error)")
            } else {
                self?.routes = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Route.self)
                } ?? []
            }
        }
    }
    
    func addRoute(route: Route, documentName: String?, completion: @escaping (Error?) -> Void) {
        let coordinatesData = route.coordinates.map { coordinate -> [String: Any] in
               return [
                   "latitude": coordinate.latitude,
                   "longitude": coordinate.longitude,
                   "timestamp": Timestamp(date: coordinate.timestamp)
               ]
           }
           
        let routeData: [String: Any] = [
            "title": route.title,
            "coordinates": route.coordinates.map { coordinate in
                [
                    "latitude": coordinate.latitude,
                    "longitude": coordinate.longitude,
                    "timestamp": Timestamp(date: coordinate.timestamp)
                ]
            },
            "imageUrl": route.imageUrl ?? "",
            "address": route.address ?? "",
            "memo": route.memo,
            "types": route.types.map { $0.rawValue },
            "duration": route.duration,
            "distanceTraveled": route.distanceTraveled
        ]
           
           db.collection("routes").document(documentName ?? UUID().uuidString).setData(routeData) { error in
               completion(error)
           }
       }
    
    func saveTimerDuration(title: String, startTime: Date, endTime: Date) {
            let duration = endTime.timeIntervalSince(startTime)
            let data: [String: Any] = [
                "startTime": startTime,
                "endTime": endTime,
                "duration": duration
            ]
            
            db.collection("timers").document(title).setData(data) { error in
                if let error = error {
                    print("Error saving timer duration: \(error)")
                } else {
                    print("Timer duration saved successfully.")
                }
            }
        }
    
    func saveRoute(route: Route) {
        // documentName 생성 로직
        var documentName = route.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if documentName.isEmpty {
            // title이 비어 있을 경우 현재 날짜와 시간을 기반으로 documentName 생성
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            documentName = "Route_\(dateFormatter.string(from: Date()))"
        }
        
        // Firestore에 Route 객체 저장
        FireStoreManager.shared.addRoute(route: route, documentName: documentName) { error in
            if let error = error {
                print("Error adding route: \(error.localizedDescription)")
            } else {
                print("Route successfully added with document name: \(documentName)")
            }
        }
    }
}


//#Preview {
//    FireStoreManager()
//}
