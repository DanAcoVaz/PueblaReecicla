//
//  Material.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import Foundation
import UIKit

class Material {
    var cantidad: Int
    var fotoUrl: String
    var nombre: String
    var unidad: String
    var fotoMaterial: UIImage?
    var indexPath: [IndexPath]?

    init(cantidad: Int, fotoUrl: String, nombre: String, unidad: String) {
        self.cantidad = cantidad
        self.fotoUrl = fotoUrl
        self.nombre = nombre
        self.unidad = unidad
        self.fotoMaterial = nil
        self.indexPath = nil
    }

    convenience init(dictionary: [String: Any]) {
        self.init(
            cantidad: dictionary["cantidad"] as? Int ?? 1,
            fotoUrl: dictionary["fotoUrl"] as? String ?? "",
            nombre: dictionary["nombre"] as? String ?? "",
            unidad: dictionary["unidad"] as? String ?? ""
        )
    }
}
