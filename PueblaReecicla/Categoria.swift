import FirebaseFirestore

class Categoria {

    var filename: String
    var imageUrl: String
    var documentID: String

    var dictionary: [String: Any] {
        return [
            "filename": filename,
            "imageUrl": imageUrl,
            "documentID": documentID
        ]
    }

    convenience init(dictionary: [String: Any]) {
        let filename = dictionary["filename"] as! String? ?? ""
        let imageUrl = dictionary["imageUrl"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""

        self.init(filename: filename, url: imageUrl, documentID: documentID)
    }

    init(filename: String, url: String, documentID: String) {
        self.filename = filename
        self.imageUrl = url
        self.documentID = documentID
    }

    convenience init() {
        self.init(filename: "", url: "", documentID: "")
    }

}
