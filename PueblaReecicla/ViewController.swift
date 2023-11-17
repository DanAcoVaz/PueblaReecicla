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
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeTab") //as? HomeViewController
            homeVC?.modalPresentationStyle = .fullScreen
            navigationController?.present(homeVC!, animated: true)
        }
    }
    
}

