//
//  ViewController.swift
//  PueblaReecicla
//
//  Created by Administrador on 31/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTxt.delegate = self
        emailTxt.backgroundColor = .white
        emailTxt.textColor = .black
        emailTxt.layer.borderColor = UIColor.black.cgColor
        emailTxt.layer.borderWidth = 1
        emailTxt.layer.cornerRadius = 17
        emailTxt.clipsToBounds = true
        
        passwordTxt.delegate = self
        passwordTxt.backgroundColor = .white
        passwordTxt.textColor = .black
        passwordTxt.layer.borderColor = UIColor.black.cgColor
        passwordTxt.layer.borderWidth = 1
        passwordTxt.layer.cornerRadius = 17
        passwordTxt.clipsToBounds = true
        
        navigationItem.backButtonDisplayMode = .minimal
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func signUpTap(_ sender: UITapGestureRecognizer) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUp") as? SignUpViewController
        navigationController?.pushViewController(signUpVC!, animated: true)
    }
    
    @IBAction func logInTap(_ sender: Any) {
        if (emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty) {
            let alert = UIAlertController(title: "Error", message: "Hay campos vacios", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
        } else {
            if let email = emailTxt.text, let password = passwordTxt.text{
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let result = result, error == nil {
                    if let user = Auth.auth().currentUser{
                        let uid = user.uid
                        let db = Firestore.firestore()
                        let usuariosCollection = db.collection("usuarios")
                        usuariosCollection.document(uid).getDocument{(document, error) in
                            if let error = error {
                                print("Error al obtener documentos: \(error)")
                            } else {
                                if let document = document, document.exists {
                                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeTab")
                                    vc.modalPresentationStyle = .overFullScreen
                                    self.present(vc, animated: true)
                                } else {
                                    print("Documento no encontrado")
                                    do {
                                        try Auth.auth().signOut()
                                    } catch let signOutError as NSError {
                                        print("Error al cerrar sesión en Firebase: \(signOutError)")
                                        // Manejar el error según sea necesario
                                    }
                                }
                            }
                        }
                    }
                        
                        /*self.navigationController?.pushViewController(HomeViewController(email: email, provider: .basic), animated: true)*/
                        // Crear una instancia de HomeViewController utilizando el inicializador personalizado
                        /*let homeVC = HomeViewController(email: email, provider: .basic)
                        // Configurar la presentación del controlador de vista
                        homeVC.modalPresentationStyle = .fullScreen
                        // Presentar el controlador de vista
                        self.navigationController?.present(homeVC, animated: true, completion: nil)*/

                    } else {
                        let alertController = UIAlertController(title: "Error", message:
                                                                    "Usuario y/o contraseña incorrectas", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

