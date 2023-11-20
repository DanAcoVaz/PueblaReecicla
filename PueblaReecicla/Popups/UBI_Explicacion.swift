//
//  UBI_Explicacion.swift
//  PueblaReecicla
//
//  Created by Administrador on 20/11/23.
//

import UIKit

class UBI_Explicacion: UIView {

    var vc: UIViewController!
    var view: UIView!
    
    @IBOutlet weak var comprendoBtn: ButtonStyle!
    
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
        let nib = UINib(nibName: "UBI_Explicacion", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}
