//
//  InformacionVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 22/11/23.
//

import UIKit

class InformacionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.backButtonDisplayMode = .minimal
    }

    @IBAction func goToIniciativa(_ sender: Any) {
        let iniciativaVC = storyboard?.instantiateViewController(withIdentifier: "Iniciativa") as? IniciativaViewController
        navigationController?.pushViewController(iniciativaVC!, animated: true)
    }
    
    @IBAction func goToTerms(_ sender: Any) {
        let terminosVC = storyboard?.instantiateViewController(withIdentifier: "Terminos") as? TerminosViewController
        navigationController?.pushViewController(terminosVC!, animated: true)
    }
    
    @IBAction func goToPrivacidad(_ sender: Any) {
        let privacidadVC = storyboard?.instantiateViewController(withIdentifier: "Privacidad") as? PrivacidadViewController
        navigationController?.pushViewController(privacidadVC!, animated: true)
    }
    
    
}
