//
//  Materiales.swift
//  PueblaReecicla
//
//  Created by Alumno on 21/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

class Materiales {
    
    var materiales: [ MaterialInfo ] = []
    let db:Firestore!
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func loadData() {
        
        db.collection("materiales").getDocuments { (QuerySnapshot, error) in
            if let error = error {
                print("Error getting categorias: \(error)")
                return
            }
            
            guard let snapshot = QuerySnapshot else {
                print("No data found")
                return
            }

            self.materiales = []
            
            for document in snapshot.documents {
                let material = MaterialInfo(dictionary: document.data())
                material.documentID = document.documentID
                self.materiales.append(material)
                print("ID: \(material.documentID), Nombre: \(material.imageUrl)") // Print Info
            }
            
        }
        
    }
    
}
