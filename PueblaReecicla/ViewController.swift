//
//  ViewController.swift
//  PueblaReecicla
//
//  Created by Administrador on 31/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signUpLbl: UILabel!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        googleSignInButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onGoogleLoginTap)))
        
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
        
        let defaults = UserDefaults.standard
        
        if let email = defaults.value(forKey: "email") as? String {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeTab")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func signUpTap(_ sender: UITapGestureRecognizer) {
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "CompletarDatos") as? CompleteDataVC
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
                                    if let user = Auth.auth().currentUser{
                                        if user.isEmailVerified{
                                            let defaults = UserDefaults.standard
                                            defaults.set(email, forKey: "email")
                                            defaults.synchronize()
                                            let storyboard = UIStoryboard(name: "Home", bundle: nil)
                                            let vc = storyboard.instantiateViewController(withIdentifier: "HomeTab")
                                            vc.modalPresentationStyle = .overFullScreen
                                            self.present(vc, animated: true)
                                        }
                                        else {
                                            let alert = UIAlertController(title: "Error", message: "El correo electrónico no está verificado. Verifícalo", preferredStyle: .alert)
                                                                                        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                                                                                        self.present(alert, animated: true)
                                        }
                                    }
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
    
    @objc func onGoogleLoginTap() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { authResult, error in
                guard error == nil else {
                    return
                }

                // Check if the user is new
                if let isNewUser = authResult?.additionalUserInfo?.isNewUser, isNewUser {
                    // Perform actions for a new user
                    print("New user signed in.")
                    // Get the user's UID
                    guard let uid = Auth.auth().currentUser?.uid,
                          let email = Auth.auth().currentUser?.email else {
                        return
                    }

                    // Create a reference to the "usuarios" collection and the user's document
                    let usersCollection = Firestore.firestore().collection("usuarios")
                    let userDocument = usersCollection.document(uid)

                    // Set initial values for additional fields
                    let userData: [String: Any] = [
                        "nombre": "",
                        "apellidos": "",
                        "correo": email,
                        "telefono": "",
                        "fechaNacimiento": "",
                        "rank_points": 0,
                        "highest1": 0,
                    ]

                    // Set the data in Firestore
                    userDocument.setData(userData, merge: true)
                    let currentUser = Auth.auth().currentUser
                    let defaults = UserDefaults.standard
                    defaults.set(email, forKey: "email")
                    defaults.synchronize()
                    
                    self.goToCD()
                    
                } else {
                    // Perform actions for an existing user
                    print("Existing user signed in.")
                    let currentUser = Auth.auth().currentUser
                    let email = currentUser?.email
                    let defaults = UserDefaults.standard
                    defaults.set(email, forKey: "email")
                    defaults.synchronize()

                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "HomeTab")
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    func goToCD(){
        let signUpVC = storyboard?.instantiateViewController(withIdentifier: "CompletarDatos") as? CompleteDataVC
        navigationController?.pushViewController(signUpVC!, animated: true)
    }
    
}

