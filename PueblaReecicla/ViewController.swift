//
//  ViewController.swift
//  PueblaReecicla
//
//  Created by Administrador on 31/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailTxt.backgroundColor = .white
        emailTxt.textColor = .black
        emailTxt.layer.cornerRadius = 17
        emailTxt.clipsToBounds = true
        
        passwordTxt.backgroundColor = .white
        passwordTxt.textColor = .black
        passwordTxt.layer.cornerRadius = 17
        passwordTxt.clipsToBounds = true
        
    }


}

