//
//  MaterialCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Administrador on 15/11/23.
//

import UIKit

class MaterialCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fondoRecoleccion: UIView!
    @IBOutlet weak var imgMaterial: UIImageView!
    @IBOutlet weak var nombreMaterial: UILabel!
    @IBOutlet weak var unidadMaterial: UILabel!
    @IBOutlet weak var cantidadMaterial: UILabel!
    
    @IBOutlet weak var verFotoBtn: UIButton!
    
    static let identifier = "MaterialCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fondoRecoleccion.layer.cornerRadius = 20 // se redondea el cuadrado del fondo de la recolección
        fondoRecoleccion.layer.borderWidth = 0.5  // Set the width of the stroke
        fondoRecoleccion.layer.borderColor = RecycleViewController.color_fondo!.cgColor
        
        // se agrega una sombra al fondo de la recolección
        fondoRecoleccion.backgroundColor = UIColor.white // Set the background color

        imgMaterial.layer.cornerRadius = min(imgMaterial.frame.width, imgMaterial.frame.height) / 2.0
        imgMaterial.layer.masksToBounds = true
    }

    public func configure(with imgM: UIImage, nombreM: String, unidadM: String, cantidadM: String) {
        
        imgMaterial.image = imgM
        nombreMaterial.text = nombreM
        unidadMaterial.text = unidadM
        cantidadMaterial.text = cantidadM
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: MaterialCollectionViewCell.identifier, bundle: nil)
    }
}
