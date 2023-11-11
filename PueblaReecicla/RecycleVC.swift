//
//  RecycleVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 08/11/23.
//

import UIKit

class RecycleViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(HistorialCollectionViewCell.nib(), forCellWithReuseIdentifier: HistorialCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }


}


extension RecycleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        print("You tapped me in row: ")
        print(indexPath.row)
    }
}

extension RecycleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistorialCollectionViewCell.identifier, for: indexPath) as! HistorialCollectionViewCell
        
        cell.configure(with: UIColor(named: "green")!, fecha: "14/11/2023", horario: "9:00", materiales: "2 materiales", estadoTexto: "Completado", estadoTextoColor: UIColor(named: "green")!)
        
        return cell
    }
    
    
}

extension RecycleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20 // Adjust left and right margins
        return CGSize(width: width, height: 140-20)
    }
}

