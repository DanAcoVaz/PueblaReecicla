//
//  VerDetallesVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 14/11/23.
//

import UIKit

class VerDetallesVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var viewTipoEntrega: ViewStyle!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var horario: UILabel!
    
    @IBOutlet weak var tipoEntregaTxt: UILabel!
    @IBOutlet weak var tipoEntregaImg: UIImageView!
    
    var popUpVerFoto: VD_verFoto!
    
    var curItem: Recoleccion!
    
    var materiales: [String: Material] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (curItem != nil) {
            fecha.text = curItem.fechaRecoleccion
            horario.text = curItem.horaRecoleccionFinal
            
            if (!curItem.enPersona) {
                tipoEntregaImg.image = UIImage(named: "icon_home_blue")
                tipoEntregaTxt.text = "Entrega en Puerta"
            }
        }
        
        self.popUpVerFoto = VD_verFoto(frame: self.view.frame, inView: self)
    
        viewTipoEntrega.layer.shadowColor = UIColor.black.cgColor
        viewTipoEntrega.layer.shadowOpacity = 0.5
        viewTipoEntrega.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewTipoEntrega.layer.shadowRadius = 4
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.layer.frame.width - 8,
        height: 120)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MaterialCollectionViewCell.nib(), forCellWithReuseIdentifier: MaterialCollectionViewCell.identifier)
        
    }

}

// función para manejar el click en una de las recolecciones
extension VerDetallesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// función para establecer los valores decada recolección en el collection view
extension VerDetallesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.materiales.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaterialCollectionViewCell.identifier, for: indexPath) as! MaterialCollectionViewCell
        
        // Access the current material key
        let material = materiales["material_\(indexPath.item)"]
        
        if(material?.fotoUrl == "") {
            cell.verFotoBtn.tintColor = RecycleViewController.light_green
            cell.verFotoBtn.setTitle("Sin Foto", for: .normal)
            cell.verFotoBtn.setTitleColor(UIColor.white, for: .normal)
            cell.verFotoBtn.isEnabled = false
            cell.verFotoBtn.layer.masksToBounds = true
        } else {
            cell.verFotoBtn.tintColor = RecycleViewController.green
            cell.verFotoBtn.setTitle("Ver Foto", for: .normal)
            cell.verFotoBtn.setTitleColor(UIColor.white, for: .normal)
            cell.verFotoBtn.isEnabled = true
            cell.verFotoBtn.layer.masksToBounds = true
        }
        
        let imgMaterial = UIImage(named: getMaterialIcon(materialName: material?.nombre ?? "icon_loading") ?? "icon_loading")
        
        cell.verFotoButtonTapped = { [self] in
            
            loadImage(from: material!.fotoUrl, into: self.popUpVerFoto.imgMaterial, placeholder: "icon_loading", defaultImage: "xmark.icloud.fill")
            
            self.popUpVerFoto.isUserInteractionEnabled = true
            
            // funciones para botones de los popups
            self.popUpVerFoto.continuarBtn.addTarget(self, action: #selector(self.continuarBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpVerFoto)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            self.popUpVerFoto.addGestureRecognizer(tapGestureRecognizer)
            
        }
        
        cell.configure(with: imgMaterial!, nombreM: material!.nombre, unidadM: "Unidad: \(material!.unidad)", cantidadM: "Cantidad: \(String(describing: material!.cantidad))")
        
        
        
        return cell
    }
    
    
    @objc func handleTapOutsidePopup(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: popUpVerFoto.container)
            if !popUpVerFoto.container.bounds.contains(location) {
                popUpVerFoto.removeFromSuperview()
            }
        }
    }
    
    @objc func continuarBtn(){
        self.popUpVerFoto.removeFromSuperview()
    }
    
    func loadImage(from imageUrlString: String, into imageView: UIImageView, placeholder: String, defaultImage: String) {
        // Set a placeholder image while loading.
        imageView.image = UIImage(named: placeholder)
        
        // Convert the URL string to a URL object.
        guard let imageUrl = URL(string: imageUrlString) else {
            // Display a default image if the URL is invalid.
            imageView.image = UIImage(named: defaultImage)
            print("Invalid URL for image: \(imageUrlString)")
            return
        }
        
        // Create a URL session configuration.
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // Create a data task to download the image.
        let dataTask = session.dataTask(with: imageUrl) { [] (data, response, error) in
            // Check for errors and ensure there is data.
            guard error == nil, let imageData = data else {
                // Display a default image if there's an error.
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: defaultImage)
                }
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Create a UIImage from the downloaded data.
            if let image = UIImage(data: imageData) {
                // Update the image view on the main thread.
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        
        // Start the data task.
        dataTask.resume()
    }
    
}
    
    private func getMaterialIcon(materialName: String) -> String? {
        // Define an array of tuples with material names and corresponding image resource names
        let materialData: [(name: String, imageName: String)] = [
            ("Aceite Auto", "material_aceite_auto"),
            ("Aceite Usado", "material_aceite_usado"),
            ("Árbol", "material_arbol"),
            ("Baterias", "material_baterias"),
            ("Bicicletas", "material_bici"),
            ("Botellas", "material_botellas"),
            ("Cartón", "material_carton"),
            ("Electrónicos", "material_electronicos"),
            ("Escombros", "material_escombro"),
            ("Industriales", "material_industriales"),
            ("Juguetes", "material_juguetes"),
            ("Lata Chilera", "material_metal"),
            ("Lata", "material_metal"),
            ("Libros", "material_libros"),
            ("Llantas", "material_llantas"),
            ("Madera", "material_madera"),
            ("Medicina", "material_medicina"),
            ("Metal", "material_metal"),
            ("Orgánico", "material_organico"),
            ("Pallets", "material_pallets"),
            ("Papel", "material_papel"),
            ("Pilas", "material_pilas"),
            ("Plásticos", "material_plasticos"),
            ("Ropa", "material_ropa"),
            ("Tapitas", "material_tapitas"),
            ("Tetrapack", "material_tetrapack"),
            ("Toner", "material_toner"),
            ("Voluminoso", "material_voluminoso")
        ]
        
        for (_, data) in materialData.enumerated() {
            if data.name == materialName {
                // Return the image resource name if the material name is found
                return data.imageName
            }
        }
        
        return "icon_loading" // Return nil if the name is not found
    }

// función para definir los margenes de cada recolección
extension VerDetallesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - 8
        return CGSize(width: width, height: 110)
    }
}
