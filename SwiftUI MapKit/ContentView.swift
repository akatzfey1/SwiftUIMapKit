//
//  ContentView.swift
//  SwiftUI MapKit
//
//  Created by Alexander Katzfey on 5/18/22.
//

import SwiftUI
import MapKit

struct MyMapData: Identifiable {
    var id: UUID = UUID()
    var location: CLLocationCoordinate2D
    var title: String
    var description: String
    var icon: UIImage
}


struct ContentView: View {
    
    @StateObject var mapModel = MapViewModel()
    
    var mapData = [ MyMapData(location: MapViewModel.appleDefaultLoc.center,
                              title: "Hello",
                              description: "The first location",
                              icon: "💻".image()!),
                    
                    
                    MyMapData(location: .init(latitude: MapViewModel.appleDefaultLoc.center.latitude - 0.025,
                                              longitude: MapViewModel.appleDefaultLoc.center.longitude + 0.02),
                              title: "World!",
                              description: "The second location",
                              icon: "🍺".image()!),
    ]
    
    var body: some View {
        
        MKMap(annotationItems: mapData) { item in
            
            MKMapAnnotation(coord: item.location, icon: item.icon) {
                
                // Your annotation callout view here
                
                ZStack {
                    Color.blue
                        .shadow(radius: 5)
                    
                    VStack {
                        Text(item.title)
                            .foregroundColor(.white)
                            .bold()
                            .font(.title)
                        
                        Text(item.description)
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(2)
                    }
                }
                .frame(width: 200, height: 200)
                
            }
        }
        .environmentObject(mapModel)
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
