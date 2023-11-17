//
//  Center.swift
//  PueblaReecicla
//
//  Created by Alumno on 10/11/23.
//

import Foundation
import MapKit

class Center: NSObject, MKAnnotation {
    
    var title: String?
    var CenterImage: String?
    var FavoriteCenter: Bool?
    var coordinate: CLLocationCoordinate2D
    var CenterPhone: String?

    init( title: String?, coordinate: CLLocationCoordinate2D, image: String, telefono: String, FavoriteCenter: Bool) {
    self.title = title
    self.CenterImage = image
    self.coordinate = coordinate
    self.FavoriteCenter = FavoriteCenter
    self.CenterPhone = telefono

    super.init()
  }
}
