//
//  RV_iniciada.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import UIKit

class RV_enProceso: UIView {
    
    var vc: UIViewController!
    var view: UIView!
    
    @IBOutlet var verDetallesBtn: UIButton!
    @IBOutlet var cancelarBtn: UIButton!
    @IBOutlet var continuarBtn: UIButton!
    
    @IBOutlet var container: ViewStyle!
    
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
        let nib = UINib(nibName: "RV_iniciada", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

