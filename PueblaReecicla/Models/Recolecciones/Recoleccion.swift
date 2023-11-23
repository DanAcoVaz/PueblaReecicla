//
//  Recoleccion.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import Foundation
import FirebaseFirestore

class Recoleccion {
    var documentID: String
    var calificado: Bool
    var comentarios: String
    var enPersona: Bool
    var estado: String
    var fechaRecoleccion: String
    var horaRecoleccionFinal: String
    var horaRecoleccionInicio: String
    var idUsuarioCliente: String
    var materiales: [String: Material]
    var timeStamp: Int
    var recolectada: Bool
    var recolector: Recolector
    
    var dictionary: [String: Any] {
        return [
            "documentID": documentID,
            "calificado": calificado,
            "comentarios": comentarios,
            "enPersona": enPersona,
            "estado": estado,
            "fechaRecoleccion": fechaRecoleccion,
            "horaRecoleccionFinal": horaRecoleccionFinal,
            "horaRecoleccionInicio": horaRecoleccionInicio,
            "idUsuarioCliente": idUsuarioCliente,
            "materiales": materiales,
            "timeStamp": timeStamp,
            "recolectada": recolectada,
            "recolector": recolector
        ]
    }
    
    convenience init(dictionary: [String: Any]) {
        let documentID = dictionary["documentID"] as! String? ?? ""
        let calificado = dictionary["calificado"] as! Bool? ?? false
        let comentarios = dictionary["comentarios"] as! String? ?? ""
        let enPersona = dictionary["enPersona"] as! Bool? ?? false
        let estado = dictionary["estado"] as! String? ?? ""
        let fechaRecoleccion = dictionary["fechaRecoleccion"] as! String? ?? ""
        let horaRecoleccionFinal = dictionary["horaRecoleccionFinal"] as! String? ?? ""
        let horaRecoleccionInicio = dictionary["horaRecoleccionInicio"] as! String? ?? ""
        let idUsuarioCliente = dictionary["idUsuarioCliente"] as! String? ?? ""
        let materialesData = dictionary["materiales"] as! [String: [String: Any]]? ?? [:]
        let timeStamp = (dictionary["timeStamp"] as? Int? ?? 0) ?? Int(truncating: NSNumber(0))
        let recolectada = dictionary["recolectada"] as! Bool? ?? false
        let recolectorData = dictionary["recolector"] as! [String: Any]? ?? [:]

        let materiales = materialesData.mapValues { Material(dictionary: $0) }
        let recolector = Recolector(dictionary: recolectorData)

        self.init(
            documentID: documentID,
            calificado: calificado,
            comentarios: comentarios,
            enPersona: enPersona,
            estado: estado,
            fechaRecoleccion: fechaRecoleccion,
            horaRecoleccionFinal: horaRecoleccionFinal,
            horaRecoleccionInicio: horaRecoleccionInicio,
            idUsuarioCliente: idUsuarioCliente,
            materiales: materiales,
            timeStamp: timeStamp,
            recolectada: recolectada,
            recolector: recolector
        )
    }

    init(documentID: String, calificado: Bool, comentarios: String, enPersona: Bool, estado: String, fechaRecoleccion: String, horaRecoleccionFinal: String, horaRecoleccionInicio: String, idUsuarioCliente: String, materiales: [String: Material], timeStamp: Int, recolectada: Bool, recolector: Recolector) {
        self.documentID = documentID
        self.calificado = calificado
        self.comentarios = comentarios
        self.enPersona = enPersona
        self.estado = estado
        self.fechaRecoleccion = fechaRecoleccion
        self.horaRecoleccionFinal = horaRecoleccionFinal
        self.horaRecoleccionInicio = horaRecoleccionInicio
        self.idUsuarioCliente = idUsuarioCliente
        self.materiales = materiales
        self.timeStamp = timeStamp
        self.recolectada = recolectada
        self.recolector = recolector
    }

    convenience init() {
        self.init(
            documentID: "",
            calificado: false,
            comentarios: "",
            enPersona: false,
            estado: "",
            fechaRecoleccion: "",
            horaRecoleccionFinal: "",
            horaRecoleccionInicio: "",
            idUsuarioCliente: "",
            materiales: [:],
            timeStamp: 0,
            recolectada: false,
            recolector: Recolector()
        )
    }
}
