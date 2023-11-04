//
//  SignUpVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 03/11/23.
//

import UIKit

extension UITextField {
    func setPreferences() {
        self.backgroundColor = .white
        self.textColor = .black
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 17
        self.clipsToBounds = true
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
    
    @IBAction func signUpTap(_ sender: Any) {
        if (nameTxt.text!.isEmpty || lastnameTxt.text!.isEmpty || emailTxt.text!.isEmpty || phoneTxt.text!.isEmpty || passwordTxt.text!.isEmpty || confirmpwdTxt.text!.isEmpty) {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Hay campos vacios")
        } else if !termsSwitch.isOn {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "No has aceptado los términos y condiciones y/o la política de privacidad")
        } else if passwordTxt.text! != confirmpwdTxt.text! {
            setDestructiveAlert(alertTitle: "Error", alertMessage: "Las contraseñas no coinciden")
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
        let confirmAlert = UIAlertController(title: "Activa tu cuenta", message: "Te hemos enviado un correo de confirmación con un código al correo que proporcionaste. Introduce el código a continuación para activar tu cuenta:" , preferredStyle: .alert)
        confirmAlert.addTextField { (textField) in
            textField.text = ""
        }
        confirmAlert.addAction(UIAlertAction(title: "Activar", style: .default, handler: { [weak confirmAlert] (_) in
            let textField = confirmAlert?.textFields![0]
            //Acciones a realizar al pulsar el boton activar en la alerta:
            
            //print("Text field: \(textField?.text)")
            
            //Mostrar que se ha activado la cuenta
            
            let activeAlert = UIAlertController(title: "Cuenta Activada", message: "Listo! Has concluido el proceso de registro. Puedes comenzar a usar la aplicación", preferredStyle: .alert)
            activeAlert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { action in
                
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as? HomeViewController
                homeVC?.modalPresentationStyle = .fullScreen
                self.navigationController?.present(homeVC!, animated: true)
            }))
            self.present(activeAlert, animated: true)
        }))
        self.present(confirmAlert, animated: true, completion: nil)
    }
    

}
