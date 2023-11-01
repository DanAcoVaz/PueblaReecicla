//
//  ViewController.swift
//  PueblaReecicla
//
//  Created by Administrador on 31/10/23.
//

import UIKit

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
        emailTxt.layer.cornerRadius = 17
        emailTxt.clipsToBounds = true
        
        passwordTxt.delegate = self
        passwordTxt.backgroundColor = .white
        passwordTxt.textColor = .black
        passwordTxt.layer.cornerRadius = 17
        passwordTxt.clipsToBounds = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func signUpTap(_ sender: UITapGestureRecognizer) {
        let signInView = SignInViewController()
        self.navigationController?.pushViewController(signInView, animated: true)
    }
}

