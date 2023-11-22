//
//  MaterialesSelectionVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 21/11/23.
//

import UIKit

protocol MaterialesSelectionDelegate: AnyObject {
    func didSelectMaterial(_ selectedMaterial: MaterialSelectionItem)
}

class MaterialesSelectionVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    weak var selectionDelegate: MaterialesSelectionDelegate?
    
    var materials: [MaterialSelectionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for materialName in getMaterialNames() {
            if let imageName = getMaterialIcon(materialName: materialName) {
                let material = MaterialSelectionItem(name: materialName, imageName: imageName)
                materials.append(material)
            }
        }
        
        self.collectionView.register(MaterialesSelectionCollectionViewCell.nib(), forCellWithReuseIdentifier: MaterialesSelectionCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func getMaterialNames() -> [String] {
        let materialData: [(name: String, _)] = [
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
        return materialData.map { $0.name }
    }
}

// función para manejar el click en una de las recolecciones
extension MaterialesSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedMaterial = materials[indexPath.row]
        
        selectionDelegate?.didSelectMaterial(selectedMaterial)
        
        // Pop back to the previous view controller (MaterialesVC)
        navigationController?.popViewController(animated: true)
    }
}

// función para establecer los valores decada recolección en el collection view
extension MaterialesSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return materials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaterialesSelectionCollectionViewCell.identifier, for: indexPath) as! MaterialesSelectionCollectionViewCell

        let material = materials[indexPath.row]
        cell.configure(with: UIImage(named: material.imageName)!, nombreM: material.name)

        return cell
    }
}

// función para definir los margenes de cada recolección
extension MaterialesSelectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.40
        let height = width // Assuming you want the cells to be square
        return CGSize(width: width, height: height)
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

struct MaterialSelectionItem {
    let name: String
    let imageName: String
}
