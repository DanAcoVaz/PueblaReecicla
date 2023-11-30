
import FirebaseFirestore
import FirebaseCore

class Categorias {
    var categorias: [Categoria] = []
    var CategoryCenterMap: [String: [Int]] = [:]
    let db:Firestore!

    init() {
       db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("categorias").addSnapshotListener{ (QuerySnapshot, error) in
            guard error == nil else {
                print("ERROR: Adding the snapshot listener ")
                return completed()
            }
            
            self.categorias = []
            
            for document in QuerySnapshot!.documents {
                let categoria = Categoria(dictionary: document.data())
                categoria.documentID = document.documentID
                self.categorias.append(categoria)
                
                let nombreCategoria = categoria.documentID
                self.CategoryCenterMap[nombreCategoria] = []
                
                //print("Nombre: \(categoria.documentID) URL: \(categoria.imageUrl)")
            }
            completed()
        }
    }
    
    /*func loadData() {

        db.collection("categorias").getDocuments { (QuerySnapshot, error) in
            if let error = error {
                print("Error getting categorias: \(error)")
                return
            }
            
            guard let snapshot = QuerySnapshot else {
                print("No data found")
                return
            }

            self.categorias = []
            
            for document in snapshot.documents {
                let categoria = Categoria(dictionary: document.data())
                categoria.documentID = document.documentID
                self.categorias.append(categoria)
                
                let nombreCategoria = categoria.documentID
                self.CategoryCenterMap[nombreCategoria] = []
                
                print("Nombre: \(categoria.documentID) URL: \(categoria.imageUrl)")
                
            }
            
            //for (key, value) in self.CategoryCenterMap {
               // print("Clave: \(key), Valor: \(value)")
            //}
        }
    }*/
}
