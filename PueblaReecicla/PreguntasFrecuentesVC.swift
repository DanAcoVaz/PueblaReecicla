//
//  PreguntasFrecuentesVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 27/11/23.
//

import UIKit

struct Question {
    let title: String
    let answer: String
}

let faqs = [
    Question(title: "FAQ 1", answer: "Esta seria la respuesta a la primera pregunta frecuente"),
    Question(title: "FAQ 2", answer: "Respuesta numero dos a la faq numero 2"),
    Question(title: "FAQ 3", answer: "Probemos con una respuesta corta"),
    Question(title: "FAQ LARGO", answer: "Esta seria la respuesta muy muy muy muy muy larga que probablemente responderia a la FAQ complicada, asi que esta respuesta se podria considerar una respuesta bastanteee larga, asi que esperemos que la cell se resizee apropiadamente")
]

class PreguntasFrecuentesViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        overrideUserInterfaceStyle = .light
        
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(FAQTableViewCell.nib(), forCellReuseIdentifier: FAQTableViewCell.identifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        //view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.identifier, for: indexPath) as! FAQTableViewCell
        
        cell.configure(with: faqs[indexPath.row])

        /*
        let content = faqs[indexPath.row]
        var listContentConfiguration = UIListContentConfiguration.cell()
        listContentConfiguration.text = content.title
        //listContentConfiguration.secondaryText = nil
        //listContentConfiguration.image = UIImage(systemName: "chevron.down")
        
        cell.contentConfiguration = listContentConfiguration
        */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
        if let cell = tableView.cellForRow(at: indexPath) as? FAQTableViewCell {
            print("doing selection")
            //Toggle label visibility and change button icon
            cell.answerLbl.isHidden = !cell.answerLbl.isHidden
            if cell.answerLbl.isHidden {
                cell.arrowBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            } else {
                cell.arrowBtn.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            }
            
            //Update cell height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        print("finished selecting")
    }

}
