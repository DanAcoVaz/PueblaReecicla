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
    
    var CenterCategory: String
    var CenterDays: [String]
    var CenterDirection: String
    var CenterOpen: String
    var CenterClose: String
    var CenterLatitud: Double
    var CenterLongitud: Double
    var CenterMateriales: [MaterialInfo]!


    init( title: String?, coordinate: CLLocationCoordinate2D, image: String, telefono: String, FavoriteCenter: Bool, categoria: String, days: [String], direction: String, Open:String, Close: String, Latitud: Double, Longitud: Double) {
    self.title = title
    self.CenterImage = image
    self.coordinate = coordinate
    self.FavoriteCenter = FavoriteCenter
    self.CenterPhone = telefono
    
    self.CenterCategory = categoria
    self.CenterDays = days
    self.CenterDirection = direction
    self.CenterOpen = Open
    self.CenterClose = Close
    self.CenterLatitud = Latitud
    self.CenterLongitud = Longitud
    self.CenterMateriales = []
        
    super.init()
  }
}
