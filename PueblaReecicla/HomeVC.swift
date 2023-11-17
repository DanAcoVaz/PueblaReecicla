//
//  HomeVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 03/11/23.
//

import UIKit
import FirebaseAuth

enum ProviderType: String {
    case basic
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var closeSessionButton: UIButton!
    
    public var email: String?
    public var provider: ProviderType?
    
    
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
        
        if let currentUser = Auth.auth().currentUser {
            print("Esta Logeado")
            print(currentUser.email)
            print(currentUser.displayName)
            print(currentUser.uid)
        } else {
            print("No esta Logeado")
        }
        
        
    }
    @IBAction func closeSessionButtonAction(_ sender: Any) {
        // Cerrar sesión en Firebase
                do {
                    try Auth.auth().signOut()
                    
                    // Después de cerrar sesión, puedes navegar a la pantalla de inicio o realizar otras acciones necesarias.
                    
                    // Por ejemplo, puedes navegar a la pantalla de inicio de sesión:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                    
                } catch let signOutError as NSError {
                    print("Error al cerrar sesión en Firebase: \(signOutError)")
                    // Manejar el error según sea necesario
                }
    }
    
}
