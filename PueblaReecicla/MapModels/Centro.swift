//
//  Centro.swift
//  PueblaReecicla
//
//  Created by Alumno on 17/11/23.
//

import Foundation
import FirebaseFirestore

class Centro {
    var categoria: String
    var dias: [String]
    var direccion: String
    var estado: Bool
    var hora_apertura: String
    var hora_cierre: String
    var imagen: String
    var latitud: Double
    var longitud: Double
    var materiales: [String]
    var nombre: String
    var num_telefonico: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["categoria": categoria, "dias": dias, "direccion": direccion, "estado": estado, "hora_apertura": hora_apertura, "hora_cierra": hora_cierre, "imagen": imagen, "latitud": latitud, "longitud": longitud, "materiales": materiales, "nombre": nombre, "num_telefonico": num_telefonico]
    }
    
    
    init(categoria: String, dias: [String], direccion: String, estado: Bool, horaApertura: String, horaCierre: String, imagen: String, latitud: Double, longitud: Double, materiales: [String], nombre: String, numTelefonico: String, documentID: String) {
            self.categoria = categoria
            self.dias = dias
            self.direccion = direccion
            self.estado = estado
            self.hora_apertura = horaApertura
            self.hora_cierre = horaCierre
            self.imagen = imagen
            self.latitud = latitud
            self.longitud = longitud
            self.materiales = materiales
            self.nombre = nombre
            self.num_telefonico = numTelefonico
            self.documentID = documentID
    }
    
    convenience init() {
        self.init(categoria: "", dias: [], direccion: "", estado: false, horaApertura: "", horaCierre: "", imagen: "", latitud: 0.0, longitud: 0.0, materiales: [], nombre: "", numTelefonico: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        
        let categoria = dictionary["categoria"] as! String? ?? ""
        let dias = dictionary["dias"] as! [String]? ?? []
        let direccion = dictionary["direccion"] as! String? ?? ""
        let estado = dictionary["estado"] as! Bool? ?? false
        let hora_apertura = dictionary["hora_apertura"] as! String? ?? ""
        let hora_cierre = dictionary["hora_cierre"] as! String? ?? ""
        let imagen = dictionary["imagen"] as! String? ?? ""
        let latitud = dictionary["latitud"] as! Double? ?? 0.0
        let longitud = dictionary["longitud"] as! Double? ?? 0.0
        let materiales = dictionary["materiales"] as! [String]? ?? []
        let nombre = dictionary["nombre"] as! String? ?? ""
        let num_telefonico = dictionary["num_telefonico"] as! String? ?? ""
        
        self.init(categoria: categoria, dias: dias, direccion: direccion, estado: estado, horaApertura: hora_apertura, horaCierre: hora_cierre, imagen: imagen, latitud: latitud, longitud: longitud, materiales: materiales, nombre: nombre, numTelefonico: num_telefonico, documentID: "")
        
    }
    
}
