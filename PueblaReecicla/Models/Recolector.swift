//
//  Recolector.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import Foundation

class Recolector {
    var nombre: String
    var apellidos: String
    var telefono: String
    var cantidad_reseñas: Float
    var suma_reseñas: Float

    init(nombre: String, apellidos: String, telefono: String, cantidad_reseñas: Float, suma_reseñas: Float) {
        self.nombre = nombre
        self.apellidos = apellidos
        self.telefono = telefono
        self.cantidad_reseñas = cantidad_reseñas
        self.suma_reseñas = suma_reseñas
    }

    convenience init() {
        self.init(
            nombre: "",
            apellidos: "",
            telefono: "",
            cantidad_reseñas: 0,
            suma_reseñas: 0
        )
    }

    convenience init(dictionary: [String: Any]) {
        self.init(
            nombre: dictionary["nombre"] as? String ?? "",
            apellidos: dictionary["apellidos"] as? String ?? "",
            telefono: dictionary["telefono"] as? String ?? "",
            cantidad_reseñas: dictionary["cantidad_reseñas"] as? Float ?? 0.0,
            suma_reseñas: dictionary["suma_reseñas"] as? Float ?? 0.0
        )
    }
}

