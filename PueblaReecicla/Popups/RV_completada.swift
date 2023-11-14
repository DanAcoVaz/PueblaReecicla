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
    
    
    @IBOutlet weak var nameRecollector: UILabel!
    @IBOutlet weak var imgRecolector: UIImageView!
    @IBOutlet weak var verDetallesButton: ButtonStyle!
    @IBOutlet weak var continuarButton: ButtonStyle!
    
    @IBOutlet weak var ScrollVW: UIScrollView!
    
    @IBOutlet weak var sectCalificado: UIStackView!

    @IBOutlet var starBtnCollect: [UIButton]!
    
    var rating = 0 {
        didSet {
            for starButton in starBtnCollect {
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
    
    
    @IBAction func starBtnPressed(_ sender: UIButton) {
            //continuarBtn.backgroundColor = RecycleViewController.green
            rating = sender.tag + 1
        }
    
}

