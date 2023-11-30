//
//  CustomInfoCenter.swift
//  PueblaReecicla
//
//  Created by Alumno on 16/11/23.
//

import UIKit

class CustomInfoCenter: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet var NamePop: UILabel!
    @IBOutlet var AvailabilityPop: UILabel!
    @IBOutlet var DirectionPop: UILabel!
    @IBOutlet var MapsMapPopup: UIImageView!
    @IBOutlet var WazeMapPopup: UIImageView!
    @IBOutlet var ImagePopUp: UIImageView!
    @IBOutlet var HoursCenter: UILabel!
    @IBOutlet var MaterialsCollectionView: UICollectionView!
    
    
    var Latitud: Double!
    var Longitud: Double!
    var ImageURL: String!
    var Materials: [MaterialInfo]!
    
    var vc: UIViewController!
    var view: UIView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, inView: UIViewController, CenterName: String, CenterDirection: String, CenterAvailability: String, CenterImage: String, Lon: Double, Lat: Double, Days: String, Materiales: [MaterialInfo]) {
        super.init(frame: frame)
        xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        vc = inView
        NamePop.text = CenterName
        DirectionPop.text = CenterDirection
        AvailabilityPop.text = Days
        HoursCenter.text = CenterAvailability
        ImageURL = CenterImage
        Longitud = Lon
        Latitud = Lat
        Materials = Materiales
        
        loadImageFromURL()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        
        MaterialsCollectionView.collectionViewLayout = layout
        MaterialsCollectionView.register(MapMaterialCollectionViewCell.nib(), forCellWithReuseIdentifier: MapMaterialCollectionViewCell.identifier)
        MaterialsCollectionView.delegate = self
        MaterialsCollectionView.dataSource = self
        
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
    
    @IBAction func MapsMapLink(_ sender: Any) {
        print("Mapa de Maps")
    }
    
    @IBAction func WazeMapLink(_ sender: Any) {
        print("Mapa de Waze")
    }
    
    @IBAction func ClosePopup(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    func loadImageFromURL() {
        
        // Load Image from Center Initialization
        if let imageURLString = ImageURL, !imageURLString.isEmpty,
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
                            self.ImagePopUp?.image = image
                        }
                    }
                } else {
                    // Si hay un error o no se pueden obtener datos, usa una imagen de relleno
                    DispatchQueue.main.async {
                        //self.ImagePopUp?.image = UIImage(named: "placeholder")
                    }
                }
            }.resume()
        } else {
            // Si la URL está vacía o no se puede crear un URL válido, usa una imagen de relleno
            //self.ImagePopUp?.image = UIImage(named: "placeholder")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Materials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapMaterialCollectionViewCell.identifier, for: indexPath) as! MapMaterialCollectionViewCell
        let categoria = Materials[indexPath.item]
        
        cell.configure(with: categoria.imageUrl, name: categoria.documentID)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace: CGFloat = 10 // Espacio entre las celdas
        let availableWidth = collectionView.bounds.width - paddingSpace * 4 // (Espacio total - espacio entre celdas * número de celdas por fila + espacio al principio y final)

        let widthPerItem = availableWidth / 2.5 // Calcula el ancho para tres celdas por fila
        return CGSize(width: widthPerItem, height: widthPerItem) // Devuelve el tamaño calculado
    }

        
}
