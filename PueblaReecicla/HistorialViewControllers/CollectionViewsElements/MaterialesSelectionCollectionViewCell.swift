//
//  MaterialesSelectionCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Administrador on 21/11/23.
//

import UIKit

class MaterialesSelectionCollectionViewCell: UICollectionViewCell {

    static let identifier = "MaterialesSelectionCollectionViewCell"
    
    @IBOutlet var imgMaterial: UIImageView!
    @IBOutlet var nombreMaterial: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgMaterial.layer.cornerRadius = min(imgMaterial.frame.width, imgMaterial.frame.height) / 2.0
        
        let borderLayer = CALayer()
        let borderFrame = CGRect(x: -3.0, y: -3.0, width: imgMaterial.frame.size.height + 6.0, height: imgMaterial.frame.size.height + 6.0)
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.frame = borderFrame
        borderLayer.cornerRadius = (imgMaterial.frame.width + 6.0) / 2.0
        borderLayer.borderWidth = 6.0
        borderLayer.borderColor = RecycleViewController.blue?.cgColor
        imgMaterial.layer.addSublayer(borderLayer)
        
        imgMaterial.layer.masksToBounds = false
    }
    
    public func configure(with imgM: UIImage, nombreM: String) {
        imgMaterial.image = imgM
        nombreMaterial.text = nombreM
    }

    static func nib() -> UINib {
        return UINib(nibName: MaterialesSelectionCollectionViewCell.identifier, bundle: nil)
    }
}
