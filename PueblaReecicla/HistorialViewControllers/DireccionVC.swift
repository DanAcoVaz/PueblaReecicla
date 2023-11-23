//
//  DireccionVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 20/11/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class DireccionVC: UIViewController {

    @IBOutlet weak var CalleField: UITextField!
    @IBOutlet weak var numeroField: UITextField!
    @IBOutlet weak var coloniaField: UITextField!
    @IBOutlet weak var municipioField: UITextField!
    @IBOutlet weak var codigoPostalField: UITextField!
    @IBOutlet weak var telefonoField: UITextField!
    
    // Referencia a FireStore
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch data from Firestore for a specific document ID
        fetchDataFromFirestore(documentID: RecycleViewController.userID)
        
        setupTextFields()
    }
    
    @IBAction func finishDireccionSelection(_ sender: Any) {
        if validateTextFields() {
            // All text fields are non-empty, perform your action here
            
            // Save data to the shared data model
            BundleRecoleccion.shared.calle = CalleField.text ?? ""
            BundleRecoleccion.shared.numero = numeroField.text ?? ""
            BundleRecoleccion.shared.colonia = coloniaField.text ?? ""
            BundleRecoleccion.shared.municipio = municipioField.text ?? ""
            BundleRecoleccion.shared.codigoPostal = codigoPostalField.text ?? ""
            BundleRecoleccion.shared.telefono = telefonoField.text ?? ""

            let direccion = "\(CalleField.text ?? "") \(numeroField.text ?? ""), Colonia \(coloniaField.text ?? ""), \(municipioField.text ?? ""), Código Postal \(codigoPostalField.text ?? "")"
            BundleRecoleccion.shared.direccionCompleta = direccion
            
            let storyboard = UIStoryboard(name: "Recycle", bundle: nil)
            if let MaterialesVC = storyboard.instantiateViewController(withIdentifier: "Materiales") as? MaterialesVC {
                self.navigationController?.pushViewController(MaterialesVC, animated: true)
            }
        }
    }
    
    func validateTextFields() -> Bool {
        let textFields = [CalleField, numeroField, coloniaField, municipioField, codigoPostalField, telefonoField]

        for textField in textFields {
            if let text = textField?.text, text.isEmpty {
                // Display an alert or perform any other action for empty text field
                showAlert(message: "Por favor, complete todos los campos")
                return false
            }
        }

        return true
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Function to retrieve data from Firestore
    func fetchDataFromFirestore(documentID: String) {
        let usuariosRef = db.collection("usuarios").document(documentID)

        usuariosRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Document data
                let direccionData = document.data()?["direccion"] as? [String: Any]

                // Extracting values from the 'direccion' map
                let calle = direccionData?["calle"] as? String ?? ""
                let codigoPostal = direccionData?["codigoPostal"] as? String ?? ""
                let colonia = direccionData?["colonia"] as? String ?? ""
                let municipio = direccionData?["municipio"] as? String ?? ""
                let numero = direccionData?["numero"] as? String ?? ""
                
                let phoneData = document.data()?["telefono"] as? String
                let telefono = phoneData ?? ""
                
                let nombres = document.data()?["nombres"] as? String
                let apellidos = document.data()?["apellidos"] as? String
                BundleRecoleccion.shared.nombreCompleto = "\(nombres ?? "") \(apellidos ?? "")"
                
                // Set the retrieved data into the respective text fields
                self.CalleField.text = calle
                self.codigoPostalField.text = codigoPostal
                self.coloniaField.text = colonia
                self.municipioField.text = municipio
                self.numeroField.text = numero
                self.telefonoField.text = telefono
                // You can update your UI or perform any other actions with the retrieved data
            } else {
                print("Document does not exist")
                // Handle the case where the document doesn't exist
            }
        }
    }
    
    func setupTextFields() {
        let textFields = [CalleField, numeroField, coloniaField, municipioField, codigoPostalField, telefonoField]

        for textField in textFields {
            // Create a black bottom border
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: textField!.frame.height - 1, width: textField!.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.black.cgColor

            // Remove any existing border
            textField?.borderStyle = UITextField.BorderStyle.none

            // Add the black bottom border to the text field
            textField?.layer.addSublayer(bottomLine)
        }
    }

}
