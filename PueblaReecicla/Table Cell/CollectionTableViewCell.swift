//
//  CollectionTableViewCell.swift
//  PueblaReecicla
//
//  Created by Alumno on 25/11/23.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    static let identifier = "CollectionTableView"
    static func nib() -> UINib {
        return UINib(nibName: "CollectionTableViewCell", bundle: nil)
    }
    
    func configure(with models: [Categoria]) {
        self.CategoriesModels = models
        collectionView.reloadData()
    }
    
    @IBOutlet var collectionView: UICollectionView!
    var CategoriesModels = [Categoria]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(CategoriaCollectionViewCell.nib(), forCellWithReuseIdentifier: CategoriaCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    //Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoriesModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriaCollectionViewCell.identifier, for: indexPath) as! CategoriaCollectionViewCell
        cell.configure(with: CategoriesModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
}
