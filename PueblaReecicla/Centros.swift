//
//  Centros.swift
//  PueblaReecicla
//
//  Created by Alumno on 17/11/23.
//

import FirebaseCore
import FirebaseFirestore
import MapKit

class Centros {
    
    var Centros: [Centro] = []
    var db: Firestore!
    var Materials: Materiales!
    var MaterialesCenter: [MaterialInfo]!
    var CategoryCenterMap: [String: [Int]] = [:]
    
    init() {
        db = Firestore.firestore()
    }
    
    
    func LoadData(Map: MKMapView, Mate: Materiales) {
        
        self.Materials = Mate
        
        db.collection("centros").getDocuments { (QuerySnapshot, error) in
            if let error = error {
                
                print("Error al obtener documentos")
                print(error)
                
            } else {
                
                guard (QuerySnapshot?.documents) != nil else {
                    print("No hay documentos en la coleccion")
                    return
                }
                
                self.Centros = []
                var counter = 0
                for document in QuerySnapshot!.documents {
                    
                    self.MaterialesCenter = []
                    
                    let centro = Centro(dictionary: document.data())
                    centro.documentID = document.documentID
                    centro.MapContext = Map
                    centro.addToMap()
                    
                    
                    
                    for value in centro.materiales {
                        //print(self.Materials.materiales[self.Materials.MaterialsMap[value] ?? 0].documentID, terminator: " ")
                        self.MaterialesCenter.append(self.Materials.materiales[self.Materials.MaterialsMap[value] ?? 0])
                    }
                    
                    centro.MaterialesCentro = self.MaterialesCenter
                    centro.addMaterialesCentroToCenter()
                    
                    self.Centros.append(centro)
                    print("ID: \(centro.documentID), Nombre: \(centro.nombre), Latitud: \(centro.latitud), Latitud: \(centro.longitud)")
                    
                    if var categorias = self.CategoryCenterMap[centro.categoria] {
                        // La categoría existe en el diccionario
                        categorias.append(counter) // Agrega el valor de counter a la lista de la categoría existente
                        self.CategoryCenterMap[centro.categoria] = categorias // Actualiza la lista en el diccionario
                    } else {
                        // La categoría no existe en el diccionario
                        self.CategoryCenterMap[centro.categoria] = [counter] // Crea una nueva lista con el valor de counter
                    }
                    
                    counter += 1
                }
                
                // Recorrer el diccionario e imprimir sus claves y valores
                for (categoria, valores) in self.CategoryCenterMap {
                    print("Categoría: \(categoria)")
                    print("Valores: \(valores)")
                }

            }
        }
    }
    
    
}
