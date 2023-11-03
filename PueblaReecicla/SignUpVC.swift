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
    
    @IBAction func signUpTap(_ sender: Any) {
        let alert = UIAlertController(title: "¿Confirmar registro?", message: "¿Desea confirmar el registro de su cuenta?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancelar", comment: "Default action"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { action in
            
            self.confirmSignUp()
        }))
        self.present(alert, animated: true, completion: nil)
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
            activeAlert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: nil))
            self.present(activeAlert, animated: true)
        }))
        self.present(confirmAlert, animated: true, completion: nil)
    }
    

}
