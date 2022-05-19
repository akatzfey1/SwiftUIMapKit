//
//  CustomMKAnnotation.swift
//  SwiftUI MapKit
//
//  Created by Alexander Katzfey on 5/18/22.
//

import MapKit
import SwiftUI


protocol CustomMKAnnotation: MKAnnotation {
    var id: String { get set }
    var iconImage: UIImage { get set }
    var selectedIconImage: UIImage { get set }
    var detailView: AnyView { get set }
}

class MKMapAnnotation<Content: View>: NSObject, CustomMKAnnotation {
    var id: String
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var iconImage: UIImage
    var selectedIconImage: UIImage
    var detailView: AnyView
    
    init(id: String = String(describing: UUID()), // Default to a good random ID
         title: String? = "",
         subtitle: String? = "",
         coord: CLLocationCoordinate2D,
         icon: UIImage,
         selectedIcon: UIImage? = nil,
         @ViewBuilder detailViewContent: () -> Content)
    {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coord
        self.iconImage = icon
        self.selectedIconImage = selectedIcon ?? self.iconImage
        self.detailView = AnyView(detailViewContent())
    }
    
}


final class CustomAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        guard annotation is CustomMKAnnotation else {
            // Handle error here
            return
        }
        
        let myAnnotation = (annotation as! CustomMKAnnotation)
        
        let myView = MapCalloutView(rootView: myAnnotation.detailView)
        
        detailCalloutAccessoryView = myView
        
        image = myAnnotation.iconImage
        
        canShowCallout = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapCalloutView: UIView {
    
    //create the UIHostingController we need. For now just adding a generic UI
    let body:UIHostingController<AnyView> = UIHostingController(rootView: AnyView(Text("Hello")) )
    
    /**
     An initializer for the callout. You must pass it in your SwiftUI view as the rootView property, wrapped with AnyView. e.g.
     MapCalloutView(rootView: AnyView(YourCustomView))
     
     Obviously you can pass in any properties to your custom view.
     */
    init(rootView: AnyView) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        body.rootView = AnyView(rootView)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /**
     Ensures the callout bubble resizes according to the size of the SwiftUI view that's passed in.
     */
    private func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        //pass in your SwiftUI View as the rootView to the body UIHostingController
        //body.rootView = Text("Hello World * 2")
        body.view.translatesAutoresizingMaskIntoConstraints = false
        body.view.frame = bounds
        body.view.backgroundColor = nil
        //add the subview to the map callout
        addSubview(body.view)
        
        NSLayoutConstraint.activate([
            body.view.topAnchor.constraint(equalTo: topAnchor),
            body.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            body.view.leftAnchor.constraint(equalTo: leftAnchor),
            body.view.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        sizeToFit()
        
    }
}
