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
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var bdayPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var myTextFields = [UITextField]()
        myTextFields = [nameTxt, lastnameTxt, emailTxt, phoneTxt]

            for item in myTextFields {
                item.setPreferences()
            }
        
        if let currentUser = Auth.auth().currentUser{
            let uid = currentUser.uid
            let userRef = Firestore.firestore().collection("usuarios").document(uid)
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

}
