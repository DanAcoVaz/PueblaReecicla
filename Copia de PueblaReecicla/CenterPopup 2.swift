//
//  CenterPopUp.swift
//  PueblaReecicla
//
//  Created by Alumno on 14/11/23.
//

import Foundation

import UIKit

class CenterPopup: UIView {
    
    var vc: UIViewController!
    var view: UIView!
    
    @IBOutlet weak var imageCenter: UIImageView!
    @IBOutlet weak var nameCenter: UILabel!
    @IBOutlet weak var numberCenter: UILabel!
    @IBOutlet weak var addCenter: UILabel!
    
    var centerName: String = "Ejmplo"
    var centerNumber: String = "7714834386"
    var centerAddress: String = "Atlixcayotl, Puebla Pue, 78230"
    var centerImage: String = "location"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    func xibSetup(frame: CGRect) {
        self.view = loadNibView()
        view?.frame = frame
        addSubview(view)
        
        // Configura la vista con los datos recibidos
        //imageCenter.image = UIImage(imageLiteralResourceName: centerImage)
        nameCenter.text = centerName
        numberCenter.text = centerNumber
        addCenter.text = centerAddress
    }
    
    func loadNibView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CenterPopup", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

