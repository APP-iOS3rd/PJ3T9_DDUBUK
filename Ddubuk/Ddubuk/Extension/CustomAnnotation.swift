//
//  CustomAnnotation.swift
//  Ddubuk
//
//  Created by 조민식 on 2/24/24.
//

import SwiftUI
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(latitude: Double, longitude: Double){
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            image = UIImage(named: "mapmarker")
        }
    }
}
