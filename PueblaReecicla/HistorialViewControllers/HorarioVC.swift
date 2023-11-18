//
//  HorarioVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 16/11/23.
//

import UIKit

class HorarioVC: UIViewController {
    
    @IBOutlet weak var fechaBtnView: ViewStyle!
    @IBOutlet weak var fechaFieldPicker: UITextField!
    
    @IBOutlet weak var timeIniBtn: ViewStyle!
    @IBOutlet weak var timeIniFieldPicker: UITextField!
    
    @IBOutlet weak var timeEndBtn: ViewStyle!
    @IBOutlet weak var timeEndFieldPicker: UITextField!
    
    @IBOutlet weak var comentariosField: UITextView!
    
    @IBOutlet weak var enPersonaBtn: ViewStyle!
    @IBOutlet weak var enPuertaBtn: ViewStyle!

    @IBOutlet var mainView: UIView!
    
    var isDayOver: Bool = false
    var lessThan1HrLeft: Bool = false
    var curDate: String = ""
    let calendar = Calendar.current
    
    let datePicker = UIDatePicker()
    let timeIniPicker = UIDatePicker()
    let timeEndPicker = UIDatePicker()
    
    var enPersonaSelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.curDate = formatDate(date: Date())
        //fechaFieldPicker.layer.borderColor = UIColor.white.cgColor
        fechaFieldPicker.borderStyle = .none
        
