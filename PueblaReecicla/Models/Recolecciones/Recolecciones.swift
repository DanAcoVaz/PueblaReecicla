//
//  recolecciones.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import Foundation
import Firebase
import FirebaseFirestore

class Recolecciones {
    var recoleccionArray: [Recoleccion] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(userID: String,completed: @escaping () -> ()) {
        db.collection("recolecciones").whereField("idUsuarioCliente", isEqualTo: userID).order(by: "timeStamp", descending: true).limit(to: 50).addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            
            self.recoleccionArray = []
            
            for document in querySnapshot!.documents {
                
                let recoleccion = Recoleccion(dictionary: document.data())
                recoleccion.documentID = document.documentID
                self.recoleccionArray.append(recoleccion)
            }
            return completed()
        }
    }
}

