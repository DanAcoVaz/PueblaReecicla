import FirebaseFirestore

class Favorito {

    var recolectores: [DocumentReference]!
    var centros: [DocumentReference]!
    var documentID: String!

    var dictionary: [String: Any] {
        return [
            "recolectores": recolectores!,
            "centros": centros!
        ]
    }

    init(recolectores: [DocumentReference], centros: [DocumentReference]) {
        self.recolectores = recolectores
        self.centros = centros
    }

    convenience init() {
        self.init(recolectores: [], centros: [])
    }

    convenience init(dictionary: [String: Any]) {
        let recolector = dictionary["recolectores"] as? [DocumentReference] ?? []
        let centro = dictionary["centros"] as? [DocumentReference] ?? []

        self.init(recolectores: recolector, centros: centro)
    }

}
