//
//  RecycleVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 08/11/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class RecycleViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    // constantes para definir los estas de las recolecciones
    static let iniciada = "Iniciada"
    static let enProceso = "En Proceso"
    static let completada = "Completada"
    static let cancelada = "Cancelada"
    
    // constantes para los colores del estado de una recolección
    static let golden = UIColor(named: "ColorTerciario")
    static let blue = UIColor(named: "ColorSecundario")
    static let green = UIColor(named: "AccentColor")
    static let red = UIColor(named: "ColorNegativo")
    
    // user id
    let userID = "user_id_2"  // se debe cambiar por el obtenido en FirebaseAuth
    
    // arreglo para almacenar los elementos del collection view
    var recolecciones: Recolecciones!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgFondoBlanco : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"FONDO-B-PRESENTA")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        
        collectionView.backgroundView = imgFondoBlanco
        
        collectionView.register(HistorialCollectionViewCell.nib(), forCellWithReuseIdentifier: HistorialCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Populate the array with sample data
        recolecciones = Recolecciones()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recolecciones.loadData(userID: userID) {
            self.collectionView.reloadData()
        }
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
        return recolecciones.recoleccionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistorialCollectionViewCell.identifier, for: indexPath) as! HistorialCollectionViewCell
        
        let recoleccion = recolecciones.recoleccionArray[indexPath.row]
        
        let materialesCount = recoleccion.materiales.count
        var totalMateriales = ""
        if(materialesCount > 1) {
            totalMateriales = "\(materialesCount) materiales"
        } else {
            totalMateriales = "\(materialesCount) material"
        }
        
        let colorEstado = getColorForEstado(estado: recoleccion.estado)
        
        cell.configure(with: colorEstado, fecha: recoleccion.fechaRecoleccion, horario: recoleccion.horaRecoleccionFinal, totalMateriales: totalMateriales, estadoTexto: recoleccion.estado)
        
        return cell
    }
}

extension RecycleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20 // Adjust left and right margins
        return CGSize(width: width, height: 140)
    }
}

func getColorForEstado(estado: String) -> UIColor {
    if(estado == RecycleViewController.iniciada) {
        return RecycleViewController.golden!
    }
    else if(estado == RecycleViewController.enProceso) {
        return RecycleViewController.blue!
    }
    else if(estado == RecycleViewController.completada) {
        return RecycleViewController.green!
    }
    else {
        return RecycleViewController.red!
    }
}

struct RecycleItem {
    let color: UIColor
    let fecha: String
    let horario: String
    let materiales: String
    let estadoTexto: String
    let estadoTextoColor: UIColor
}


