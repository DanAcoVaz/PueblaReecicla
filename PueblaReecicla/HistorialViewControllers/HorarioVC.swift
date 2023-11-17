//
//  HorarioVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 16/11/23.
//

import UIKit

class HorarioVC: UIViewController {
    
    
    @IBOutlet weak var fechaBtnView: ViewStyle!
    @IBOutlet weak var fechaTxt: UITextField!
    
    @IBOutlet weak var timeIniBtn: ViewStyle!
    @IBOutlet weak var timeIniTxt: UILabel!
    
    @IBOutlet weak var timeEndBtn: ViewStyle!
    @IBOutlet weak var timeEndtxt: UILabel!
    
    @IBOutlet weak var comentariosField: UITextField!
    
    @IBOutlet weak var enPersonaBtn: ViewStyle!
    @IBOutlet weak var enPuertaBtn: ViewStyle!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comentariosField.layer.borderColor = RecycleViewController.color_fondo?.cgColor
        comentariosField.layer.borderWidth = 1.0
        comentariosField.layer.cornerRadius = 10.0
        // applies shadow to all views
        applyShadow(view: comentariosField)
        applyShadow(view: fechaBtnView)
        applyShadow(view: timeIniBtn)
        applyShadow(view: timeEndBtn)
        applyShadow(view: enPersonaBtn)
        applyShadow(view: enPuertaBtn)
        
        // add click events
        let fechaTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateChange(datePicker:)))
        fechaBtnView.addGestureRecognizer(fechaTapGesture)
        
        // Add tap gesture recognizer to timeIniBtn
        let timeIniTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeIniBtnTapped))
        timeIniBtn.addGestureRecognizer(timeIniTapGesture)

        // Add tap gesture recognizer to timeEndBtn
        let timeEndTapGesture = UITapGestureRecognizer(target: self, action: #selector(timeEndBtnTapped))
        timeEndBtn.addGestureRecognizer(timeEndTapGesture)

        // Add tap gesture recognizer to enPersonaBtn
        let enPersonaTapGesture = UITapGestureRecognizer(target: self, action: #selector(enPersonaBtnTapped))
        enPersonaBtn.addGestureRecognizer(enPersonaTapGesture)

        // Add tap gesture recognizer to enPuertaBtn
        let enPuertaTapGesture = UITapGestureRecognizer(target: self, action: #selector(enPuertaBtnTapped))
        enPuertaBtn.addGestureRecognizer(enPuertaTapGesture)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        fechaTxt.inputView = datePicker
        fechaTxt.text = formatDate(date: Date()) // todays Date
    }
    
    // Handle the tap on fechaBtn
     @objc func dateChange(datePicker: UIDatePicker) {
         // Your code for timeIniBtn tap event
         fechaTxt.text = formatDate(date: datePicker.date)
         print("timeIniBtn tapped")
     }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: date)
    }
    
    // Handle the tap on timeIniBtn
     @objc func timeIniBtnTapped() {
         // Your code for timeIniBtn tap event
         print("timeIniBtn tapped")
     }

     // Handle the tap on timeEndBtn
     @objc func timeEndBtnTapped() {
         // Your code for timeEndBtn tap event
         print("timeEndBtn tapped")
     }

     // Handle the tap on enPersonaBtn
     @objc func enPersonaBtnTapped() {
         // Your code for enPersonaBtn tap event
         print("enPersonaBtn tapped")
     }

     // Handle the tap on enPuertaBtn
     @objc func enPuertaBtnTapped() {
         // Your code for enPuertaBtn tap event
         print("enPuertaBtn tapped")
     }
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
    }
    
}
