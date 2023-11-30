//
//  CustomInfoCenter.swift
//  PueblaReecicla
//
//  Created by Alumno on 16/11/23.
//

import UIKit

class CustomInfoCenter: UIView {
    
    @IBOutlet var NamePop: UILabel!
    @IBOutlet var AvailabilityPop: UILabel!
    @IBOutlet var DirectionPop: UILabel!
    @IBOutlet var NameCPop: UILabel!
    @IBOutlet var MapsMapPopup: UIImageView!
    @IBOutlet var WazeMapPopup: UIImageView!
    @IBOutlet var ImagePopUp: UIImageView!
    
    var vc: UIViewController!
    var view: UIView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, inView: UIViewController) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        vc = inView
    }
    
    func xibSetup(frame: CGRect) {
        self.view = loadNibView()
        view?.frame = frame
        addSubview(view)
    }
    
    private func loadNibView() -> UIView {
        // Load the xib file
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomInfoCenters", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    @IBAction func ClosePopup(_ sender: UITapGestureRecognizer) {
        self.removeFromSuperview()
    }
        
}
