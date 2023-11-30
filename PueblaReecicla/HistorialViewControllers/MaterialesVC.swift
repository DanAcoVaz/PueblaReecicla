//
//  MaterialesVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 20/11/23.
//

import Photos
import PhotosUI
import FirebaseFirestore
import FirebaseStorage
import UIKit
import FirebaseAuth


class MaterialesVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var materialArray: [Material] = []
    
    var popUpTomarFoto: MTR_tomarFoto!
    
    var curMaterial: Material?
    var curCell: MaterialReciclarCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popUpTomarFoto = MTR_tomarFoto(frame: self.view.frame, inView: self)
        
        if Auth.auth().currentUser != nil{
            RecycleViewController.userID = Auth.auth().currentUser?.uid ?? "user_id_2"
        } else {
            RecycleViewController.userID = "user_id_2"
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.layer.frame.width - 16,
                                 height: 220)
        collectionView.collectionViewLayout = layout
        
        self.collectionView.register(HeaderMaterialCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMaterialCollectionReusableView.identifier)
        self.collectionView.register(MaterialReciclarCollectionViewCell.nib(), forCellWithReuseIdentifier: MaterialReciclarCollectionViewCell.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default: break

        }
    }

    func presentCameraSettings() {
        let alertController = UIAlertController(title: "Error",
                                      message: "Se necesita el permiso de cámara",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .default))
        alertController.addAction(UIAlertAction(title: "Ajustes", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        present(alertController, animated: true)
    }
    
    @IBAction func finishRecoleccion(_ sender: Any) {
        // Check if the collection view has at least 1 item
        if materialArray.isEmpty {
            // Display an alert indicating that there are no items to finish
            let alertController = UIAlertController(title: "Error", message: "Debe seleccionar mínimo 1 material", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // Create the first popup with Cancel and Confirm buttons
        let confirmAlertController = UIAlertController(title: "Confirmar Orden", message: "¿Deseas confirmar la orden?", preferredStyle: .alert)
        
        confirmAlertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        confirmAlertController.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { [weak self] (_) in
            // Call the function to present the second popup
            // Iterate through visible cells in the collection view
            for cell in self!.collectionView.visibleCells {
                if let indexPath = self!.collectionView.indexPath(for: cell) {
                    // Access the corresponding material in the array
                    let material = self!.materialArray[indexPath.item]
                    
                    // Update the material properties based on the cell content
                    if let materialCell = cell as? MaterialReciclarCollectionViewCell {
                        material.cantidad = Int(materialCell.cantidadMaterial.text!) ?? 1
                        material.unidad = materialCell.unidadMaterialTxt.text ?? ""
                        
                    }
                }
            }
            self?.presentConfirmPopup()
            self?.sendDataToDBRecolecciones()
        }))
        
        // Present the first popup
        present(confirmAlertController, animated: true, completion: nil)
    }
    
    // Function to present the second popup
    func presentConfirmPopup() {
        
        // Create the second popup with Continue button
        let continueAlertController = UIAlertController(title: "Orden de Reciclaje", message: """
        Tu orden está siendo procesada
        
        El estado de la recolección cambiará cuando encontremos un recolector.
        """, preferredStyle: .alert)
        
        continueAlertController.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { [weak self] (_) in
            // Call the function to go to the next view controller
            self?.goToHomeTabViewController()
        }))
        
        // Present the second popup
        present(continueAlertController, animated: true, completion: nil)
    }
    
    // Function to go to the HomeTab view controller
    func goToHomeTabViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
    // Function to send data to Firestore for recolecciones
    private func sendDataToDBRecolecciones() {
        // Assuming you have Firestore and Storage configured
        let db = Firestore.firestore()
        _ = Storage.storage()
        
        var recoleccionData: [String: Any] = [
            "fechaRecoleccion": BundleRecoleccion.shared.selectedDate,
            "horaRecoleccionFinal": BundleRecoleccion.shared.timeEnd,
            "horaRecoleccionInicio": BundleRecoleccion.shared.timeIni,
            "comentarios": BundleRecoleccion.shared.commentaries,
            "latitud": BundleRecoleccion.shared.latitud,
            "longitud": BundleRecoleccion.shared.longitud,
            "enPersona": BundleRecoleccion.shared.enPersonaSelected,
            "timeStamp": Int64(Date().timeIntervalSince1970 * 1000),
            "idUsuarioCliente": RecycleViewController.userID,
            "recolectada": false,
            "calificado": false,
            "estado": RecycleViewController.iniciada
        ]
        
        var materialesMap: [String: [String: Any]] = [:]
        
        for (count, material) in materialArray.enumerated() {
            let materialData: [String: Any] = [
                "nombre": material.nombre,
                "unidad": material.unidad,
                "cantidad": material.cantidad,
                "fotoUrl": ""
            ]
            let materialId = "material_\(count)"
            materialesMap[materialId] = materialData
        }
        
        recoleccionData["materiales"] = materialesMap
        
        
        let recolectorData: [String: Any] = [
            "id": "",
            "nombre": "",
            "apellidos": "",
            "telefono": "",
            "fotoUrl": "",
            "cantidad_reseñas": 0,
            "suma_reseñas": 0
        ]
        
        recoleccionData["recolector"] = recolectorData
        
        // Create a dictionary with user data
        var userData: [String: Any] = [:]
        userData["nombreCompleto"] = BundleRecoleccion.shared.nombreCompleto
        userData["telefono"] = BundleRecoleccion.shared.telefono
        userData["direccion"] = BundleRecoleccion.shared.direccionCompleta
        
        recoleccionData["userInfo"] = userData
        
        
        let recoleccionesCollection = db.collection("recolecciones")
        let recoleccionId = recoleccionesCollection.document().documentID
        // Use setData to set the data in the document
        recoleccionesCollection.document(recoleccionId).setData(recoleccionData) { [self] error in
            if let error = error {
                print("Error setting document data: \(error)")
            } else {
                print("Document data set successfully")
                
                // After the recolección document data is set, you can update it with the photo URL.
                for (count, material) in self.materialArray.enumerated() {
                    if let fotoMaterial = material.fotoMaterial {
                        uploadPictureToFirebase(image: fotoMaterial, count: count, recoleccionId: recoleccionId)
                    }
                }
            }
        }
        
    }
    
    // Function to upload photos of materials to Firebase
    func uploadPictureToFirebase(image: UIImage, count: Int, recoleccionId: String) {
        // Convert the UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert UIImage to Data.")
            return
        }
        
        let randomKey = UUID().uuidString

        // Create a unique filename for the image using recoleccionId and count
        let filename = "\(randomKey).jpg"

        // Reference to the Firebase Storage
        let storageRef = Storage.storage().reference()

        // Reference to the image file in Firebase Storage
        let imageRef = storageRef.child("fotosMateriales/\(filename)")

        // Upload the image data to Firebase Storage
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                if let error = error {
                    print("Error uploading image: \(error)")
                }
                return
            }

            // Image uploaded successfully
            print("Image uploaded successfully.")

            // Get the download URL
            imageRef.downloadURL { [self] (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error)")
                } else {
                    // URL of the uploaded image
                    if let downloadURL = url {
                        print("Download URL: \(downloadURL.absoluteString)")
                            
                        self.setFotoEvidenciaForItem(downloadURL.absoluteString, count: count, recoleccionId: recoleccionId)
                    }
                }
            }
        }

        // Add a progress observer if needed
        uploadTask.observe(.progress) { snapshot in
            // You can use snapshot.progress to get the upload progress
            // For example, let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            // Update UI with the upload progress if needed
        }

        // Add a completion observer to check for the upload completion
        uploadTask.observe(.success) { snapshot in
            // Handle successful upload completion
        }

        // Add an error observer to handle upload failures
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("Error uploading image: \(error)")
            }
        }
    }
    
    // Function to set the photo URL for a material in Swift
    func setFotoEvidenciaForItem(_ imageURL: String, count: Int, recoleccionId: String) {
        if count >= 0 && count < materialArray.count {
            materialArray[count].fotoUrl = imageURL
            collectionView.reloadItems(at: [IndexPath(item: count, section: 0)])
            // Save the material to the database here if needed
            updateMaterialWithFotoUrl(imageURL, count, recoleccionId)
        }
    }

    // Function to update the material in Firestore with the photo URL in Swift
    func updateMaterialWithFotoUrl(_ imageURL: String, _ count: Int, _ recoleccionId: String) {
        // Initialize a Firestore DocumentReference for the recolección document
        let recoleccionRef = Firestore.firestore().collection("recolecciones").document(recoleccionId)

        // Update a specific material (e.g., "material_0") within the recolección document
        let materialKey = "material_\(count)" // Replace with the actual material key

        var updateData = [String: Any]()
        updateData["materiales.\(materialKey).fotoUrl"] = imageURL

        recoleccionRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating material photo URL: \(error)")
            } else {
                print("Material photo URL updated successfully.")
            }
        }
    }

    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX") // Set the locale to Spanish
        formatter.dateFormat = "E. dd 'de' MMM 'de' yyyy" // Define the desired date format
        return formatter.string(from: date)
    }
    
    func translateDateFormat(_ dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        guard let date = formatter.date(from: dateString) else {
            print("Failed to parse the input date.")
            return "nil"
        }

        formatter.locale = Locale(identifier: "es_MX") // Set the locale to Spanish
        formatter.dateFormat = "E. dd 'de' MMM 'de' yyyy"

        return formatter.string(from: date)
    }
    
    // FIN DE LA CLASE MaterialesVC
    // ----------------------------
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
        let material = materialArray[indexPath.item]
        
        self.popUpTomarFoto.container.customize()
        
        if (material.fotoMaterial != nil) {
            self.popUpTomarFoto.imgMaterial.isHidden = false
            self.popUpTomarFoto.imgMaterial.image = self.curMaterial?.fotoMaterial
            cell.tomarFotoBtnTxt.text = "Ver Foto"
        } else {
            self.popUpTomarFoto.imgMaterial.isHidden = true
            cell.tomarFotoBtnTxt.text = "Tomar Foto"
        }
        
        cell.tomarFotoBtnTapped = { [self] in
            // Handle the button tap here
            print("Tomar Foto")
            self.curMaterial = material
            self.curCell = cell
            
            if (material.fotoMaterial != nil) {
                self.popUpTomarFoto.imgMaterial.isHidden = false
                self.popUpTomarFoto.imgMaterial.image = self.curMaterial?.fotoMaterial
                cell.tomarFotoBtnTxt.text = "Ver Foto"
            } else {
                self.popUpTomarFoto.imgMaterial.isHidden = true
                cell.tomarFotoBtnTxt.text = "Tomar Foto"
            }
            
            self.popUpTomarFoto.isUserInteractionEnabled = true
            
            // funciones para botones de los popups
            self.popUpTomarFoto.verGaleriaBtn.addTarget(self, action: #selector(self.verGaleriaBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpTomarFoto)
            
            self.popUpTomarFoto.cancelarBtn.addTarget(self, action: #selector(self.cancelarBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpTomarFoto)
            
            self.popUpTomarFoto.tomarFotoBtn.addTarget(self, action: #selector(self.tomarFotoBtn), for: .touchUpInside)
            self.view.addSubview(self.popUpTomarFoto)
            
            // Add tap gesture recognizer to handle taps outside the popup
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutsidePopup))
            tapGestureRecognizer.cancelsTouchesInView = false
            self.popUpTomarFoto.addGestureRecognizer(tapGestureRecognizer)
            
        }
        
        cell.eliminarBtnTapped = { [weak self] in
           
            // Check if the index is within the valid range
            guard let indexPath = self?.collectionView.indexPath(for: cell),
                  indexPath.item < (self?.materialArray.count)! else {
                print("Invalid index or material array is empty")
                return
            }

            // Remove the corresponding material from the array
            self?.materialArray.remove(at: indexPath.item)

            // Update the collection view by deleting the specific item
            self?.collectionView.performBatchUpdates({
                self?.collectionView.deleteItems(at: [indexPath])
            }, completion: { _ in
                // additional actions after the update
            })
        }
        
        cell.unidadMaterialBtnTapped = { [] in
            material.unidad = cell.unidadMaterialTxt.text ?? ""
        }
        
        cell.plusBtnTapped = { [] in
            material.cantidad = Int(cell.cantidadMaterial.text!) ?? 1
        }
        
        cell.minusBtnTapped = { [] in
            material.cantidad = Int(cell.cantidadMaterial.text!) ?? 1
        }

        cell.configure(with: UIImage(named: getMaterialIcon(materialName: material.nombre)!)!, nombreM: material.nombre, cantidad: String(material.cantidad), unidad: material.unidad)

        return cell
    }
    
    @objc func tomarFotoBtn(){
        checkCameraAccess()
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func verGaleriaBtn(){
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func handleTapOutsidePopup(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: popUpTomarFoto.container)
            if !popUpTomarFoto.container.bounds.contains(location) {
                popUpTomarFoto.removeFromSuperview()
            }
        }
    }
    
    @objc func cancelarBtn(){
        self.popUpTomarFoto.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderMaterialCollectionReusableView.identifier, for: indexPath) as! HeaderMaterialCollectionReusableView
        
        // Set up the closure to handle the tap action
        header.agregarMaterialBtnTapped = { [weak self] in
            // Instantiate the MaterialesSelectionVC from the storyboard
            if let selectionVC = self?.storyboard?.instantiateViewController(withIdentifier: "MaterialesSelection") as? MaterialesSelectionVC {
                
                // Set the delegate
                selectionVC.selectionDelegate = self

                // Push MaterialesSelectionVC onto the navigation stack
                self?.navigationController?.pushViewController(selectionVC, animated: true)
            }
        }
        
        let fecha = BundleRecoleccion.shared.selectedDate
        let horario = BundleRecoleccion.shared.timeEnd
        
        header.configure(with: translateDateFormat(fecha)!, horario: horario)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: view.frame.size.width, height: 200)
    }
    
}

