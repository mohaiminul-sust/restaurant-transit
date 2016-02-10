//
//  RestaurentAnnotation.swift
//  Restaurants Transit
//
//  Created by Mohaiminul Islam on 2/10/16.
//  Copyright © 2016 Crayon Devs. All rights reserved.
//

import UIKit
import MapKit

class RestaurentAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image:UIImage?
    var eta: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
