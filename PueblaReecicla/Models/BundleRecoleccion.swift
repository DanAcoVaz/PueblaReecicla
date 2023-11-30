//
//  BundleRecoleccion.swift
//  PueblaReecicla
//
//  Created by Administrador on 22/11/23.
//

import Foundation

class BundleRecoleccion {
    static let shared = BundleRecoleccion()
    
    var selectedDate: String
    var timeIni: String
    var timeEnd: String
    var commentaries: String
    var enPersonaSelected: Bool
    var calle: String
    var numero: String
    var colonia: String
    var municipio: String
    var codigoPostal: String
    var telefono: String
    var latitud: String
    var longitud: String
    var direccionCompleta: String
    var nombreCompleto: String

    private init() {
        self.selectedDate = ""
        self.timeIni = ""
        self.timeEnd = ""
        self.commentaries = ""
        self.enPersonaSelected = false
        self.calle = ""
        self.numero = ""
        self.colonia = ""
        self.municipio = ""
        self.codigoPostal = ""
        self.telefono = ""
        self.latitud = ""
        self.longitud = ""
        self.direccionCompleta = ""
        self.nombreCompleto = ""
    }
}