        timeIniFieldPicker.borderStyle = .none
        timeEndFieldPicker.borderStyle = .none
        
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
        let fechaTapGesture = UITapGestureRecognizer(target: self, action: #selector(fechaBtnViewTapped))
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped(_:)))
            mainView.addGestureRecognizer(tapGesture)
        
        // Se consigue la hora actual
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        if let hour = components.hour {
            // Check if the current time is after 19:00
            if (hour > 18) {
                isDayOver = true
            }
        } else {
            print("Error extracting components from the current date.")
        }
        
        // se establece el Datepicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(sender:)), for: UIControl.Event.valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        
        // se establece el time picker para el tiempo de inicio
        timeIniPicker.datePickerMode = .time
        timeIniPicker.locale = Locale(identifier: "en_GB")
        timeIniPicker.timeZone = TimeZone(identifier: "America/Mexico_City")
        timeIniPicker.addTarget(self, action: #selector(timeIniPickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        timeIniPicker.preferredDatePickerStyle = .wheels
        
        // se establece el time picker para el tiempo de final
        timeEndPicker.datePickerMode = .time
        timeEndPicker.locale = Locale(identifier: "en_GB")
        timeEndPicker.timeZone = TimeZone(identifier: "America/Mexico_City")
        timeEndPicker.addTarget(self, action: #selector(timeEndPickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        timeEndPicker.preferredDatePickerStyle = .wheels
        
        if(isDayOver) {
            // fecha
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            fechaFieldPicker.text = formatDate(date: tomorrow!)
            datePicker.minimumDate = tomorrow
            
            // time picker de Inicio
            let minimumDateIni = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())
            let maximumDateIni = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())
            timeIniPicker.maximumDate = maximumDateIni
            timeIniPicker.minimumDate = minimumDateIni
            timeIniPicker.date = minimumDateIni!
            timeIniFieldPicker.text = formatTime(date: minimumDateIni!)
            
            // time picker de Final
            let minimumDateEnd = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
            let maximumDateEnd = calendar.date(bySettingHour: 18, minute: 59, second: 0, of: Date())
            timeEndPicker.maximumDate = maximumDateEnd
            timeEndPicker.minimumDate = minimumDateEnd
            timeEndPicker.date = minimumDateEnd!
            timeEndFieldPicker.text = formatTime(date: minimumDateEnd!)
        } else {
            // fecha
            fechaFieldPicker.text = formatDate(date: Date()) // todays Date
            datePicker.minimumDate = Date()
            
            // time picker de Inicio
            let minimumDateIni = Date()
            let maximumDateIni = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())
            timeIniPicker.maximumDate = maximumDateIni
            timeIniPicker.minimumDate = minimumDateIni
            timeIniPicker.date = minimumDateIni
            timeIniFieldPicker.text = formatTime(date: Date())
            
            // time picker de Final
            
            let minimumDateEnd = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            let maximumDateEnd = calendar.date(bySettingHour: 18, minute: 59, second: 0, of: Date())
            timeEndPicker.maximumDate = maximumDateEnd
            timeEndPicker.minimumDate = minimumDateEnd
            timeEndPicker.date = minimumDateEnd!
            timeEndFieldPicker.text = formatTime(date: Date())
        }
        
        timeIniFieldPicker.inputView = timeIniPicker
        timeEndFieldPicker.inputView = timeEndPicker
        fechaFieldPicker.inputView = datePicker
    }
    
    private func notSameDay() -> Bool {
        let dateSelected = fechaFieldPicker.text
        return dateSelected == self.curDate
    }
    
    @objc func timeIniPickerValueChanged(sender: UIDatePicker) {
        timeIniFieldPicker.text = formatTime(date: sender.date)
    }
    
    @objc func timeEndPickerValueChanged(sender: UIDatePicker) {
        timeIniFieldPicker.text = formatTime(date: sender.date)
    }
    
    @objc func fechaBtnViewTapped() {
        // Trigger the date picker when fechaBtnView is tapped
        fechaFieldPicker.becomeFirstResponder()
    }
    
    // Handle the tap on fechaBtn
     @objc func dateChange(sender: UIDatePicker) {
         // Your code for timeIniBtn tap event
         fechaFieldPicker.text = formatDate(date: sender.date)
     }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX") // Set the locale to Spanish
        formatter.dateFormat = "E. dd 'de' MMM 'de' yyyy" // Define the desired date format
        return formatter.string(from: date)
    }
    
    func createCustomDate(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date? {
        // Get the current calendar
        let calendar = Calendar.current
        
        // Get the current date components
        let currentDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        // Create date components with provided values or use current date components
        var customDateComponents = DateComponents()
        customDateComponents.year = year ?? currentDateComponents.year
        customDateComponents.month = month ?? currentDateComponents.month
        customDateComponents.day = day ?? currentDateComponents.day
        customDateComponents.hour = hour ?? currentDateComponents.hour
        customDateComponents.minute = minute ?? currentDateComponents.minute
        customDateComponents.second = second ?? currentDateComponents.second
        
        // Create a date from components
        return calendar.date(from: customDateComponents)
    }
    
    func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }

    // Handle tap outside of the date picker
    @objc func mainViewTapped(_ gesture: UITapGestureRecognizer) {
        fechaFieldPicker.resignFirstResponder()
        timeIniFieldPicker.resignFirstResponder()
        timeEndFieldPicker.resignFirstResponder()
    }
    
    // Handle the tap on timeIniBtn
     @objc func timeIniBtnTapped() {
         timeIniFieldPicker.becomeFirstResponder()
     }

     // Handle the tap on timeEndBtn
     @objc func timeEndBtnTapped() {
         timeEndFieldPicker.becomeFirstResponder()
     }

     // Handle the tap on enPersonaBtn
     @objc func enPersonaBtnTapped() {
         updateRadioButtonSelection(selectedButton: enPersonaBtn)
     }

     // Handle the tap on enPuertaBtn
     @objc func enPuertaBtnTapped() {
         updateRadioButtonSelection(selectedButton: enPuertaBtn)
     }
    
    // Function to update radio button selection
    func updateRadioButtonSelection(selectedButton: ViewStyle) {
        // Update the selected state and UI for enPersonaBtn
        enPersonaSelected = (selectedButton == enPersonaBtn)
        enPersonaBtn.backgroundColor = enPersonaSelected ? RecycleViewController.blue : RecycleViewController.light_blue

        // Update the selected state and UI for enPuertaBtn
        enPuertaBtn.backgroundColor = enPersonaSelected ? RecycleViewController.light_blue : RecycleViewController.blue
    }
    
    func validateComentariosField() -> Bool {
        guard let comentariosText = comentariosField.text else {
            // Handle nil case if needed
            return false
        }

        let maxLength = 100

        if comentariosText.count > maxLength {
            // If comentariosField exceeds 100 characters, truncate the text and show an alert
            let truncatedText = String(comentariosText.prefix(maxLength))
            comentariosField.text = truncatedText
            // Display an alert to inform the user
            showAlert(message: "Los comentarios no pueden exceder los 100 caracteres")
            return false
        }

        return true
    }
    
    func validateTimeFields() -> Bool {
        // Get the selected time from the timeIniPicker and timeEndPicker
        let timeIni = timeIniPicker.date
        let timeEnd = timeEndPicker.date

        // Check if the end time is after the start time
        if timeEnd <= timeIni {
            showAlert(message: "La hora de finalización debe ser después de la hora de inicio")
            return false
        }
        
        // Check if there is at least a 1-hour difference
         let timeDifference = calendar.dateComponents([.hour], from: timeIni, to: timeEnd)
         if let hours = timeDifference.hour, hours < 1 {
             showAlert(message: "La recolección debe tener al menos 60 minutos de tiempo disponible")
             return false
         }

        // Optionally, you can add more specific time range validation logic here if needed.

        return true
    }

    // Function to display an alert with a custom message
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func finishHorarioSelection(_ sender: Any) {
        if (validateTimeFields() && validateComentariosField()) {
            print("success")
        }
    }
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
    }
    
}
