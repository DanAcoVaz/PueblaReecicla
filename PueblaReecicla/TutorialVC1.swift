//
//  TutorialVC1.swift
//  PueblaReecicla
//
//  Created by Alumno on 24/11/23.
//

import UIKit

class TutorialVC1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func goNext(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Tutorial2")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
}
