//
//  ViewController.swift
//  LocationMessenger
//
//  Created by Mark Pizzutillo on 4/7/18.
//  Copyright © 2018 Mark Pizzutillo, Bayley Hart. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var setViewBtn: UIButton!
    let locationManager = CLLocationManager()
    var locSet = false
    
    let viewRadius: CLLocationDistance = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBtn.layer.cornerRadius = 7
        
        
        //Get user permission when in app
        //self.locationManager.requestAlwaysAuthorization()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100
            locationManager.startUpdatingLocation()
        } else {
            print("Location services off")
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Generates an area to show based on defined radius
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, viewRadius, viewRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Called when location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locSet == false {
            //Don't enable the button until a view exists
            setViewBtn.isEnabled = true
            if let currLocation:CLLocation = locationManager.location {
                centerMapOnLocation(location: currLocation)
            } else {
                print("Did not get back as CLLocation")
            }
            locSet = true
        }
    }
    @IBAction func returnToUser(_ sender: UIButton) {
        if let currLocation:CLLocation = locationManager.location {
            centerMapOnLocation(location: currLocation)
        }
    }
}