extension MaterialesVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let group = DispatchGroup()
        
        results.forEach{ result in
            group.enter()
            self.popUpTomarFoto.imgMaterial.isHidden = false
            self.popUpTomarFoto.imgMaterial.image = UIImage(named: "icon_loading")
            self.curCell?.tomarFotoBtnTxt.text = "Ver Foto"
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                self.curMaterial!.fotoMaterial = image
            }
        }
        
        group.notify(queue: .main) {
            self.popUpTomarFoto.imgMaterial.image = self.curMaterial?.fotoMaterial
        }
    }
}

extension MaterialesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            self.popUpTomarFoto.imgMaterial.image = UIImage(systemName: "xmark.icloud.fill")
            self.curMaterial?.fotoMaterial = nil
            return
        }
        self.popUpTomarFoto.imgMaterial.isHidden = false
        self.popUpTomarFoto.imgMaterial.image = UIImage(named: "icon_loading")
        self.curCell?.tomarFotoBtnTxt.text = "Ver Foto"
        self.curMaterial?.fotoMaterial = image
        self.popUpTomarFoto.imgMaterial.image = image
    }
}

// función para definir los margenes de cada recolección
extension MaterialesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 16 // Adjust left and right margins
        return CGSize(width: width, height: 220)
    }
}

extension MaterialesVC: MaterialesSelectionDelegate {
    func didSelectMaterial(_ selectedMaterial: MaterialSelectionItem) {
        // Add the selected material to your array
        materialArray.append(Material(cantidad: 1, fotoUrl: selectedMaterial.imageName, nombre: selectedMaterial.name, unidad: "Bolsas"))

        // Calculate the index path for the newly added item
        let newIndexPath = IndexPath(item: materialArray.count - 1, section: 0)

        // Insert the new item into the collection view
        collectionView.insertItems(at: [newIndexPath])
    }
}

