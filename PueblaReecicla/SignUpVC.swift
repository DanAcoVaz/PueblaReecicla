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
    @IBOutlet weak var bdayTxt: UITextField!
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

}
