//
//  PerfilVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 22/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class PerfilViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var bdayPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var myTextFields = [UITextField]()
        myTextFields = [nameTxt, lastnameTxt, phoneTxt]

            for item in myTextFields {
                item.setPreferences()
            }
        
        if let currentUser = Auth.auth().currentUser{
            let uid = currentUser.uid
            let docRef = Firestore.firestore().collection("usuarios").document(uid)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let nombre = document.data()?["nombres"] as? String {
                        self.nameTxt.text = nombre
                    }
                    if let apellido = document.data()?["apellidos"] as? String {
                        self.lastnameTxt.text = apellido
                    }
                    if let correo = document.data()?["correo"] as? String {
                        self.emailTxt.text = correo
                    }
                    if let telefono = document.data()?["telefono"] as? String {
                        self.phoneTxt.text = telefono
                    }
                    if let bday = document.data()?["fechaNacimiento"] as? Timestamp {
                        self.bdayPicker.date = bday.dateValue()
                    }
                } else {
                    print("Error with retrieving user info. Perhaps user (document) doesn't exist?")
                }
            }
        } else {
            print("Error al recuperar informacion")
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setDestructiveAlert(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true)
    }
    
    @IBAction func updateDataTap(_ sender: Any) {
        if (nameTxt.text!.isEmpty || lastnameTxt.text!.isEmpty || emailTxt.text!.isEmpty || phoneTxt.text!.isEmpty) {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Hay campos vacios")
        } else if !phoneTxt.isValidPhoneNumber() {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Número de teléfono inválido. Debe tener 10 dígitos.")
        } else {
            let alert = UIAlertController(title: "¿Confirmar cambios?", message: "¿Deseas realizar estos cambios a tu cuenta?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { action in
                self.updateData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateData(){
        let data: [String: Any] = [
            "nombres": nameTxt.text!,
            "apellidos": lastnameTxt.text!,
            "telefono": phoneTxt.text!,
            "fechaNacimiento": bdayPicker.date
        ]
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            Firestore.firestore().collection("usuarios").document(uid).updateData(data) { err in
                if let err = err {
                    print("Error updating document: \(err) ")
                }
                else {
                    print("Document successfully updated")
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeSessionTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "¿Quieres cerrar sesión?", message: "¿Deseas salir de tu cuenta?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Cerrar", style: .destructive, handler: { action in
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "email")
                defaults.synchronize()
                self.dismiss(animated: true)
            } catch let signOutError as NSError {
                print("Error al cerrar sesión en firebase: \(signOutError)")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

}
