//
//  CompleteDataVC.swift
//  PueblaReecicla
//
//  Created by Alumno on 23/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


extension UITextField {
    func ssetPreferences() {
        self.backgroundColor = .white
        self.textColor = .black
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 17
        self.clipsToBounds = true
    }
    
    func isValid_PhoneNumber() -> Bool {
        // Validate that the phone number has exactly 10 digits
        let phoneRegex = "^\\d{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self.text)
    }
}

class CompleteDataVC: UIViewController {
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var bdayPicker: UIDatePicker!
    @IBOutlet weak var termsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String{
            print("logged in and saved in user defaults")
        }
        else {
            print("no user saved in user defaults")
        }

        // Do any additional setup after loading the view.
        var myTextFields = [UITextField]()
        myTextFields = [nameTxt, lastnameTxt, phoneTxt]

            for item in myTextFields {
                item.ssetPreferences()
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
    
    @IBAction func completeDataTap(_ sender: Any) {
        if (nameTxt.text!.isEmpty || lastnameTxt.text!.isEmpty || phoneTxt.text!.isEmpty) {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Hay campos vacios")
        } else if !termsSwitch.isOn {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "No has aceptado los términos y condiciones y/o la política de privacidad")
        } else if !phoneTxt.isValid_PhoneNumber() {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Número de teléfono inválido. Debe tener 10 dígitos.")
        } else {
            let alert = UIAlertController(title: "¿Confirmar registro?", message: "¿Desea confirmar el registro de su cuenta?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { action in
                self.updateFirestoreUserData()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginTab")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateFirestoreUserData(){
        if let currentUser = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let userRef = db.collection("usuarios").document(currentUser.uid)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                
                let userData = [
                    "nombre": nameTxt.text!,
                    "apellidos": lastnameTxt.text!,
                    "telefono": phoneTxt.text!,
                    "fechaNacimiento": dateFormatter.string(from: bdayPicker.date)
                ]
                
                userRef.setData(userData, merge: true) { error in
                    if let error = error {
                        print("Error updating user data: \(error.localizedDescription)")
                    } else {
                        print("User data updated successfully")
                    }
                }
            }
    }

}
