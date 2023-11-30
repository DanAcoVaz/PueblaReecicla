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
    

    @IBOutlet weak var nameRecolector: UILabel!
    @IBOutlet weak var imageRecolector: UIImageView!
    @IBOutlet weak var telefonoRecolector: UILabel!
    @IBOutlet weak var calificacionRecolector: UILabel!
    
    @IBOutlet weak var verDetallesBtn: ButtonStyle!
    @IBOutlet weak var continuarBtn: ButtonStyle!
    @IBOutlet weak var cancelarOrden: ButtonStyle!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
        let nib = UINib(nibName: "RV_enProceso", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

