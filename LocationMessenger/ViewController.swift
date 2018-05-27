//
//  ViewController.swift
//  LocationMessenger
//
//  Created by Mark Pizzutillo on 4/7/18.
//  Copyright © 2018 Mark Pizzutillo, Bayley Hart. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import SendBirdSDK

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var setViewBtn: UIButton!
    let locationManager = CLLocationManager()
    
    //User ID for login
    var userID = ""
    
    //Initial location set
    var locSet = false
    
    var currentChannel:SBDOpenChannel? = nil
    
    let viewRadius: CLLocationDistance = 5000
    //---------------------------------------------
    //  Function: viewDidLoad
    //
    //  Invoked when view has loaded
    //  Does initial setup of location information
    //---------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        SBDMain.initWithApplicationId("135087D7-1D6F-41AA-8077-81B3D6E5F862")
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
        
        //Present to user
        //askForUserName()
        
        
        
    }
    
    //------------------------------------------
    //  Function: didReceiveMemoryWarning
    //------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------
    //  Function: centerMapOnLocation
    //
    //  Creates a region of view centered around user location
    //  Sets this region to the view of the map
    //---------------------------------------------------------
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, viewRadius, viewRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //------------------------------------------------------------------
    //  Function: locationManager --> didUpdateLocations
    //
    //  Automatically called when user's location updates significantly
    //  Calls centerMapOnLocation the first time (initial set)
    //------------------------------------------------------------------
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
    
    //------------------------------------------
    //  Function: returnToUser()
    //
    //  Action performed from locationButton
    //  Calls the center on location function
    //------------------------------------------
    @IBAction func returnToUser(_ sender: UIButton) {
        if let currLocation:CLLocation = locationManager.location {
            centerMapOnLocation(location: currLocation)
        }
    }
    
    //-----------------------------------------------------
    //  Function: askForUserName()
    //
    //  Creates an alert to prompt the user for a nickname
    //  Stores that name in the userID variable for later
    //-----------------------------------------------------
    func askForUserNameAndConnect() {
        //Choose username popup alert
        let alertController = UIAlertController(title: "Joining Chat",message: "Pick a username!",preferredStyle: .alert)
        
        //On enter, set the userID
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if let chosenName = alertController.textFields?[0].text {
                self.userID = chosenName
                self.connectAndTest()
            } else {
                print("DEBUG: Could not unwrap optional")
            }
        }
        
        //On cancel, do nothing, and return to map
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //Add the text field
        alertController.addTextField { (textField) in
            textField.placeholder = "Choose a Nickname"
        }
        
        //Add to the dialogue box
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil) //COMPLETION TO CHANGE SOON, WILL MOVE TO MESSAGE VIEW
    }
    @IBAction func JoinBtnPressed(_ sender: UIButton) {
        askForUserNameAndConnect()
        
    }
    
    func connectAndTest() {
        if (userID == "") {
            return
        }
        
        var channelURL = ""
        
        
        //Code below is BROKEn **********************
        
        //Connect
        SBDMain.connect(withUserId: userID, completionHandler: { (user, error) in
            if error != nil {
                //Show error
                let errorController = UIAlertController(title: "Error", message: "Could not connect. Check internet connectivity and try again", preferredStyle: .alert)
                let affirmAction = UIAlertAction(title: "OK", style: .default) {(_) in }
                
                errorController.addAction(affirmAction)
                self.present(errorController, animated: true, completion: nil)
                
            }
            //Enter channel
            SBDOpenChannel.getWithUrl(channelURL) { (channel, error) in
                if error != nil {
                    print("One")
                    NSLog("Error: %@", error!)
                    return
                }
                print(channelURL)
                
                channel?.enter(completionHandler: { (error) in
                    if error != nil {
                        print("Two")
                        NSLog("Error: %@", error!)
                        return
                    }
                    print(channel!.name)
                    
                    // ...
                })
            }
            
            //Send message
            SBDOpenChannel.getWithUrl(channelURL) { (channel, error) in
                if error != nil {
                    print("Three")
                    NSLog("Error: %@", error!)
                    return
                }
                channel?.sendUserMessage("TEST", data: nil, completionHandler: { (userMessage, error) in
                    if error != nil {
                        print("Four")
                        NSLog("Error: %@", error!)
                        return
                    }
                    print("Sent message")
                    // ...
                })
            }
        })
    }
}
