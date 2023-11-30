//
//  MaterialCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Alumno on 28/11/23.
//

import UIKit

class MapMaterialCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textNameCenter: UILabel!
    
    var imageurl: String!
    static let identifier = "MapMaterialCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: String, name: String) {
        self.imageurl = image
        self.textNameCenter.text = name
        loadImageFromURL()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MapMaterialCollectionViewCell", bundle: nil)
    }
    
    func loadImageFromURL() {
        
        // Load Image from Center Initialization
        if let imageURLString = self.imageurl, !imageURLString.isEmpty,
           let imageURL = URL(string: imageURLString) {
            // Si la URL no está vacía y se puede convertir a un URL válido
            // Intenta cargar la imagen desde la URL
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                // Verificar si hay datos y si no hay errores
                if let data = data, error == nil {
                    // Crear una imagen desde los datos obtenidos
                    if let image = UIImage(data: data) {
                        // Escala la imagen al tamaño de la celda
                        
                        DispatchQueue.main.async {
                            // Actualizar la imageView en el hilo principal
                            self.imageView?.image = image
                        }
                    }
                } else {
                    // Si hay un error o no se pueden obtener datos, usa una imagen de relleno
                    DispatchQueue.main.async {
                        self.imageView?.image = UIImage(named: "placeholder")
                    }
                }
            }.resume()
        } else {
            // Si la URL está vacía o no se puede crear un URL válido, usa una imagen de relleno
            self.imageView?.image = UIImage(named: "placeholder")
        }
        
    }

}
