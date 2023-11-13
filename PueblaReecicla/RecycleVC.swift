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
    static let light_green = UIColor(named: "light_green")
    
    // user id
    let userID = "user_id_2"  // se debe cambiar por el obtenido en FirebaseAuth
    
    // arreglo para almacenar los elementos del collection view
    var recolecciones: Recolecciones!
    
    // popups
    var popUpIniciada: RV_iniciada!
    var popUpEnProceso: RV_enProceso!
    var popUpCompletada: RV_completada!
    
    // referencia al elemento actual del collection view
    var curItem: Recoleccion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // inicializan los Popups
        self.popUpIniciada = RV_iniciada(frame: self.view.frame, inView: self)
        
        self.popUpEnProceso = RV_enProceso(frame: self.view.frame, inView: self)
        popUpEnProceso.scrollView.layer.cornerRadius = 30
        popUpEnProceso.imageRecolector.layer.cornerRadius = min(popUpEnProceso.imageRecolector.frame.width, popUpEnProceso.imageRecolector.frame.height) / 2.0
        popUpEnProceso.imageRecolector.layer.masksToBounds = true
        
        self.popUpCompletada = RV_completada(frame: self.view.frame, inView: self)
        popUpCompletada.scrollView.layer.cornerRadius = 30
        popUpCompletada.imageRecolector.layer.cornerRadius = min(popUpCompletada.imageRecolector.frame.width, popUpCompletada.imageRecolector.frame.height) / 2.0
        popUpCompletada.imageRecolector.layer.masksToBounds = true
        
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
    func showCorrectPopup(recoleccion: Recoleccion) {
        self.curItem = recoleccion
        let estado = curItem.estado
        
        // Customize your pop-up based on the state
        if estado == RecycleViewController.iniciada {
            popUpIniciada.isUserInteractionEnabled = true
            
            // funciones para botones de los popups
            popUpIniciada.continuarBtn.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
            self.view.addSubview(popUpIniciada)
            
            popUpIniciada.cancelarBtn.addTarget(self, action: #selector(cancelarBtn), for: .touchUpInside)
            self.view.addSubview(popUpIniciada)
            
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpIniciada.addGestureRecognizer(tapGestureRecognizer)
            
        }
        else if estado == RecycleViewController.enProceso {
            // se cambian las partes del Popup con la info de FB
            popUpEnProceso.nameRecolector.text = "\(curItem.recolector.nombre) \(curItem.recolector.apellidos)"
            popUpEnProceso.telefonoRecolector.text = curItem.recolector.telefono
            popUpEnProceso.calificacionRecolector.text = String(format: "%.1f", curItem.recolector.suma_reseñas / curItem.recolector.cantidad_reseñas)

            
            popUpEnProceso.isUserInteractionEnabled = true
            // inicializar PopUps
            popUpEnProceso.continuarBtn.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
            self.view.addSubview(popUpEnProceso)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpEnProceso.addGestureRecognizer(tapGestureRecognizer)
        }
        else if estado == RecycleViewController.completada {
            
            if (curItem.calificado == true) {
                popUpCompletada.seccionCalificacion.isHidden = true
                popUpCompletada.continuarBtn.backgroundColor = RecycleViewController.green
            } else {
                popUpCompletada.seccionCalificacion.isHidden = false
                popUpCompletada.continuarBtn.backgroundColor = RecycleViewController.light_green
            }
            // se cambian las partes del Popup con la info de FB
            popUpCompletada.nameRecolector.text = "\(curItem.recolector.nombre) \(curItem.recolector.apellidos)"

            
            popUpCompletada.isUserInteractionEnabled = true
            // inicializar PopUps
            popUpCompletada.continuarBtn.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
            self.view.addSubview(popUpCompletada)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpCompletada.addGestureRecognizer(tapGestureRecognizer)
            print(estado)
        }
        else {
            print(estado)
        }
        
    }

    // Handle taps outside of popUpIniciada
    @objc func handleTapOutsidePopup(_ sender: UITapGestureRecognizer) {
        // Customize your pop-up based on the state
        if curItem.estado == RecycleViewController.iniciada {
            if sender.state == .ended {
                let location = sender.location(in: popUpIniciada.container)
                if !popUpIniciada.container.bounds.contains(location) {
                    popUpIniciada.removeFromSuperview()
                }
            }
        }
        else if curItem.estado == RecycleViewController.enProceso {
            if sender.state == .ended {
                let location = sender.location(in: popUpEnProceso.scrollView)
                if !popUpEnProceso.scrollView.bounds.contains(location) {
                    popUpEnProceso.removeFromSuperview()
                }
            }
        }
        else if curItem.estado == RecycleViewController.completada {
            if sender.state == .ended {
                let location = sender.location(in: popUpCompletada.scrollView)
                if !popUpCompletada.scrollView.bounds.contains(location) {
                    popUpCompletada.removeFromSuperview()
                }
            }
        }
        else {
            
        }
    }

    
    @objc func continuarBtn(){
        
        // Customize your pop-up based on the state
        if curItem.estado == RecycleViewController.iniciada {
            self.popUpIniciada.removeFromSuperview()
        }
        else if curItem.estado == RecycleViewController.enProceso {
            self.popUpEnProceso.removeFromSuperview()
        }
        else if curItem.estado == RecycleViewController.completada {
            self.popUpCompletada.removeFromSuperview()
        }
        else {
            
        }
    }
    
    @objc func cancelarBtn(){
        popUpIniciada.removeFromSuperview()
        showPopup()
    }
    
    func showPopup() {
        let alertController = UIAlertController(title: "Cancelar Orden", message: "¿Deseas Cancelar la Orden?", preferredStyle: .alert)

        // Add an "Accept" action
        let acceptAction = UIAlertAction(title: "Confirmar", style: .default) { (action) in
            // Handle accept action
            let db = Firestore.firestore()
            let collection = db.collection("recolecciones")
            let documentID = self.curItem.documentID
            // Define the field you want to update
            let fieldToUpdate = "estado"
            let updatedValue = RecycleViewController.cancelada

            // Create a dictionary with the field to update
            let updateData = [fieldToUpdate: updatedValue]

            // Update the document
            collection.document(documentID).updateData(updateData) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                }
            }
        }
        alertController.addAction(acceptAction)

        // Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            // Handle cancel action
            print("Cancel tapped")
        }
        alertController.addAction(cancelAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    

}

// función para manejar el click en una de las recolecciones
extension RecycleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let recoleccion = recolecciones.recoleccionArray[indexPath.row]
        
        showCorrectPopup(recoleccion: recoleccion)
        
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
