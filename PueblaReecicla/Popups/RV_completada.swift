//
//  RV_iniciada.swift
//  PueblaReecicla
//
//  Created by Administrador on 11/11/23.
//

import UIKit

class RV_completada: UIView {
    
    var vc: UIViewController!
    var view: UIView!
    
    @IBOutlet weak var nameRecolector: UILabel!
    @IBOutlet weak var imageRecolector: UIImageView!
    @IBOutlet weak var verDetallesBtn: ButtonStyle!
    @IBOutlet weak var continuarBtn: ButtonStyle!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var seccionCalificacion: UIStackView!
    
    @IBOutlet var starButtonCollection: [UIButton]!
    
    var rating = 0 {
        didSet {
            continuarBtn.backgroundColor = RecycleViewController.green
            
            for starButton in starButtonCollection {
                let imgName = (starButton.tag < rating ? "icon_star" : "icon_star_empty")
                starButton.setImage(UIImage(named: imgName), for: .normal)
            }
            print("new Rating: \(rating)")
        }
    }
    
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
        let nib = UINib(nibName: "RV_completada", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    @IBAction func starButtonPressed(_ sender: UIButton) {
        //continuarBtn.backgroundColor = RecycleViewController.green
        rating = sender.tag + 1
    }
    
}