private func getMaterialIcon(materialName: String) -> String? {
    // Define an array of tuples with material names and corresponding image resource names
    let materialData: [(name: String, imageName: String)] = [
        ("Aceite Auto", "material_aceite_auto"),
        ("Aceite Usado", "material_aceite_usado"),
        ("Árbol", "material_arbol"),
        ("Baterias", "material_baterias"),
        ("Bicicletas", "material_bici"),
        ("Botellas", "material_botellas"),
        ("Cartón", "material_carton"),
        ("Electrónicos", "material_electronicos"),
        ("Escombros", "material_escombro"),
        ("Industriales", "material_industriales"),
        ("Juguetes", "material_juguetes"),
        ("Lata Chilera", "material_metal"),
        ("Lata", "material_metal"),
        ("Libros", "material_libros"),
        ("Llantas", "material_llantas"),
        ("Madera", "material_madera"),
        ("Medicina", "material_medicina"),
        ("Metal", "material_metal"),
        ("Orgánico", "material_organico"),
        ("Pallets", "material_pallets"),
        ("Papel", "material_papel"),
        ("Pilas", "material_pilas"),
        ("Plásticos", "material_plasticos"),
        ("Ropa", "material_ropa"),
        ("Tapitas", "material_tapitas"),
        ("Tetrapack", "material_tetrapack"),
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
