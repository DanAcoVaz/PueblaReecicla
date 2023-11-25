//
//  SignUpVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 03/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


extension UITextField {
    func setPreferences() {
        self.backgroundColor = .white
        self.textColor = .black
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 17
        self.clipsToBounds = true
    }
    
    func isValidEmail() -> Bool {
        // Basic email validation using a regular expression
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self.text)
    }
    
    func isValidPhoneNumber() -> Bool {
        // Validate that the phone number has exactly 10 digits
        let phoneRegex = "^\\d{10}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self.text)
    }
    
    func isValidPassword() -> Bool {
        // Validate password: minimum 8 characters, at least one uppercase letter, and at least one digit
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self.text)
    }
}

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmpwdTxt: UITextField!
    @IBOutlet weak var bdayPicker: UIDatePicker!
    @IBOutlet weak var termsSwitch: UISwitch!
    @IBOutlet weak var logInLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var myTextFields = [UITextField]()
        myTextFields = [nameTxt, lastnameTxt, emailTxt, phoneTxt, passwordTxt, confirmpwdTxt]

            for item in myTextFields {
                item.setPreferences()
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
    
    
    @IBAction func logInTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginTab")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func signUpTap(_ sender: Any) {
        if (nameTxt.text!.isEmpty || lastnameTxt.text!.isEmpty || emailTxt.text!.isEmpty || phoneTxt.text!.isEmpty || passwordTxt.text!.isEmpty || confirmpwdTxt.text!.isEmpty) {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Hay campos vacios")
        } else if !termsSwitch.isOn {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "No has aceptado los términos y condiciones y/o la política de privacidad")
        } else if passwordTxt.text! != confirmpwdTxt.text! {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Las contraseñas no coinciden")
        } else if !emailTxt.isValidEmail() {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Correo electrónico no válido")
        } else if !phoneTxt.isValidPhoneNumber() {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Número de teléfono inválido. Debe tener 10 dígitos.")
        } else if !passwordTxt.isValidPassword() {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Contraseña inválida. Debe tener al menos 8 caracteres, una mayúscula y un número.")
        } else {
            let alert = UIAlertController(title: "¿Confirmar registro?", message: "¿Desea confirmar el registro de su cuenta?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { action in
                self.confirmSignUp()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func confirmSignUp() {
            if let email = emailTxt.text, let password = passwordTxt.text{
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let result = result, error == nil {
                        //Extract UID from result
                        let uid = result.user.uid
                        //Create a Firestore document for the user
                        let db = Firestore.firestore()
                        let userRef = db.collection("usuarios").document(uid)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        //Set additional user data
                        let userData: [String: Any] = [
                            "nombre": self.nameTxt.text!,
                            "apellidos": self.lastnameTxt.text!,
                            "correo": self.emailTxt.text!,
                            "telefono": self.phoneTxt.text!,
                            "fechaNacimiento": dateFormatter.string(from: self.bdayPicker.date),
                            "rank_points": 0,
                            "highest1": 0,
                        ]
                        //Save data to Firestore
                        userRef.setData(userData)
                        
                        Auth.auth().currentUser!.sendEmailVerification()
                        self.showActivateAccountAlert(email: email, password: password)
                    }
                    else {
                        let alertController = UIAlertController(title: "Error", message:
                                                                    "Se ha producido un error registrando al usuario", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    
    func showActivateAccountAlert(email: String, password: String) {
        let activateAlert = UIAlertController(title: "Activa tu cuenta", message: "Te hemos enviado un correo de verificación al correo que proporcionaste. Verifica tu correo para poder iniciar sesión" , preferredStyle: .alert)
        activateAlert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { [weak activateAlert] (_) in
            ViewController.myp = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial1")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }))

        // Mostrar la alerta de activa tu cuenta
        self.present(activateAlert, animated: true, completion: nil)
    }

}
