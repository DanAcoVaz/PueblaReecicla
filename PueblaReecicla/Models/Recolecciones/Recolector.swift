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
    var cantidad_reseñas: Int
    var suma_reseñas: Int

    init(nombre: String, apellidos: String, telefono: String, cantidad_reseñas: Int, suma_reseñas: Int) {
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
            cantidad_reseñas: dictionary["cantidad_reseñas"] as? Int ?? 0,
            suma_reseñas: dictionary["suma_reseñas"] as? Int ?? 0
        )
    }
}

