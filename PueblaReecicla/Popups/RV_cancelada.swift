//
//  RV_cancelada.swift
//  PueblaReecicla
//
//  Created by Administrador on 14/11/23.
//

import UIKit

class RV_cancelada: UIView {
    
    var vc: UIViewController!
    var view: UIView!

    @IBOutlet weak var verDetallesBtn: ButtonStyle!
    @IBOutlet weak var verCentrosBtn: ButtonStyle!
    @IBOutlet weak var continuarBtn: ButtonStyle!
    
    @IBOutlet weak var container: UIView!
    
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
        let nib = UINib(nibName: "RV_cancelada", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

