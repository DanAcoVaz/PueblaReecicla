//
//  CustomWindowView.swift
//  PueblaReecicla
//
//  Created by Alumno on 14/11/23.
//

import UIKit
import MapKit

class CustomWindowView: UIView {
    // Custom properties and outlets for your callout view
    // Example: labels, buttons, etc.
    
    @IBOutlet var centerImageView: ImageViewStyle!
    @IBOutlet var centerNameLabel: UILabel!
    @IBOutlet var centerPhoneLabel: UILabel!
    @IBOutlet var centerFavoriteLable: UILabel!
    @IBOutlet var centerFavoriteLogo: UIImageView!
    
    var popUp:CustomInfoCenter!
    var infoCenter: Center!
    var context: UIViewController!
    var vc: UIViewController!
    var view: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    

    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        setFavorite()
    }
    
    @IBAction func handleTapMore(_ sender: UITapGestureRecognizer) {
        setMoreInfoPopop()
    }
    
    func xibSetup(frame: CGRect) {
        self.view = loadNibView()
        view?.frame = frame
        addSubview(view)
    }

    private func loadNibView() -> UIView {
        // Load the xib file
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomWindowView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    /*@objc func favoriteCenterTapped(_ gesture: UITapGestureRecognizer) {
        if ((gesture.view as? UIImageView) != nil) {
            setFavorite()
        }
    }*/
    
    func printLabels() {
        print(centerNameLabel ?? "hol0")
        print(centerPhoneLabel ?? "hdfhg")
        print(centerFavoriteLable ?? "dsfgs")
    }
    
    func setUIContext(context: UIViewController) {
        self.context = context
    }
    
    // Initialize the callout view with the associated annotation
    func setLabels(annotation: Center) {
        
        infoCenter = annotation

        
        centerNameLabel?.text = annotation.title ?? ""
        centerPhoneLabel?.text = annotation.CenterPhone ?? ""
        
        if let imageName = annotation.CenterImage, let image = UIImage(named: imageName) {
            centerImageView?.image = image
        } else {
            centerImageView?.image = UIImage(named: "placeholder") // Placeholder image if CenterImage is nil or image loading fails
        }
        
        if let isFavorite = annotation.FavoriteCenter {
            centerFavoriteLable?.text = isFavorite ? "Tus Favoritos" : "Agregar a favoritos"
            centerFavoriteLogo?.image = isFavorite ? UIImage(named: "estrella") : UIImage(named: "favorito")
        } else {
            centerFavoriteLable?.text = "Agregar a favoritos" // Default text if FavoriteCenter is nil
        }
    }

    func setFavorite() {
        
        print("Entre")
        
        infoCenter.FavoriteCenter = !infoCenter.FavoriteCenter!
        
        if let isFavorite = infoCenter.FavoriteCenter {
            centerFavoriteLable?.text = isFavorite ? "Tus Favoritos" : "Agregar a favoritos"
            centerFavoriteLogo?.image = isFavorite ? UIImage(named: "estrella") : UIImage(named: "favorito")
        } else {
            centerFavoriteLable?.text = "Agregar a favoritos" // Default text if FavoriteCenter is nil
        }
        
    }
    
    
    func setMoreInfoPopop() {
        print("Te muestro mi popup")
        self.popUp = CustomInfoCenter(frame: context.view.frame, inView: context)
        context.view.addSubview(popUp)
    }
    
}
