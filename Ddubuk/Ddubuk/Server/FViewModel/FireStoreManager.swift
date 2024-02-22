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
        db.collection("routes").getDocuments { (snapshot, error) in
            if let error = error {
                // Firestore로부터 문서를 가져오는 데 실패한 경우
                print("Firestore 문서 가져오기 오류: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else {
                    // 스냅샷이 nil인 경우
                    print("Firestore에서 스냅샷을 가져올 수 없음")
                    return
                }
                
                self.routes = snapshot.documents.compactMap { doc -> Route? in
                    do {
                        return try doc.data(as: Route.self)
                    } catch let decodingError {
                        // 문서를 Route로 디코딩하는 데 실패한 경우
                        print("문서 디코딩 오류: \(decodingError)")
                        // 문서 ID와 실패한 문서의 원본 데이터를 로깅
                        print("문서 ID: \(doc.documentID), 데이터: \(doc.data())")
                        return nil
                    }
                }
                
                if self.routes.isEmpty && !snapshot.documents.isEmpty {
                    // Firestore에 문서는 있지만, Route로 변환된 것이 하나도 없는 경우
                    print("모든 문서가 디코딩에 실패했습니다. 모델과 Firestore의 데이터 구조를 확인하세요.")
                }
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
            "imageUrls": route.imageUrls,
            "address": route.address ?? "",
            "memo": route.memo,
            "types": route.types.map { $0.rawValue },
            "duration": route.duration,
            "distanceTraveled": route.distanceTraveled,
            "recordedDate": Timestamp(date: route.recordedDate),
            "stepsCount": route.stepsCount
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
