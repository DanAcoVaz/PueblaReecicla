import FirebaseFirestore

class Favoritos {
    let db: Firestore!
    var uid: String!
    var favorito: Favorito!
    var FavoriteMap: [String : [Int]]!

    
    init(uid: String) {
        self.uid = uid
        self.db = Firestore.firestore()
    }
    
    func loadData() {
        
        self.FavoriteMap = [:]
        
        let DocumentFavoritesReference = db.collection("usuario_favoritos").document(self.uid)
        
        
        DocumentFavoritesReference.getDocument { (document, error) in
            if let document = document, document.exists {
                self.favorito = Favorito(dictionary: document.data()!)
                
                var count = 0
                for referenceCentroFavorito in self.favorito.centros {
                    referenceCentroFavorito.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let nombreCentro = document.data()?["nombre"]
                            self.FavoriteMap[nombreCentro as! String] = [count, 0]
                            //print("Nombre : ", nombreCentro, "Valores", count )
                        }
                    }
                    count += 1
                }
                

                
                //print("Favorito : ", self.favorito.centros!)
            } else {
                // Crear un documento en usuario_favoritos para este usuario
            }
        }
        
    }

}
