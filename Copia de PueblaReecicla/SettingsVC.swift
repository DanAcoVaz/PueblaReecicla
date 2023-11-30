//
//  SettingsVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 08/11/23.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

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
            }
            else {
                print("Not verified")
            }
        } else {
            print("No esta Logeado")
        }
        
    }
    
    @IBAction func closeSessionButtonAction(_ sender: Any) {
        // Cerrar sesión en Firebase
                do {
                    let defaults = UserDefaults.standard
                    defaults.removeObject(forKey: "email")
                    defaults.synchronize()
                    
                    try Auth.auth().signOut()
                    
                    // Después de cerrar sesión, puedes navegar a la pantalla de inicio o realizar otras acciones necesarias.
                    
                    // Por ejemplo, puedes navegar a la pantalla de inicio de sesión:
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginTab")
                    
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true)
                    
                } catch let signOutError as NSError {
                    print("Error al cerrar sesión en Firebase: \(signOutError)")
                    // Manejar el error según sea necesario
                }
    }


}
