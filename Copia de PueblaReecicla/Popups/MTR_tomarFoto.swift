//
//  MTR_tomarFoto.swift
//  PueblaReecicla
//
//  Created by Administrador on 22/11/23.
//

import UIKit

class MTR_tomarFoto: UIView {
    
    var vc: UIViewController!
    var view: UIView!
    
    @IBOutlet var container: UIStackView!
    @IBOutlet weak var imgMaterial: UIImageView!
    @IBOutlet var verGaleriaBtn: ButtonStyle!
    @IBOutlet var tomarFotoBtn: ButtonStyle!
    @IBOutlet var cancelarBtn: ButtonStyle!
    
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
        let nib = UINib(nibName: "MTR_tomarFoto", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
}

extension UIStackView {
    func customize(backgroundColor: UIColor = .white, radiusSize: CGFloat = 50) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

        // Apply corner radius directly to the stack view
        layer.cornerRadius = radiusSize
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
