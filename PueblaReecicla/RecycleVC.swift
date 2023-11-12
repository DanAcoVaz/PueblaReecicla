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
    
    // popups
    var popUpIniciada: RV_iniciada!
    var popUpEnProceso: RV_enProceso!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // inicializan los Popups
        self.popUpIniciada = RV_iniciada(frame: self.view.frame, inView: self)
        
        self.popUpEnProceso = RV_enProceso(frame: self.view.frame, inView: self)
        popUpEnProceso.scrollView.layer.cornerRadius = 30
        popUpEnProceso.imageRecolector.layer.cornerRadius = min(popUpEnProceso.imageRecolector.frame.width, popUpEnProceso.imageRecolector.frame.height) / 2.0
        popUpEnProceso.imageRecolector.layer.masksToBounds = true
        
        let imgFondoBlanco : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"FONDO-B-PRESENTA")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        
        // se configura el collection view
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
    
    // función para mostrar el pop up correcto acorde al estado dado
    func showCorrectPopup(estado: String) {
        
        // Customize your pop-up based on the state
        if estado == RecycleViewController.iniciada {
            popUpIniciada.isUserInteractionEnabled = true
            // inicializar PopUps
            popUpIniciada.continuarBtn.addTarget(self, action: #selector(continuarBtnIni), for: .touchUpInside)
            self.view.addSubview(popUpIniciada)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopupIni))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpIniciada.addGestureRecognizer(tapGestureRecognizer)
            
        }
        else if estado == RecycleViewController.enProceso {
            popUpEnProceso.isUserInteractionEnabled = true
            // inicializar PopUps
            popUpEnProceso.continuarBtn.addTarget(self, action: #selector(continuarBtnEnPro), for: .touchUpInside)
            self.view.addSubview(popUpEnProceso)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopupEnPro))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpEnProceso.addGestureRecognizer(tapGestureRecognizer)
        }
        else if estado == RecycleViewController.completada {
            print(estado)
        }
        else {
            print(estado)
        }
        
    }
    
    // Handle taps outside of popUpIniciada
    @objc func handleTapOutsidePopupIni(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: popUpIniciada.container)
            if !popUpIniciada.container.bounds.contains(location) {
                popUpIniciada.removeFromSuperview()
            }
        }
    }
    
    // Handle taps outside of popUpIniciada
    @objc func handleTapOutsidePopupEnPro(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: popUpEnProceso.scrollView)
            if !popUpEnProceso.scrollView.bounds.contains(location) {
                popUpEnProceso.removeFromSuperview()
            }
        }
    }

    
    @objc func continuarBtnIni(){
        self.popUpIniciada.removeFromSuperview()
    }
    
    @objc func continuarBtnEnPro(){
        self.popUpEnProceso.removeFromSuperview()
    }

}

// función para manejar el click en una de las recolecciones
extension RecycleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let recoleccion = recolecciones.recoleccionArray[indexPath.row]
        
        showCorrectPopup(estado: recoleccion.estado)
        
    }
}

// función para establecer los valores decada recolección en el collection view
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

// función para definir los margenes de cada recolección
extension RecycleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20 // Adjust left and right margins
        return CGSize(width: width, height: 140)
    }
}

// función para regresar el color correcto acorde al estado dado
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
