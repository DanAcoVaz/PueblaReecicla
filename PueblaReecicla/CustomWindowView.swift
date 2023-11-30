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
    
    var phoneNumer: String!
    
    var popUp:CustomInfoCenter!
    var infoCenter: Center!
    var context: UIViewController!
    var vc: UIViewController!
    var view: UIView!
    
    static var mapViewFrame: CGRect!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @IBAction func handleCellphone(_ sender: UITapGestureRecognizer) {
        callPhoneNumber()
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
    
    func callPhoneNumber() {
        if centerPhoneLabel.text != "Sin Numero" {
            if let phoneURL = URL(string: "tel://" + phoneNumer) {
                if UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                }
            }
        }
        
    }
    
    
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

        //Load Center Name from Center Initialization
        centerNameLabel?.text = annotation.title ?? ""
        
        //Load Image from Center Initialization
        if let centerPhone = annotation.CenterPhone, !centerPhone.isEmpty, !centerPhone.lowercased().contains("nan") {
            centerPhoneLabel?.text = centerPhone
            phoneNumer = centerPhone
        } else {
            centerPhoneLabel?.text = "Sin Numero"
        }
        
        // Load Image from Center Initialization
        if let imageURLString = annotation.CenterImage, !imageURLString.isEmpty,
           let imageURL = URL(string: imageURLString) {
            // Si la URL no está vacía y se puede convertir a un URL válido
            // Intenta cargar la imagen desde la URL
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                // Verificar si hay datos y si no hay errores
                if let data = data, error == nil {
                    // Crear una imagen desde los datos obtenidos
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            // Actualizar la imageView en el hilo principal
                            self.centerImageView?.image = image
                        }
                    }
                } else {
                    // Si hay un error o no se pueden obtener datos, usa una imagen de relleno
                    DispatchQueue.main.async {
                        //self.centerImageView?.image = UIImage(named: "placeholder")
                    }
                }
            }.resume()
        } else {
            // Si la URL está vacía o no se puede crear un URL válido, usa una imagen de relleno
            //self.centerImageView?.image = UIImage(named: "placeholder")
        }
        
        // Load Center Favorite State from Center Initialization
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
        let Name = self.infoCenter.title
        let Direction = self.infoCenter.CenterDirection
        let Availability = self.infoCenter.CenterOpen + " - " + self.infoCenter.CenterClose
        let Latitude = self.infoCenter.CenterLatitud
        let Longitude = self.infoCenter.CenterLongitud
        let Image = self.infoCenter.CenterImage
        let days = self.infoCenter.CenterDays.joined(separator: " - ")
        let materials = self.infoCenter.CenterMateriales
        
        self.popUp = CustomInfoCenter(frame: CustomWindowView.mapViewFrame, inView: context, CenterName: Name!, CenterDirection: Direction, CenterAvailability: Availability, CenterImage: Image!, Lon: Longitude, Lat: Latitude, Days: days, Materiales: materials!)
        
        
        
        context.view.addSubview(popUp)
        
    }
    
}
