//
//  MaterialReciclarCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Administrador on 20/11/23.
//

import UIKit

class MaterialReciclarCollectionViewCell: UICollectionViewCell {

    static let identifier = "MaterialReciclarCollectionViewCell"
    
    var tomarFotoBtnTapped: (() -> Void)?
    var eliminarBtnTapped: (() -> Void)?
    
    
    @IBOutlet var imgMaterial: UIImageView!
    @IBOutlet var nombreMaterial: UILabel!
    @IBOutlet var plusMinusBtn: UIStackView!
    @IBOutlet var tomarFotoBtn: ViewStyle!
    @IBOutlet var eliminarBtn: ViewStyle!
    @IBOutlet var cantidadMaterial: UILabel!
    @IBOutlet var plusBtn: UIImageView!
    @IBOutlet var minusBtn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyShadow(view: plusMinusBtn)
        applyShadow(view: tomarFotoBtn)
        applyShadow(view: eliminarBtn)
        
        plusMinusBtn.layer.borderColor = RecycleViewController.color_fondo?.cgColor
        plusMinusBtn.layer.borderWidth = 0.1
        plusMinusBtn.layer.cornerRadius = 20
        
        imgMaterial.layer.cornerRadius = min(imgMaterial.frame.width, imgMaterial.frame.height) / 2.0
        
        let borderLayer = CALayer()
        let borderFrame = CGRect(x: -3.0, y: -3.0, width: imgMaterial.frame.size.height + 6.0, height: imgMaterial.frame.size.height + 6.0)
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.frame = borderFrame
        borderLayer.cornerRadius = (imgMaterial.frame.width + 6.0) / 2.0
        borderLayer.borderWidth = 4.0
        borderLayer.borderColor = RecycleViewController.blue?.cgColor
        imgMaterial.layer.addSublayer(borderLayer)
        
        imgMaterial.layer.masksToBounds = false
        
        plusBtn.isUserInteractionEnabled = true
        let plusBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(plusBtnTapped))
        plusBtn.addGestureRecognizer(plusBtnTapGesture)
        
        minusBtn.isUserInteractionEnabled = true
        let minusBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(minusBtnTapped))
        minusBtn.addGestureRecognizer(minusBtnTapGesture)
    }
    
    @objc func plusBtnTapped() {
        var curCantidad = Int(self.cantidadMaterial.text ?? "1") ?? 1
        
        curCantidad += 1
        self.cantidadMaterial.text = String(curCantidad)
    }
    
    @objc func minusBtnTapped() {
        var curCantidad = Int(self.cantidadMaterial.text ?? "1") ?? 1
        
        if (curCantidad > 1) {
            curCantidad -= 1
            self.cantidadMaterial.text = String(curCantidad)
        }
    }
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
    }

    public func configure(with imgM: UIImage, nombreM: String) {
        imgMaterial.image = imgM
        nombreMaterial.text = nombreM
    }
    
    static func nib() -> UINib {
        return UINib(nibName: MaterialReciclarCollectionViewCell.identifier, bundle: nil)
    }
}
