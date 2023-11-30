//
//  Materiales.swift
//  PueblaReecicla
//
//  Created by Alumno on 21/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import MapKit

class Materiales {
    
    var materiales: [ MaterialInfo ] = []
    var MaterialsMap: [String: Int] = [:]
    let db:Firestore!
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func loadData(Father: MapViewController) {
        
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
            var counter = 0
            
            for document in snapshot.documents {
                
                let material = MaterialInfo(dictionary: document.data())
                material.documentID = document.documentID
                self.materiales.append(material)
                
                let nombreMaterial = material.documentID
                self.MaterialsMap[nombreMaterial] = counter
                
                //print("ID: \(material.documentID), URL: //\(material.imageUrl)") // Print Info
                counter += 1
            }
            
            /*for (key, value) in self.MaterialsMap {
              print("Clave: \(key), Valor: \(value)")
            }*/
            
            
            Father.Centers.LoadData(Map: Father.MapOS, Mate: self)
            
        }
        
        
        
    }
    
}
