//
//  CategoryBottomSheetDialog.swift
//  PueblaReecicla
//
//  Created by Alumno on 16/11/23.
//

import UIKit

class CategoryBottomSheetDialog: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#4489CA")
        
        // ==============================================================================================
        
        // Crear el layout para el Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Establecer la dirección del scroll (puede ser horizontal)

        // Crear una instancia de UICollectionView con el layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(hexString: "#4489CA") // Color de fondo del Collection View
        collectionView.translatesAutoresizingMaskIntoConstraints = false // Habilitar restricciones
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")


        // Agregar el Collection View a la vista principal o al "bottom sheet"
        view.addSubview(collectionView)

        // Configurar restricciones para el Collection View
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200) // Altura deseada del Collection View
        ])
        
        
        // ==============================================================================================
        
        // Crear un UILabel
        let label = UILabel()
        label.text = "Centros"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false // Habilitar restricciones

        // Agregar el UILabel a la vista principal
        view.addSubview(label)

        // Configurar restricciones para posicionar el UILabel
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -15) // Colocar el UILabel encima del Collection View con un espacio de 15 puntos
        ])

        
        // ==============================================================================================
        
        
    }
}

extension CategoryBottomSheetDialog: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Número de elementos en el Collection View
        return 10 // Por ejemplo, 10 elementos ficticios
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configurar la celda del Collection View
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as UICollectionViewCell
        cell.backgroundColor = .lightGray // Color de fondo de la celda (ficticio)
        
        // Puedes personalizar la celda con contenido ficticio
        // Por ejemplo, agregar una etiqueta de texto
        let label = UILabel(frame: cell.bounds)
        label.text = "Item \(indexPath.item)"
        label.textAlignment = .center
        label.textColor = .black
        cell.addSubview(label)
        
        return cell
    }
}

extension CategoryBottomSheetDialog: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50) // Altura deseada de la celda
    }
}


extension UIColor {
    convenience init?(hexString: String) {
        var formattedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }

        var hexValue: UInt64 = 0
        guard Scanner(string: formattedString).scanHexInt64(&hexValue) else { return nil }

        let red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hexValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
