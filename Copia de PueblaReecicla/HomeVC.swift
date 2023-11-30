//
//  HomeVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 03/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


enum ProviderType: String {
    case basic
    case google
}

class HomeViewController: UIViewController {
    
    public var email: String?
    public var provider: ProviderType?
    @IBOutlet weak var HelloTxt: UILabel!
    
    /*// Inicializador personalizado
    init(email: String?, provider: ProviderType?) {
        print("Entre")
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navToolbar.layer.borderColor = UIColor.black.cgColor
        //navToolbar.layer.borderWidth = 1
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "email") is String{
            print("logged in and saved in user defaults")
        }
        else {
            print("no user saved in user defaults")
        }
        
        if let currentUser = Auth.auth().currentUser {
            if ((currentUser.isEmailVerified)){
                print("Verified")
                
                // Obtener el nombre del usuario desde Firestore
                let db = Firestore.firestore()
                let usersCollection = db.collection("usuarios") // Asegúrate de que sea "usuarios" o el nombre correcto de tu colección
                let userEmail = currentUser.email ?? ""
                
                usersCollection.whereField("correo", isEqualTo: userEmail).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error al obtener datos del usuario: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = querySnapshot?.documents.first {
                        if let nombres = document["nombres"] as? String {
                            // Actualizar la interfaz de usuario en el hilo principal
                            DispatchQueue.main.async {
                                self.HelloTxt.text = "Hola \(nombres)"
                            }
                        }
                    } else {
                        print("Usuario no encontrado en Firestore")
                    }
                }
                
            } else {
                print("Not verified")
            }
        } else {
            print("No esta Logeado")
        }

        
    }
    
}

