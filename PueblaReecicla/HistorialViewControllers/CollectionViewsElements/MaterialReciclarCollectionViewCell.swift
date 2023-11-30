//
//  MaterialReciclarCollectionViewCell.swift
//  PueblaReecicla
//
//  Created by Administrador on 20/11/23.
//

import UIKit

class MaterialReciclarCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {

    static let identifier = "MaterialReciclarCollectionViewCell"
    
    var tomarFotoBtnTapped: (() -> Void)?
    var eliminarBtnTapped: (() -> Void)?
    var unidadMaterialBtnTapped: (() -> Void)?
    
    var plusBtnTapped: (() -> Void)?
    var minusBtnTapped: (() -> Void)?
    
    @IBOutlet var imgMaterial: UIImageView!
    @IBOutlet var nombreMaterial: UILabel!
    @IBOutlet var plusMinusBtn: UIStackView!
    @IBOutlet var tomarFotoBtn: ViewStyle!
    @IBOutlet var tomarFotoBtnTxt: UILabel!
    
    @IBOutlet var eliminarBtn: ViewStyle!
    @IBOutlet var cantidadMaterial: UILabel!
    @IBOutlet var plusBtn: UIImageView!
    @IBOutlet var minusBtn: UIImageView!
    @IBOutlet var unidadMaterialBtn: ViewStyle!
    @IBOutlet var unidadMaterialTxt: UILabel!
    
    var isDropdownVisible = false
    
    var overlayView: UIView?
    
    var data = ["Bolsas", "Bote", "Cajas", "Kilos"]
    var tableView = UITableView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set up the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self

        // Set up the dropdown button
        let unidadMaterialTapGesture = UITapGestureRecognizer(target: self, action: #selector(dropdownButtonTapped))
        unidadMaterialBtn.addGestureRecognizer(unidadMaterialTapGesture)
           
        applyShadow(view: plusMinusBtn)
        applyShadow(view: tomarFotoBtn)
        applyShadow(view: eliminarBtn)
        
        plusMinusBtn.layer.borderColor = RecycleViewController.color_fondo?.cgColor
        plusMinusBtn.layer.borderWidth = 0.1
        plusMinusBtn.layer.cornerRadius = 20
        
        imgMaterial.layer.cornerRadius = min(imgMaterial.frame.width, imgMaterial.frame.height) / 2.0
        
        let borderLayer = CALayer()
        let borderFrame = CGRect(x: -3.0, y: -3.0, width: imgMaterial.frame.size.height + 6.0, height: imgMaterial.frame.size.height + 6.0)
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.frame = borderFrame
        borderLayer.cornerRadius = (imgMaterial.frame.width + 6.0) / 2.0
        borderLayer.borderWidth = 4.0
        borderLayer.borderColor = RecycleViewController.blue?.cgColor
        imgMaterial.layer.addSublayer(borderLayer)
        
        imgMaterial.layer.masksToBounds = false
        
        plusBtn.isUserInteractionEnabled = true
        let plusBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(plusBtnClicked))
        plusBtn.addGestureRecognizer(plusBtnTapGesture)
        
        minusBtn.isUserInteractionEnabled = true
        let minusBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(minusBtnClicked))
        minusBtn.addGestureRecognizer(minusBtnTapGesture)
        
        eliminarBtn.isUserInteractionEnabled = true
        let eliminarBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(eliminarBtnClick))
        eliminarBtn.addGestureRecognizer(eliminarBtnTapGesture)
        
        tomarFotoBtn.isUserInteractionEnabled = true
        let tomarFotoBtnTapGesture = UITapGestureRecognizer(target: self, action: #selector(tomarFotoBtnClick))
        tomarFotoBtn.addGestureRecognizer(tomarFotoBtnTapGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideDropdown))
        tapGesture.cancelsTouchesInView = false
        window?.addGestureRecognizer(tapGesture)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return data.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.backgroundColor = RecycleViewController.green
         cell.textLabel?.textColor = UIColor.white
         cell.textLabel?.text = data[indexPath.row]
         return cell
     }
    
    @objc func handleTapOutsideDropdown() {
        if isDropdownVisible {
            hideDropdown()
        }
    }

     // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = data[indexPath.row]
        print("selected: \(selectedOption)")
        unidadMaterialTxt.text = selectedOption
        self.unidadMaterialBtnTapped?()
        // Add your custom logic here based on the selected option
        hideDropdown()
    }


     // MARK: - Dropdown Handling

    @objc func dropdownButtonTapped() {
        if isDropdownVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
    }
    

    func showDropdown() {
        print("Showing Dropdown")

        // Get the frame of the unidadMaterialBtn relative to its superview
        let buttonFrameInWindow = self.convert(unidadMaterialBtn.frame, to: nil)

        // Calculate the horizontal center position for the dropdown
        let dropdownX = buttonFrameInWindow.midX - unidadMaterialBtn.frame.size.width / 2.0

        // Use the key window scene to get the window
        guard let window = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) else {
                return
        }

        // Calculate the width of the dropdown (same as unidadMaterialBtn)
        let dropdownWidth = unidadMaterialBtn.frame.size.width

        // Set the frame of the dropdown
        tableView.frame = CGRect(x: dropdownX + 22, y: buttonFrameInWindow.origin.y + buttonFrameInWindow.size.height + 12, width: dropdownWidth, height: CGFloat(data.count * 44))
        tableView.reloadData()
        
        // Create and add the overlay view
        overlayView = UIView(frame: window.bounds)
        overlayView?.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideDropdown))
        overlayView?.addGestureRecognizer(tapGesture)

        window.addSubview(overlayView!)
        
        // Add the dropdown to the window
        window.addSubview(tableView)

        isDropdownVisible = true
    }


     func hideDropdown() {
         tableView.removeFromSuperview()
         overlayView?.removeFromSuperview()
         overlayView = nil
         isDropdownVisible = false
     }
    
    @objc func eliminarBtnClick() {
        eliminarBtnTapped?()
    }
    
    @objc func tomarFotoBtnClick() {
        tomarFotoBtnTapped?()
    }
    
    @objc func plusBtnClicked() {
        var curCantidad = Int(self.cantidadMaterial.text ?? "1") ?? 1
        
        curCantidad += 1
        self.cantidadMaterial.text = String(curCantidad)
        self.plusBtnTapped?()
    }
    
    @objc func minusBtnClicked() {
        var curCantidad = Int(self.cantidadMaterial.text ?? "1") ?? 1
        
        if (curCantidad > 1) {
            curCantidad -= 1
            self.cantidadMaterial.text = String(curCantidad)
        }
        self.minusBtnTapped?()
    }
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
    }

    public func configure(with imgM: UIImage, nombreM: String, cantidad: String, unidad: String) {
        imgMaterial.image = imgM
        nombreMaterial.text = nombreM
        cantidadMaterial.text = cantidad
        unidadMaterialTxt.text = unidad
    }
    
    static func nib() -> UINib {
        return UINib(nibName: MaterialReciclarCollectionViewCell.identifier, bundle: nil)
    }
}
