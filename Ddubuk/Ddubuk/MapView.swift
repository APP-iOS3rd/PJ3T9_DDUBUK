//
//  MapViewTest.swift
//  Ddubuk
//
//  Created by 김재완 on 2024/01/23.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    @State var userLocation = CLLocationCoordinate2D()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.centerCoordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D()
        let annotation = MKPointAnnotation()
        annotation.coordinate = uiView.centerCoordinate
        uiView.addAnnotation(annotation)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "locationIcon")
            let pulseEffect = PulsingEffect(pulseCount: 1, radius: 100, position: annotationView.center)
            annotationView.layer.insertSublayer(pulseEffect, below: annotationView.layer)
            return annotationView
        }
    }
}

struct PulsingEffect: CAAnimationGroup {
    init(pulseCount: Float, radius: CGFloat, position: CGPoint) {
        super.init()

        duration = 1.0
        repeatCount = pulseCount

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = duration

        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]

        animations = [scaleAnimation, opacityAnimation]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

