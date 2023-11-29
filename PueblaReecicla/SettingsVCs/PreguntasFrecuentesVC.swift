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
    Question(title: "¿Qué es Puebla Reecicla?", answer: "Puebla Reecicla es una aplicación para la recolección de materiales a la puerta de la casa por personas capacitadas y con la mejor atención y en el tiempo más rápido."),
    Question(title: "¿Qué puedo ver en el mapa?", answer: "Puedes ver los centros de recolección asociados con Green Carson, a los cuales puedes acudir a entregar tus desechos. Puedes consultar información esencial de cada centro, como su ubicación y los tipos de materiales que reciben."),
    Question(title: "¿Cómo utilizar los filtros del mapa?", answer: "Puedes personalizar tu búsqueda de centros de recolección eligiendo un tipo de centro en específico, haciendo que solo se muestren los centros de ese tipo. Puedes desactivar el filtro en el momento que desees."),
    Question(title: "¿Cómo agendo una recolección?", answer: "En el menú Reciclaje, da click en el botón de + para agendar una nueva recolección, necesitarás seleccionar la fecha, horario y formato de entrega, y tendrás la opción de agregar algún comentario para el recolector. Posteriormente necesitarás introducir tu dirección y ubicación. Finalmente, debes elegir los materiales de tu recolección, de los cuales puedes introducir las cantidades y anexar imágenes. Finalmente, debes confirmar tu orden"),
    Question(title: "¿Puedo calificar a mi recolector?", answer: "Si, para ello, la recolección debe estar completada y no se debe haber calificado al recolector en esa recolección"),
    Question(title: "¿Puedo cancelar una recolección?", answer: "Si, solo se puede cancelar si la recolección está en Iniciada o en Proceso."),
    Question(title: "¿Cómo poner una foto de perfil?", answer: "En el menú Ajustes da clic en el botón + ubicado debajo del ícono circular. Puedes subir una foto desde tu cámara o desde la galería de fotos de tu dispositivo. Antes asegúrate de tener activado para esta aplicación los permisos de acceso a la cámara y fotos."),
    Question(title: "¿Puedo modificar mi información?", answer: "Si, en la sección Ajustes -> Perfil, puedes consultar la información con la que te registraste y también modificarla si la deseas, únicamente no puedes modificar tu correo y tu contraseña.")
]

class PreguntasFrecuentesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        overrideUserInterfaceStyle = .light
        
        tableView.dataSource = self
        tableView.delegate = self
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FAQTableViewCell {
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
    }

}
