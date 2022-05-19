//
//  MKMap.swift
//  SwiftUI MapKit
//
//  Created by Alexander Katzfey on 5/18/22.
//

import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    
    @Published var currentRegion: MKCoordinateRegion = appleDefaultLoc
    @Published var annotations: [MKAnnotation] = []
    
    var shouldUpdateView = true
    
    static let appleDefaultLoc = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331676, longitude: -122.030189),
                                                    span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
}

struct MKMap: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: MapViewModel
    
    var annotations: [MKAnnotation]
    
    init<Items>(annotationItems: Items, annotationContent: @escaping (Items.Element) -> CustomMKAnnotation) where Items : RandomAccessCollection, Items.Element : Identifiable  {
        
        print("init Mkmap")
        annotations = annotationItems.map { item in
            annotationContent(item)
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        print("MKMap: making UI View")
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        viewModel.annotations = annotations
        mapView.addAnnotations(viewModel.annotations)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        // Stop update loop when delegate methods update state.
        guard viewModel.shouldUpdateView else {
            viewModel.shouldUpdateView = true
            return
        }
        
        print("MKMap: Setting region")
        view.setRegion(viewModel.currentRegion, animated: true)
        
        view.addAnnotations(viewModel.annotations)  // This is incorrect and will likely result in performance issues
        
    }
    
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        private var parent: MKMap
        
        init(_ control: MKMap) {
            self.parent = control
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // Try to resolve identifier for annotation
            var identifier: String? = nil
            
            if annotation is MKUserLocation {
                identifier = "userLocation"
            }
            
            if annotation is CustomMKAnnotation {
                let annotation = annotation as! CustomMKAnnotation
                identifier = annotation.id
            }
            
            guard identifier != nil else {
                // Handle error here
                return nil
            }
            
            // Use found identifier to dequeue associated annotation view
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier!)
            
            // If we can't find an associated annotation view, create a new one
            guard annotationView != nil else {
                
                if annotation is MKUserLocation {
                    return MKUserLocationView(annotation: annotation, reuseIdentifier: identifier)
                }
                if annotation is CustomMKAnnotation {
                    return CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                }
                
                // Handle error here
                return nil
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            print("MKMap: region did change")
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print("MKMap: changed visible region")
            
            // Prevent the below viewModel update from calling itself endlessly.
            parent.viewModel.shouldUpdateView = false
            
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("MKMap: selected a view annotation")
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            print("MKMap: Deselected annotation")
        }
    }
}

