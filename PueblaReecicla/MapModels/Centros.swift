//
//  Centros.swift
//  PueblaReecicla
//
//  Created by Alumno on 17/11/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Centros {
    
    var Centros: [Centro] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    
    func LoadData() {
        
        db.collection("centros").getDocuments { (QuerySnapshot, error) in
            if let error = error {
                print("Error al obtener documentos")
            } else {
                guard let documents = QuerySnapshot?.documents else {
                    print("No hay documentos en la coleccion")
                    return
                }
                
                self.Centros = []
                
                for document in QuerySnapshot!.documents {
                    let centro = Centro(dictionary: document.data())
                    centro.documentID = document.documentID
                    self.Centros.append(centro)
                    print("ID: \(centro.documentID), Nombre: \(centro.nombre)")
                }
            }
        }
    }
    
    
}
