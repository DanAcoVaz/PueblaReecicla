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
    var isBeforeDayStart: Bool = false
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
        comentariosField.delegate = self
        comentariosField.text = "Comentarios para el Recolector"
        comentariosField.textColor = UIColor.gray
        
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
        
        self.isDayOver = checkIfDayIsOver()
        
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
        } else {
            // fecha
            fechaFieldPicker.text = formatDate(date: Date()) // todays Date
            datePicker.minimumDate = Date()
        }
        
        updateTimePickers()
        
        timeIniFieldPicker.inputView = timeIniPicker
        timeEndFieldPicker.inputView = timeEndPicker
        fechaFieldPicker.inputView = datePicker
    }
    
    private func notSameDay() -> Bool {
        let dateSelected = fechaFieldPicker.text
        return !(dateSelected == self.curDate)
    }
    
    private func updateTimePickers() {
        if(self.isDayOver || notSameDay()) {
            // time picker de Inicio
            let minimumDateIni = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())
            let maximumDateIni = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())
            timeIniPicker.maximumDate = maximumDateIni
            timeIniPicker.minimumDate = minimumDateIni
            timeIniPicker.date = minimumDateIni!
            timeIniFieldPicker.text = formatTime(date: minimumDateIni!)
            
            // time picker de Final
            let minimumDateEnd = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
            let maximumDateEnd = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: Date())
            timeEndPicker.maximumDate = maximumDateEnd
            timeEndPicker.minimumDate = minimumDateEnd
            timeEndPicker.date = minimumDateEnd!
            timeEndFieldPicker.text = formatTime(date: minimumDateEnd!)
        } 
        else {
            // time picker de Inicio
            var minimumDateIni = Date()
            
            if (self.isBeforeDayStart) {
                minimumDateIni = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
            } else {
                minimumDateIni = checkIfTimeIniIsInRange(minimumDateIni: Date())
            }
            
            let maximumDateIni = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())
            timeIniPicker.maximumDate = maximumDateIni
            timeIniPicker.minimumDate = minimumDateIni
            timeIniPicker.date = minimumDateIni
            timeIniFieldPicker.text = formatTime(date: minimumDateIni)
            
            // time picker de Final
            var minimumDateEnd = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            
            minimumDateEnd = checkIfTimeEndIsInRange(minimumDateEnd: minimumDateEnd!)
            
            let maximumDateEnd = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: Date())
            timeEndPicker.maximumDate = maximumDateEnd
            timeEndPicker.minimumDate = minimumDateEnd
            timeEndPicker.date = minimumDateEnd!
            timeEndFieldPicker.text = formatTime(date: minimumDateEnd ?? Date())
        }
    }
    
    private func checkIfTimeIniIsInRange (minimumDateIni: Date) -> Date {
        let componentsDateIni = Calendar.current.dateComponents([.hour, .minute], from: minimumDateIni)
        if (componentsDateIni.hour! < 7) {
            return calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        } else if (componentsDateIni.hour! >= 18 && componentsDateIni.minute! > 0) {
            return calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        }
        return Date()
    }
    
    private func checkIfTimeEndIsInRange (minimumDateEnd: Date) -> Date {
        let componentsDateIni = Calendar.current.dateComponents([.hour, .minute], from: minimumDateEnd)
        if (componentsDateIni.hour! < 8) {
            return calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        } else if ((componentsDateIni.hour! == 19 && componentsDateIni.minute! > 0) || componentsDateIni.hour! > 19) {
            return calendar.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!
        }
        return Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    }
    
    @objc func timeIniPickerValueChanged(sender: UIDatePicker) {
        timeIniFieldPicker.text = formatTime(date: sender.date)
    }
    
    @objc func timeEndPickerValueChanged(sender: UIDatePicker) {
        timeEndFieldPicker.text = formatTime(date: sender.date)
    }
    
    @objc func fechaBtnViewTapped() {
        // Trigger the date picker when fechaBtnView is tapped
        fechaFieldPicker.becomeFirstResponder()
    }
    
    // Handle the tap on fechaBtn
     @objc func dateChange(sender: UIDatePicker) {
         // Your code for timeIniBtn tap event
         fechaFieldPicker.text = formatDate(date: sender.date)
         self.isDayOver = checkIfDayIsOver()
         updateTimePickers()
     }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX") // Set the locale to Spanish
        formatter.dateFormat = "E. dd 'de' MMM 'de' yyyy" // Define the desired date format
        return formatter.string(from: date)
    }
    
    func formatDateToDDMMYYYY(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
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
    
    private func checkIfDayIsOver() -> Bool {
        // Se consigue la hora actual
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        if let hour = components.hour, let minute = components.minute {
            
            if (hour < 7) {
                self.isBeforeDayStart = true
            } else{
                self.isBeforeDayStart = false
            }
            
            if (hour >= 18 && minute > 0) {
                return true
            } else {return false}
        } else {
            print("Error extracting components from the current date.")
            return false
        }
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
        // Check if the end time is after the start time
        if timeEndPicker.date <= timeIniPicker.date {
            showAlert(message: "La hora de finalización debe ser después de la hora de inicio.")
            return false
        }
        
        // Check if there is at least a 1-hour difference
        let timeDifference = calendar.dateComponents([.hour], from: timeIniPicker.date, to: timeEndPicker.date)
        if let hours = timeDifference.hour, hours < 1 {
            showAlert(message: "La recolección debe tener al menos 60 minutos de tiempo disponible.")
            return false
        }

        // Check if the end time is after 19:00
        let calendar = Calendar.current
        let endComponents = calendar.dateComponents([.year, .month, .day], from: timeEndPicker.date)
        let sevenPM = calendar.date(bySettingHour: 19, minute: 0, second: 0, of: calendar.date(from: endComponents)!)!

        if timeEndPicker.date > sevenPM {
            showAlert(message: "La hora de finalización debe ser antes de las 19:00.")
            return false
        }

        return true
    }


    // Function to display an alert with a custom message
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Continuar", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func finishHorario(_ sender: ButtonStyle) {
        if (validateTimeFields() && validateComentariosField()) {
            // Set values in the shared data container
            BundleRecoleccion.shared.selectedDate = formatDateToDDMMYYYY(date: datePicker.date)
            BundleRecoleccion.shared.timeIni = formatTime(date: timeIniPicker.date)
            BundleRecoleccion.shared.timeEnd = formatTime(date: timeEndPicker.date)
            BundleRecoleccion.shared.commentaries = comentariosField.text ?? ""
            BundleRecoleccion.shared.enPersonaSelected = enPersonaSelected

            // Navigate to the next view controller
            let storyboard = UIStoryboard(name: "Recycle", bundle: nil)
            if let direccionViewController = storyboard.instantiateViewController(withIdentifier: "Direccion") as? DireccionVC {
                self.navigationController?.pushViewController(direccionViewController, animated: true)
            }
        }
    }
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
    }
    
    
}

extension HorarioVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "Comentarios para el Recolector" {
            // Reset the placeholder if the text view is currently empty or has placeholder text
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}


