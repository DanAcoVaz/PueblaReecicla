//
//  HeaderMaterialCollectionReusableView.swift
//  PueblaReecicla
//
//  Created by Administrador on 21/11/23.
//

import UIKit

class HeaderMaterialCollectionReusableView: UICollectionReusableView {

    static let identifier = "HeaderMaterialCollectionReusableView"

    @IBOutlet var fechaLbl: UILabel!
    @IBOutlet var horarioLbl: UILabel!
    @IBOutlet var agregarMaterialBtn: ButtonStyle!
    
    var agregarMaterialBtnTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*agregarMaterialBtn.layer.shadowColor = UIColor.black.cgColor
        agregarMaterialBtn.layer.shadowOpacity = 0.5
        agregarMaterialBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
        agregarMaterialBtn.layer.shadowRadius = 2*/
    }
    
    public func configure(with fecha: String, horario: String) {
        fechaLbl.text = fecha
        horarioLbl.text = horario
    }
    
    @IBAction func agregarMaterialNuevo(_ sender: ButtonStyle) {
        agregarMaterialBtnTapped?()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: HeaderMaterialCollectionReusableView.identifier, bundle: nil)
    }
}
