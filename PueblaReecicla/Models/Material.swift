//
//  Material.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import Foundation

class Material {
    var cantidad: Int
    var fotoUrl: String
    var nombre: String
    var unidad: String

    init(cantidad: Int, fotoUrl: String, nombre: String, unidad: String) {
        self.cantidad = cantidad
        self.fotoUrl = fotoUrl
        self.nombre = nombre
        self.unidad = unidad
    }

    convenience init(dictionary: [String: Any]) {
        self.init(
            cantidad: dictionary["cantidad"] as? Int ?? 0,
            fotoUrl: dictionary["fotoUrl"] as? String ?? "",
            nombre: dictionary["nombre"] as? String ?? "",
            unidad: dictionary["unidad"] as? String ?? ""
        )
    }
}
