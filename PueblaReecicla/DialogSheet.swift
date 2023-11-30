//
//  DialogSheet.swift
//  PueblaReecicla
//
//  Created by Alumno on 16/11/23.
//

import UIKit

class DialogSheet: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   

    @IBOutlet var collectionView: UICollectionView!

    
    //Lista de Categorias
    var Categories: Categorias!
    var isDoneCategorias: Bool!
    var Father: MapViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Categories = Categorias()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(CategoriaCollectionViewCell.nib(), forCellWithReuseIdentifier:  CategoriaCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        isDoneCategorias = false
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isDoneCategorias {
            Categories.loadData{
                self.collectionView.reloadData()
            }
            isDoneCategorias = true
        }
        
    }
    
    func closeBottomPopOver() {
        if let presentingViewController = navigationController?.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func handleShowCategory(Choice: String) {
        Father.showCategoryCenter(Category: Choice)
        closeBottomPopOver()
    }
    
    @IBAction func handleAllCenters() {
        Father.showAllCenters()
        closeBottomPopOver()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.deselectItem(at: indexPath, animated: true)
        let selectedItem = Categories.categorias[indexPath.item]
        handleShowCategory(Choice: selectedItem.documentID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Categories.categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriaCollectionViewCell.identifier, for: indexPath) as! CategoriaCollectionViewCell
        let categoria = Categories.categorias[indexPath.item]
        
        cell.configure(with: categoria.imageUrl, name: categoria.documentID)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace: CGFloat = 10 // Espacio entre las celdas
        let availableWidth = collectionView.bounds.width - paddingSpace * 4 // (Espacio total - espacio entre celdas * número de celdas por fila + espacio al principio y final)

        let widthPerItem = availableWidth / 3 // Calcula el ancho para tres celdas por fila
        return CGSize(width: widthPerItem, height: widthPerItem) // Devuelve el tamaño calculado
    }


}

