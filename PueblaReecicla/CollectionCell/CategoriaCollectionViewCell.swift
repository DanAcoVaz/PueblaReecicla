//
//  CategoriaCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Alumno on 25/11/23.
//

import UIKit

class CategoriaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var CategoryImageView: UIImageView!
    var nameImage: String!
    
    static let identifier = "CategoriaCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoriaCollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    public func configure(with model: Categoria) {
        
        self.nameImage = model.imageUrl
        loadImageFromURL()
    }
    
    
    func loadImageFromURL() {
        
        if let imageURLString = self.nameImage, !imageURLString.isEmpty,
            let imageURL = URL(string: imageURLString) {
                // Intenta cargar la imagen desde la URL...
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    // Verifica si hay datos y si no hay errores...
                    if let data = data, error == nil {
                        // Crear una imagen desde los datos obtenidos...
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.CategoryImageView?.image = image
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.CategoryImageView?.image = UIImage(named: "placeholder")
                        }
                    }
                }.resume()
            
            } else {
                self.CategoryImageView?.image = UIImage(named: "placeholder")
            }
        
    }

}
