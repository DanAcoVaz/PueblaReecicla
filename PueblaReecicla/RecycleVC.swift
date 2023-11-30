//
//  RecycleVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 08/11/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RecycleViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var newOrderBtn: UIButton!
    
    static var activityIndicator: UIActivityIndicatorView!
    
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
    static let light_blue = UIColor(named: "light_blue")
    static let color_fondo = UIColor(named: "ColorDeFondo")
    
    // user id
    static var userID = Auth.auth().currentUser?.uid ?? ""  // se debe cambiar por el obtenido en FirebaseAuth
    
    // arreglo para almacenar los elementos del collection view
    var recolecciones: Recolecciones!
    
    // popups
    var popUpIniciada: RV_iniciada!
    var popUpEnProceso: RV_enProceso!
    var popUpCompletada: RV_completada!
    var popUpCompletadaSinCalif: RV_comp_sinCalif!
    var popUpCancelada: RV_cancelada!
    
    // referencia al elemento actual del collection view
    var curItem: Recoleccion!
    
    // Timer to activate a task every given interval of time
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil{
            RecycleViewController.userID = Auth.auth().currentUser?.uid ?? "user_id_2"
        }
        
        navigationItem.backButtonDisplayMode = .minimal
        
        RecycleViewController.activityIndicator = UIActivityIndicatorView(style: .large)
        RecycleViewController.activityIndicator.center = view.center
        RecycleViewController.activityIndicator.color = RecycleViewController.green
        RecycleViewController.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(RecycleViewController.activityIndicator)
    
        newOrderBtn.layer.shadowColor = UIColor.black.cgColor
        newOrderBtn.layer.shadowOpacity = 0.5
        newOrderBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        newOrderBtn.layer.shadowRadius = 4
        
        // inicializan los Popups
        // INICIADA
        self.popUpIniciada = RV_iniciada(frame: self.view.frame, inView: self)
        
        // EN PROCESO
        self.popUpEnProceso = RV_enProceso(frame: self.view.frame, inView: self)
        popUpEnProceso.scrollView.layer.cornerRadius = 30
        popUpEnProceso.imageRecolector.layer.cornerRadius = min(popUpEnProceso.imageRecolector.frame.width, popUpEnProceso.imageRecolector.frame.height) / 2.0
        popUpEnProceso.imageRecolector.layer.masksToBounds = true
        
        // COMPLETADA SIN CALIFICAR
        self.popUpCompletada = RV_completada(frame: self.view.frame, inView: self)
        popUpCompletada.ScrollVW.layer.cornerRadius = 30
        popUpCompletada.imgRecolector.layer.cornerRadius = min(popUpCompletada.imgRecolector.frame.width, popUpCompletada.imgRecolector.frame.height) / 2.0
        popUpCompletada.imgRecolector.layer.masksToBounds = true
        
        // COMPLETADA CON CALIFICAR
        self.popUpCompletadaSinCalif = RV_comp_sinCalif(frame: self.view.frame, inView: self)
        
        // CANCELADA
        self.popUpCancelada = RV_cancelada(frame: self.view.frame, inView: self)
        
        // se configura el collection view
        collectionView.register(HistorialCollectionViewCell.nib(), forCellWithReuseIdentifier: HistorialCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Populate the array with sample data
        recolecciones = Recolecciones()
        
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateStatusTask), userInfo: nil, repeats: true)
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recolecciones.loadData(userID: RecycleViewController.userID) {
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
            
            popUpIniciada.verDetallesBtn.addTarget(self, action: #selector(verDetallesBtn), for: .touchUpInside)
            self.view.addSubview(popUpIniciada)
            
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpIniciada.addGestureRecognizer(tapGestureRecognizer)
            
        }
        else if estado == RecycleViewController.enProceso {
            
            loadImage(from: curItem.recolector.fotoUrl, into: popUpEnProceso.imageRecolector, placeholder: "icon_loading", defaultImage: "icon_user_gray")
            
            // se cambian las partes del Popup con la info de FB
            popUpEnProceso.nameRecolector.text = "\(curItem.recolector.nombre) \(curItem.recolector.apellidos)"
            popUpEnProceso.telefonoRecolector.text = curItem.recolector.telefono
            let averageRating = curItem.recolector.suma_reseñas / curItem.recolector.cantidad_reseñas
            let formattedRating = averageRating.isNaN ? "0.0" : String(format: "%.1f", averageRating)
            popUpEnProceso.calificacionRecolector.text = formattedRating


            
            popUpEnProceso.isUserInteractionEnabled = true
            // agregar funciones a los botones
            popUpEnProceso.continuarBtn.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
            self.view.addSubview(popUpEnProceso)
            
            popUpEnProceso.verDetallesBtn.addTarget(self, action: #selector(verDetallesBtn), for: .touchUpInside)
            self.view.addSubview(popUpEnProceso)
            
            popUpEnProceso.cancelarOrden.addTarget(self, action: #selector(cancelarBtn), for: .touchUpInside)
            self.view.addSubview(popUpEnProceso)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpEnProceso.addGestureRecognizer(tapGestureRecognizer)
        }
        else if estado == RecycleViewController.completada {
            if(!curItem.calificado) {
                loadImage(from: curItem.recolector.fotoUrl, into: popUpCompletada.imgRecolector, placeholder: "icon_loading", defaultImage: "icon_user_gray")
                popUpCompletada.rating = 0
                // se cambian las partes del Popup con la info de FB
                popUpCompletada.nameRecollector.text = "\(curItem.recolector.nombre) \(curItem.recolector.apellidos)"
                
                popUpCompletada.isUserInteractionEnabled = true
                // inicializar PopUps
                popUpCompletada.continuarButton.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
                self.view.addSubview(popUpCompletada)
                
                popUpCompletada.verDetallesButton.addTarget(self, action: #selector(verDetallesBtn), for: .touchUpInside)
                self.view.addSubview(popUpCompletada)
                
                // Add tap gesture recognizer to handle taps outside the popup
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
                tapGestureRecognizer.cancelsTouchesInView = false
                popUpCompletada.addGestureRecognizer(tapGestureRecognizer)
            } else {
                popUpCompletadaSinCalif.isUserInteractionEnabled = true
                // inicializar PopUps
                popUpCompletadaSinCalif.continuarBtn.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
                self.view.addSubview(popUpCompletadaSinCalif)
                
                popUpCompletadaSinCalif.verDetalles.addTarget(self, action: #selector(verDetallesBtn), for: .touchUpInside)
                self.view.addSubview(popUpCompletadaSinCalif)
                
                // Add tap gesture recognizer to handle taps outside the popup
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
                tapGestureRecognizer.cancelsTouchesInView = false
                popUpCompletadaSinCalif.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        else {
            popUpCancelada.isUserInteractionEnabled = true
            
            // funciones para botones de los popups
            popUpCancelada.continuarBtn.addTarget(self, action: #selector(continuarBtn), for: .touchUpInside)
            self.view.addSubview(popUpCancelada)
            
            popUpCancelada.verCentrosBtn.addTarget(self, action: #selector(verCentrosBtn), for: .touchUpInside)
            self.view.addSubview(popUpCancelada)
            
            popUpCancelada.verDetallesBtn.addTarget(self, action: #selector(verDetallesBtn), for: .touchUpInside)
            self.view.addSubview(popUpCancelada)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            popUpCancelada.addGestureRecognizer(tapGestureRecognizer)
                
        }
        
    }
    
    @objc func verDetallesBtn(){
        popUpIniciada.removeFromSuperview()
        popUpCancelada.removeFromSuperview()
        popUpCompletada.removeFromSuperview()
        popUpEnProceso.removeFromSuperview()
        popUpCompletadaSinCalif.removeFromSuperview()
        // Programmatically navigate to VerDetallesViewController
        let storyboard = UIStoryboard(name: "Recycle", bundle: nil)
        if let verDetallesViewController = storyboard.instantiateViewController(withIdentifier: "VerDetalles") as? VerDetallesVC {
            // Set the data on the destination view controller
            verDetallesViewController.materiales = self.curItem.materiales
            verDetallesViewController.curItem = self.curItem
            self.navigationController?.pushViewController(verDetallesViewController, animated: true)
        }
        
    }
    
    func loadImage(from imageUrlString: String, into imageView: UIImageView, placeholder: String, defaultImage: String) {
        // Set a placeholder image while loading.
        imageView.image = UIImage(named: placeholder)

        // Convert the URL string to a URL object.
        guard let imageUrl = URL(string: imageUrlString) else {
            // Display a default image if the URL is invalid.
            imageView.image = UIImage(named: defaultImage)
            print("Invalid URL for image: \(imageUrlString)")
            return
        }

        // Create a URL session configuration.
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        // Create a data task to download the image.
        let dataTask = session.dataTask(with: imageUrl) { [] (data, response, error) in
            // Check for errors and ensure there is data.
            guard error == nil, let imageData = data else {
                // Display a default image if there's an error.
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: defaultImage)
                }
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Create a UIImage from the downloaded data.
            if let image = UIImage(data: imageData) {
                // Update the image view on the main thread.
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }

        // Start the data task.
        dataTask.resume()
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
            if (!curItem.calificado) {
                if sender.state == .ended {
                    let location = sender.location(in: popUpCompletada.ScrollVW)
                    if !popUpCompletada.ScrollVW.bounds.contains(location) {
                        popUpCompletada.removeFromSuperview()
                    }
                }
            } else {
                if sender.state == .ended {
                    let location = sender.location(in: popUpCompletadaSinCalif.container)
                    if !popUpCompletadaSinCalif.container.bounds.contains(location) {
                        popUpCompletadaSinCalif.removeFromSuperview()
                    }
                }
            }
        }
        else {
            if sender.state == .ended {
                let location = sender.location(in: popUpCancelada.container)
                if !popUpCancelada.container.bounds.contains(location) {
                    popUpCancelada.removeFromSuperview()
                }
            }
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
            if(!curItem.calificado){
                if(popUpCompletada.rating != 0) {
                    self.popUpCompletada.removeFromSuperview()
                    updateCalificacion()
                } else {
                    showPopupCalificar()
                }
            } else {
                self.popUpCompletadaSinCalif.removeFromSuperview()
            }
        }
        else {
            self.popUpCancelada.removeFromSuperview()
        }
    }
    
    @objc func cancelarBtn(){
        popUpIniciada.removeFromSuperview()
        popUpEnProceso.removeFromSuperview()
        showPopupCancelarOrden()
    }
    
    @objc func verCentrosBtn(){
        popUpCancelada.removeFromSuperview()
        tabBarController?.selectedIndex = 1
        navigationController?.popToRootViewController(animated: true)

    }
    
    func updateCalificacion() {
        // Assuming you have a Firestore collection reference
        let recolectores = Firestore.firestore().collection("recolectores")

        // Assuming you have a document ID for the document you want to update
        let recolecorID = curItem.recolector.id

        // Assuming you have the increment value
        let rating: Int64 = Int64(popUpCompletada.rating)

        // Use the updateData method with FieldValue.increment to increment the field
        let sumaRating = ["suma_reseñas": FieldValue.increment(rating)]

        // Update the document with the incremented value
        recolectores.document(recolecorID).updateData(sumaRating) { error in
            if let error = error {
                print("Error updating suma_reseñas field: \(error)")
            } else {
                print("suma_reseñas field successfully updated")
            }
        }
        
        // Assuming you have an increment value
        let cantidad: Int64 = 1
        // Use the updateData method with FieldValue.increment to increment the field
        let cantidadRating = ["cantidad_reseñas": FieldValue.increment(cantidad)]
        
        recolectores.document(recolecorID).updateData(cantidadRating) { error in
            if let error = error {
                print("Error cantidad_reseñas boolean field: \(error)")
            } else {
                print("cantidad_reseñas field successfully updated")
            }
        }
        
        // Assuming you have a Firestore collection reference
        let recolecciones = Firestore.firestore().collection("recolecciones")
        // Assuming you have a document ID for the document you want to update
        let recoleeccionID = curItem.documentID
        // Assuming you have another field name you want to set to true
        let booleanFieldName = "calificado"

        // Update the document to set the specified boolean field to true
        let booleanFieldUpdate = [booleanFieldName: true]

        recolecciones.document(recoleeccionID).updateData(booleanFieldUpdate) { error in
            if let error = error {
                print("Error updating boolean field: \(error)")
            } else {
                print("Boolean field successfully updated")
            }
        }
    }
    
    func showPopupCancelarOrden() {
        let alertController = UIAlertController(title: "Cancelar Orden", message: "¿Deseas Cancelar la Orden?", preferredStyle: .alert)

        // Add an "Accept" action
        let acceptAction = UIAlertAction(title: "Confirmar", style: .default) { (action) in
            // Handle accept action
            
            Recolecciones.updateEstado(recoleccion: self.curItem, estado: RecycleViewController.cancelada)
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
    
    func showPopupCalificar() {
        let alertController = UIAlertController(title: "Debe calificar al Recolector", message: "Califique a su recolector con base a su desempeño", preferredStyle: .alert)

        // Add an "Accept" action
        let acceptAction = UIAlertAction(title: "Comprendo", style: .default) { (action) in
        }
        alertController.addAction(acceptAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func updateStatusTask() {
        let cstTimeZone = TimeZone(identifier: "America/Chicago")!
        var currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar.timeZone = cstTimeZone
        let currentDate = Date()

        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH:mm"

        for item in self.recolecciones.recoleccionArray {
            let fechaRecoleccionString = item.fechaRecoleccion
            let horaRecoleccionFinalString = item.horaRecoleccionFinal

            if let fechaRecoleccionDate = dateFormat.date(from: "\(fechaRecoleccionString) \(horaRecoleccionFinalString)") {
                if item.estado == "Iniciada" && currentDate > fechaRecoleccionDate && item.estado != "Cancelada" {
                    // Update the 'estado' attribute to "Cancelada"
                    let estado = RecycleViewController.cancelada
                    item.estado = estado

                    Recolecciones.updateEstado(recoleccion: item, estado: estado)
                } else if item.estado == "En Proceso" {
                    // Check if the current date is greater than the date of the item without considering the time
                    let currentDateWithoutTime = currentCalendar.startOfDay(for: currentDate)
                    let fechaRecoleccionDateWithoutTime = currentCalendar.startOfDay(for: fechaRecoleccionDate)

                    if currentDateWithoutTime == fechaRecoleccionDateWithoutTime {
                        // Dates are the same, do nothing or add additional conditions if needed
                    } else if currentDateWithoutTime > fechaRecoleccionDateWithoutTime {
                        // Update the 'estado' attribute to "Cancelada"
                        let estado = RecycleViewController.cancelada
                        item.estado = estado

                        Recolecciones.updateEstado(recoleccion: item, estado: estado)
                    }
                }
            } else {
                // Handle the case where date parsing fails
                print("Error parsing date for item: \(item)")
                // You can add additional error handling here if needed
            }
        }
    }

    // Don't forget to invalidate the timer when your view controller is deallocated or not needed anymore
    deinit {
        timer?.invalidate()
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
        var totalMateriales = "\(materialesCount) materiales"
        if(materialesCount <= 1) {
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
        let width = collectionView.frame.width - 16 // Adjust left and right margins
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
