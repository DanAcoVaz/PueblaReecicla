//
//  RV_completada_sinCalif.swift
//  PueblaReecicla
//
//  Created by Administrador on 13/11/23.
//

import UIKit

class RV_comp_sinCalif: UIView {
    
    var vc: UIViewController!
    var view: UIView!
    
    @IBOutlet weak var verDetalles: ButtonStyle!
    @IBOutlet weak var continuarBtn: ButtonStyle!
    @IBOutlet weak var container: ViewStyle!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init (frame: CGRect, inView: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        vc = inView
    }
    
    func xibSetup (frame: CGRect) {
        self.view = loadNibView()
        view.frame = frame
        addSubview(view)
        
    }
    
    
    func loadNibView() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RV_comp_sinCalif", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
}
