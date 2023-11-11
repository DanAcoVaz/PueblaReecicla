//
//  HistorialCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Administrador on 10/11/23.
//

import UIKit

class HistorialCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var estadoColorView: UIView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var materialesLabel: UILabel!
    @IBOutlet weak var estadoTextoLabel: UILabel!
    
    @IBOutlet weak var fondoRecoleccion: UIView!
    
    static let identifier = "HistorialCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        estadoColorView.layer.cornerRadius = 8 // se redondea el cuadrado del estado
        
        fondoRecoleccion.layer.cornerRadius = 8 // se redondea el cuadrado del fondo de la recolección
        fondoRecoleccion.layer.borderWidth = 1.0  // Set the width of the stroke
        fondoRecoleccion.layer.borderColor = UIColor(named: "gray")!.cgColor
        
        // se agrega una sombra al fondo de la recolecciòn
        fondoRecoleccion.backgroundColor = UIColor(named: "white")  // Set the background color

    }
    
    public func configure(with estadoColor: UIColor, fecha: String, horario: String, materiales: String, estadoTexto: String, estadoTextoColor: UIColor) {
        
        // se cambia el color del cuadro de color del estado
        estadoColorView.backgroundColor? = estadoColor
        
        // se cambia el texto de las siguientes labels
        fechaLabel.text = fecha
        horarioLabel.text = horario
        materialesLabel.text = materiales
        
        // texto debajo del cuadro de color, se cambia su texto y color
        estadoTextoLabel.text = estadoTexto
        estadoTextoLabel.textColor = estadoTextoColor
    }
    
    static func nib() -> UINib {
        return UINib(nibName: HistorialCollectionViewCell.identifier, bundle: nil)
    }

}
