//
//  MaterialesVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 20/11/23.
//

import UIKit


class MaterialesVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var materialArray: [Material] = []
    
    var popUpTomarFoto: MTR_tomarFoto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpTomarFoto = MTR_tomarFoto(frame: self.view.frame, inView: self)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.layer.frame.width - 16,
        height: 220)
        collectionView.collectionViewLayout = layout
        
        self.collectionView.register(HeaderMaterialCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMaterialCollectionReusableView.identifier)
        self.collectionView.register(MaterialReciclarCollectionViewCell.nib(), forCellWithReuseIdentifier: MaterialReciclarCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

// función para manejar el click en una de las recolecciones
extension MaterialesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    
    }
}

// función para establecer los valores decada recolección en el collection view
extension MaterialesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return materialArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaterialReciclarCollectionViewCell.identifier, for: indexPath) as! MaterialReciclarCollectionViewCell
        
        self.popUpTomarFoto.container.customize()
        
        cell.tomarFotoBtnTapped = { [self] in
            // Handle the button tap here
            print("Tomar Foto")
            
            self.popUpTomarFoto.isUserInteractionEnabled = true
            
            // funciones para botones de los popups
            self.popUpTomarFoto.verGaleriaBtn.addTarget(self, action: #selector(self.verGaleriaBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpTomarFoto)
            
            self.popUpTomarFoto.cancelarBtn.addTarget(self, action: #selector(self.cancelarBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpTomarFoto)
            
            self.popUpTomarFoto.tomarFotoBtn.addTarget(self, action: #selector(self.tomarFotoBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpTomarFoto)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            self.popUpTomarFoto.addGestureRecognizer(tapGestureRecognizer)
            
        }
        
        cell.eliminarBtnTapped = { [weak self] in
           
            // Check if the index is within the valid range
            guard let indexPath = self?.collectionView.indexPath(for: cell),
                  indexPath.item < (self?.materialArray.count)! else {
                print("Invalid index or material array is empty")
                return
            }

            // Remove the corresponding material from the array
            self?.materialArray.remove(at: indexPath.item)

            // Update the collection view by deleting the specific item
            self?.collectionView.performBatchUpdates({
                self?.collectionView.deleteItems(at: [indexPath])
            }, completion: { _ in
                // Optionally, you can perform any additional actions after the update
            })
        }

        let material = materialArray[indexPath.item]
        // Assuming you have a configure method in MaterialReciclarCollectionViewCell
        cell.configure(with: UIImage(named: getMaterialIcon(materialName: material.nombre)!)!, nombreM: material.nombre, cantidad: String(material.cantidad), unidad: material.unidad)

        return cell
    }
    
    @objc func tomarFotoBtn(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func verGaleriaBtn(){
        self.popUpTomarFoto.imgMaterial.isHidden = !self.popUpTomarFoto.imgMaterial.isHidden
    }
    
    @objc func handleTapOutsidePopup(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: popUpTomarFoto.container)
            if !popUpTomarFoto.container.bounds.contains(location) {
                popUpTomarFoto.removeFromSuperview()
            }
        }
    }
    
    @objc func cancelarBtn(){
        self.popUpTomarFoto.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMaterialCollectionReusableView.identifier, for: indexPath) as! HeaderMaterialCollectionReusableView
        
        // Set up the closure to handle the tap action
        header.agregarMaterialBtnTapped = { [weak self] in
            // Instantiate the MaterialesSelectionVC from the storyboard
            if let selectionVC = self?.storyboard?.instantiateViewController(withIdentifier: "MaterialesSelection") as? MaterialesSelectionVC {
                
                // Set the delegate
                selectionVC.selectionDelegate = self

                // Push MaterialesSelectionVC onto the navigation stack
                self?.navigationController?.pushViewController(selectionVC, animated: true)
            }
        }
        
        header.configure(with: "99/99/1111", horario: "99:00")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 200)
    }
    
}

extension MaterialesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            self.popUpTomarFoto.imgMaterial.image = UIImage(systemName: "xmark.icloud.fill")
            return
        }
        
        self.popUpTomarFoto.imgMaterial.image = image
    }
}

// función para definir los margenes de cada recolección
extension MaterialesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16 // Adjust left and right margins
        return CGSize(width: width, height: 220)
    }
}

extension MaterialesVC: MaterialesSelectionDelegate {
    func didSelectMaterial(_ selectedMaterial: MaterialSelectionItem) {
        // Add the selected material to your array
        materialArray.append(Material(cantidad: 1, fotoUrl: selectedMaterial.imageName, nombre: selectedMaterial.name, unidad: "Bolsas"))

        // Calculate the index path for the newly added item
        let newIndexPath = IndexPath(item: materialArray.count - 1, section: 0)

        // Insert the new item into the collection view
        collectionView.insertItems(at: [newIndexPath])
    }
}

private func getMaterialIcon(materialName: String) -> String? {
    // Define an array of tuples with material names and corresponding image resource names
    let materialData: [(name: String, imageName: String)] = [
        ("Aceite de Auto", "material_aceite_auto"),
        ("Aceite Usado", "material_aceite_usado"),
        ("Árbol", "material_arbol"),
        ("Baterías", "material_baterias"),
        ("Bicicletas", "material_bici"),
        ("Botellas", "material_botellas"),
        ("Cartón", "material_carton"),
        ("Electrónicos", "material_electronicos"),
        ("Escombros", "material_escombro"),
        ("Industriales", "material_industriales"),
        ("Juguetes", "material_juguetes"),
        ("Libros", "material_libros"),
        ("Llantas", "material_llantas"),
        ("Madera", "material_madera"),
        ("Medicinas", "material_medicina"),
        ("Metal", "material_metal"),
        ("Orgánico", "material_organico"),
        ("Pallets", "material_pallets"),
        ("Papel", "material_papel"),
        ("Pilas", "material_pilas"),
        ("Plásticos", "material_plasticos"),
        ("Ropa", "material_ropa"),
        ("Tapitas", "material_tapitas"),
        ("Tetra Pack", "material_tetrapack"),
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
