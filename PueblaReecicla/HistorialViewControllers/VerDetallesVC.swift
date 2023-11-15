//
//  VerDetallesVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 14/11/23.
//

import UIKit

class VerDetallesVC: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MaterialCollectionViewCell.nib(), forCellWithReuseIdentifier: MaterialCollectionViewCell.identifier)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// función para manejar el click en una de las recolecciones
extension VerDetallesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        print("You tapped me")

    }
}

// función para establecer los valores decada recolección en el collection view
extension VerDetallesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MaterialCollectionViewCell.identifier, for: indexPath) as! MaterialCollectionViewCell
        
        cell.configure(with: UIImage(named: "material_aceite_usado")!, nombreM: "Aceite de Auto", unidadM: "Unidad: 4", cantidadM: "Cantidad: 2")
        
        return cell
    }
    
}

// función para definir los margenes de cada recolección
extension VerDetallesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20 // Adjust left and right margins
        return CGSize(width: width, height: 140)
    }
}
