//
//  myMapView.swift
//  First Class
//
//  Created by Edgar Figueroa on 11/1/16.
//  Copyright © 2016 Victor Cabrales. All rights reserved.
//

import UIKit
import MapKit

class myMapView: UIViewController {

    @IBOutlet weak var myMap : MKMapView!
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pin = myPin(title: "Mi Titulo Naco en español", subtitle: "Subtitulo naco", locationName: "Aqui", lat: 20.666111, lon: -103.351944, discipline: "Personal")
        
        self.myMap.addAnnotation(pin)
        
        var zoomRect = MKMapRectNull
        for pin in self.myMap.annotations {
            let pinPoint = MKMapPointForCoordinate(pin.coordinate)
            let pointRect = MKMapRect(origin: pinPoint, size: MKMapSize(width: 100, height: 100))
            zoomRect = MKMapRectUnion(zoomRect, pointRect)
        }
        self.myMap.setVisibleMapRect(zoomRect, animated: true)
    }
    
    

}
