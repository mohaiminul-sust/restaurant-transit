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
        // 1
        if currentRestaurentIndex > names.count - 1{
            currentRestaurentIndex = 0
        }
        // 2
        let coordinate = coordinates[currentRestaurentIndex]
        let latitude: Double   = coordinate[0] as! Double
        let longitude: Double  = coordinate[1] as! Double
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var point = RestaurentAnnotation(coordinate: locationCoordinates)
        point.title = names[currentRestaurentIndex]
        point.image = images[currentRestaurentIndex]
        // 3
        // Calculate Transit ETA Request
        let request = MKDirectionsRequest()
        /* Source MKMapItem */
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        request.source = sourceItem
        /* Destination MKMapItem */
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinates, addressDictionary: nil))
        request.destination = destinationItem
        request.requestsAlternateRoutes = false
        // Looking for Transit directions, set the type to Transit
        request.transportType = .Transit
        // Center the map region around the restaurant coordinates
        mapView.setCenterCoordinate(locationCoordinates, animated: true)
        // You use the MKDirectionsRequest object constructed above to initialise an MKDirections object
        let directions = MKDirections(request: request)
        directions.calculateETAWithCompletionHandler { (etaResponse, error) -> Void in
            if let error = error {
                print("Error while requesting ETA : \(error.localizedDescription)")
                point.eta = error.localizedDescription
            }else{
                point.eta = "\(Int((etaResponse?.expectedTravelTime)!/60)) min"
            }
            // 4
            var isExist = false
            for annotation in self.mapView.annotations{
                if annotation.coordinate.longitude == point.coordinate.longitude && annotation.coordinate.latitude == point.coordinate.latitude{
                    isExist = true
                    point = annotation as! RestaurentAnnotation
                }
            }
            if !isExist{
                self.mapView.addAnnotation(point)
            }
            self.mapView.selectAnnotation(point, animated: true)
            self.currentRestaurentIndex += 1
        }
    }
    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is RestaurentAnnotation){
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        let restaurentAnnotation = annotation as! RestaurentAnnotation
        annotationView?.detailCalloutAccessoryView = UIImageView(image: restaurentAnnotation.image)
        
        // Left Accessory
        let leftAccessory = UILabel(frame: CGRectMake(0,0,50,30))
        leftAccessory.text = restaurentAnnotation.eta
        leftAccessory.font = UIFont(name: "Verdana", size: 10)
        annotationView?.leftCalloutAccessoryView = leftAccessory
        
        // Right accessory view
        let image = UIImage(named: "bus.png")
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.setImage(image, forState: .Normal)
        annotationView?.rightCalloutAccessoryView = button
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        
        //The map item is the restaurent location
        let mapItem = MKMapItem(placemark: placemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}

