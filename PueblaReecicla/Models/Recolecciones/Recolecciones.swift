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
                
                if (recoleccion.recolector.id != "" && recoleccion.estado == RecycleViewController.iniciada) {
                    recoleccion.estado = RecycleViewController.enProceso
                    Recolecciones.updateEstado(recoleccion: recoleccion, estado: RecycleViewController.enProceso)
                } else if (recoleccion.estado == RecycleViewController.enProceso && recoleccion.recolectada) {
                    recoleccion.estado = RecycleViewController.completada
                    Recolecciones.updateEstado(recoleccion: recoleccion, estado: RecycleViewController.completada)
                }
                
                self.recoleccionArray.append(recoleccion)
            }
            return completed()
        }
    }
    
    static func updateEstado(recoleccion: Recoleccion, estado: String) {
        // Handle accept action
        let db = Firestore.firestore()
        let collection = db.collection("recolecciones")
        let documentID = recoleccion.documentID
        // Define the field you want to update
        let fieldToUpdate = "estado"

        // Create a dictionary with the field to update
        let updateData = [fieldToUpdate: estado]

        // Update the document
        collection.document(documentID).updateData(updateData) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
    }
}

