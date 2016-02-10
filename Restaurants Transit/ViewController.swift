//
//  ViewController.swift
//  Restaurants Transit
//
//  Created by Mohaiminul Islam on 2/10/16.
//  Copyright © 2016 Crayon Devs. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    var names:[String]!
    var images:[UIImage]!
    var descriptions:[String]!
    var coordinates:[AnyObject]!
    var currentRestaurentIndex:Int = 0
    var locationManager:CLLocationManager!
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        //restaurents 
        names = ["Pied a Terre", "Big Ben", "Hawksmoor Seven Dials", "Enoteca Turi", "Wiltons", "Scott's", "The Laughing Gravy", "Restaurant Gordon Ramsay"]
        
        // Restaurants' images to show in the pin callout
        images = [UIImage(named: "restaurant-1.jpeg")!, UIImage(named: "restaurant-2.jpeg")!, UIImage(named: "restaurant-3.jpeg.jpg")!, UIImage(named: "restaurant-4.jpeg")!, UIImage(named: "restaurant-5.jpeg")!, UIImage(named: "restaurant-6.jpeg")!, UIImage(named: "restaurant-7.jpeg")!, UIImage(named: "restaurant-8.jpeg")!]
        
        // Latitudes, Longitudes
        coordinates = [
            [51.519066, -0.135200],
            [51.513446, -0.125787],
            [51.465314, -0.214795],
            [51.507747, -0.139134],
            [51.509878, -0.150952],
            [51.501041, -0.104098],
            [51.485411, -0.162042],
            [51.513117, -0.142319]
        ]
    
        //setting index
        currentRestaurentIndex = 0

        //ask for user permission
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showNext(sender: AnyObject) {
    }
    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: true)
        
    }
    
}

