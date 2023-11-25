//
//  TutorialVC5.swift
//  PueblaReecicla
//
//  Created by Alumno on 24/11/23.
//

import UIKit

class TutorialVC5: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial4")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @IBAction func continuar(_ sender: Any) {
        if (ViewController.googleSI == true){
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeTab")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
        if (ViewController.myp == true){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginTab")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}
