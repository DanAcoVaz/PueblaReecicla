//
//  TutorialVC2.swift
//  PueblaReecicla
//
//  Created by Alumno on 24/11/23.
//

import UIKit

class TutorialVC2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial1")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @IBAction func goNext(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial3")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
}
