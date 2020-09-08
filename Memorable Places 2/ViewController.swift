//
//  ViewController.swift
//  Memorable Places 2
//
//  Created by Brian Kim on 2020-07-03.
//  Copyright © 2020 Brian Kim. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var latitude: CLLocationDegrees = 43.65
        var longitude: CLLocationDegrees = -79.38
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        
        if activeRow != -1 {
            if let lat = places[activeRow]["lat"] {
                latitude = Double(lat)!
            }
            if let lon = places[activeRow]["lon"] {
                longitude = Double(lon)!
            }
        }
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        if activeRow != -1 {
            annotation.title = places[activeRow]["name"]
        }
        
        map.addAnnotation(annotation)
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2

        map.addGestureRecognizer(uilpgr)
        
//        UserDefaults.standard.removeObject(forKey: "places")
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began && gestureRecognizer.state != UIGestureRecognizer.State.changed {
            let touchPoint = gestureRecognizer.location(in: map)
            let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                var name = ""
                if error != nil {
                    print(error!)
                } else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            name = placemark.subThoroughfare!
                        }
                        if placemark.thoroughfare != nil {
                            name += " " + placemark.thoroughfare!
                        }
                    }
                }
                
                if name == "" {
                    name = "Added \(NSDate())"
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = name
                self.map.addAnnotation(annotation)
                
                places.append(["name":name, "lat":String(coordinate.latitude), "lon":String(coordinate.longitude)])
                
                let arrayObject = UserDefaults.standard.object(forKey: "places")
                var array: [Dictionary<String, String>]
                if let tempArray = arrayObject as? [Dictionary<String, String>] {
                    array = tempArray
                    array.append(["name":name, "lat":String(coordinate.latitude), "lon":String(coordinate.longitude)])
                    UserDefaults.standard.set(array, forKey: "places")
                }
            })
        }

    }
}

