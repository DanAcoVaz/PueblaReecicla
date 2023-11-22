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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.layer.frame.width - 16,
        height: 220)
        collectionView.collectionViewLayout = layout
        
        self.collectionView.register(HeaderMaterialCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMaterialCollectionReusableView.identifier)
        self.collectionView.register(MaterialReciclarCollectionViewCell.nib(), forCellWithReuseIdentifier: MaterialReciclarCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    
    func didSelectMaterial(_ selectedMaterial: Material) {
        materialArray.append(selectedMaterial)
        collectionView.reloadData()
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
        
        cell.tomarFotoBtnTapped = { [self] in
            // Handle the button tap here
            print("Tomar Foto")
            
        }
        
        cell.eliminarBtnTapped = { [weak self] in
            // Handle the button tap here
            print("Eliminar Material")
            
        }

        let material = materialArray[indexPath.item]
        // Assuming you have a configure method in MaterialReciclarCollectionViewCell
        cell.configure(with: UIImage(named: getMaterialIcon(materialName: material.nombre)!)!, nombreM: material.nombre)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMaterialCollectionReusableView.identifier, for: indexPath) as! HeaderMaterialCollectionReusableView
        
        // Set up the closure to handle the tap action
        header.agregarMaterialBtnTapped = { [weak self] in
            // Handle the button tap here
            print("Agregar Material Button Tapped")
            // Instantiate the MaterialesSelectionVC from the storyboard
            if let selectionVC = self?.storyboard?.instantiateViewController(withIdentifier: "MaterialesSelectionVC") as? MaterialesVC {
                // Pass the existing array of materials to MaterialesSelectionVC
                //selectionVC.materialsForSelection = self?.materialArray ?? []
                
                // Step 10: Set the delegate
                //selectionVC.selectionDelegate = self
                
                // Present MaterialesSelectionVC
                self?.present(selectionVC, animated: true, completion: nil)
            }
        }
        
        header.configure(with: "99/99/1111", horario: "99:00")
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 200)
    }
    
}

// función para definir los margenes de cada recolección
extension MaterialesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16 // Adjust left and right margins
        return CGSize(width: width, height: 220)
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
