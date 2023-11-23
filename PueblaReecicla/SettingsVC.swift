//
//  SettingsVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 08/11/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.backButtonDisplayMode = .minimal
    }

    @IBAction func goToContact(_ sender: Any) {
        let contactoVC = storyboard?.instantiateViewController(withIdentifier: "Contacto") as? ContactoViewController
        navigationController?.pushViewController(contactoVC!, animated: true)
    }
    
    @IBAction func goToCredits(_ sender: Any) {
        let creditosVC = storyboard?.instantiateViewController(withIdentifier: "Creditos") as? CreditosViewController
        navigationController?.pushViewController(creditosVC!, animated: true)
    }
    
    @IBAction func goToInformation(_ sender: Any) {
        let informacionVC = storyboard?.instantiateViewController(withIdentifier: "Informacion") as? InformacionViewController
        navigationController?.pushViewController(informacionVC!, animated: true)
    }
    
    @IBAction func goToCoolaborators(_ sender: Any) {
        let sociosVC = storyboard?.instantiateViewController(identifier: "socios") as? SociosViewController
        navigationController?.pushViewController(sociosVC!, animated: true)
    }
    
}
