//
//  UbicacionVC.swift
//  PueblaReecicla
//
//  Created by Administrador on 24/11/23.
//

import UIKit
import MapKit
import CoreLocation

class UbicacionVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {

    var popUpExplicacion: UBI_Explicacion!
    
    var LocationManager: CLLocationManager?
    var CenterPin:PinAnnotation! = nil
    var Latitud = 0.0
    var Longitud = 0.0
    var CurrentLocation:CLLocation! = nil
    var region:MKCoordinateRegion! = nil
    
    @IBOutlet var MapOS: MKMapView!
    @IBOutlet var continuarBtn: ButtonStyle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.popUpExplicacion = UBI_Explicacion(frame: self.view.frame, inView: self)
        
        showPopUpExplanation()
        
        MapOS.delegate = self
        Latitud = 19.058220
        Longitud = -98.212781
        LocationManager = CLLocationManager()
        LocationManager?.delegate = self
        LocationManager?.requestWhenInUseAuthorization()
        
        checkLocationAccess()
        
        requestOnTimeLocation()
    }
    
    func checkLocationAccess() {
        switch CLLocationManager().authorizationStatus {
        case .denied, .restricted:
            print("Denied or restricted, request permission from settings")
            presentLocationSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized, proceed")
        case .notDetermined:
            break // Do nothing for now, as you are already requesting location authorization in viewDidLoad
        @unknown default: break
        }
    }
    
    func presentLocationSettings() {
        let alertController = UIAlertController(title: "Error",
                                                message: "Se necesita el permiso de ubicación",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { _ in
            // Handle cancel action
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Ajustes", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        present(alertController, animated: true)
    }

    
    func UpdateLocation(latitud lat: Double, longitud lon: Double) {
        CurrentLocation = CLLocation(latitude: lat, longitude: lon)
        MapOS.centerToLocation(CurrentLocation)
        
        region = MKCoordinateRegion(
              center: CurrentLocation.coordinate,
              latitudinalMeters: 500000,
              longitudinalMeters: 600000)
        MapOS.setCameraBoundary(
              MKMapView.CameraBoundary(coordinateRegion: region),
              animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 500000)
        MapOS.setCameraZoomRange(zoomRange, animated: true)
        
        CenterPin = PinAnnotation(title: "Mi Ubicacion", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), image: "", telefono: "", FavoriteCenter: true)
        
        self.continuarBtn.isEnabled = true
        MapOS.addAnnotation(CenterPin)
        
    }
    
    func requestOnTimeLocation() {
        LocationManager?.requestLocation()
    }
    
    func stopLocationUpdate() {
        LocationManager?.stopUpdatingLocation()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Latitud = location.coordinate.latitude
        Longitud = location.coordinate.longitude
        UpdateLocation(latitud: Latitud, longitud: Longitud)
        print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
        stopLocationUpdate()  // Stop location updates after receiving the initial location
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Nothing Bro")
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("Nothing Bro")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? PinAnnotation {
            
            let identifier = "Mi Ubicacion"
            var annotationView: MKMarkerAnnotationView
            
            
            annotationView = PinAnnotationWindow(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.isDraggable = true
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            switch newState {
            case .starting:
                self.continuarBtn.isEnabled = false
                view.dragState = .dragging
            case .ending, .canceling:
                if let annotation = view.annotation as? PinAnnotation {
                            let newCoordinate = annotation.coordinate
                            print("New Coordinates: \(newCoordinate.latitude), \(newCoordinate.longitude)")

                            Latitud = newCoordinate.latitude
                            Longitud = newCoordinate.longitude
                    
                    self.continuarBtn.isEnabled = true
                        }
                view.dragState = .none
            default: break
            }
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .notDetermined:
                print("When user did not yet determined")
                
            case .restricted:
                print("Restricted by parental control")
            case .denied:
                print("When user select option Dont't Allow")
                
            case .authorizedAlways:
                print("When user select option Change to Always Allow")
            case .authorizedWhenInUse:
                print("When user select option Allow While Using App or Allow Once")
                LocationManager?.requestAlwaysAuthorization()
            default:
                print("default")
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LocationManager?.stopUpdatingLocation()

        if let clErr = error as? CLError {
            switch clErr.code {
            case .locationUnknown, .denied, .network:
                print("Location request failed with error: \(clErr.localizedDescription)")
                presentLocationSettings()
            case .headingFailure:
                print("Heading request failed with error: \(clErr.localizedDescription)")
            case .rangingUnavailable, .rangingFailure:
                print("Ranging request failed with error: \(clErr.localizedDescription)")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                print("Region monitoring request failed with error: \(clErr.localizedDescription)")
            default:
                print("Unknown location manager error: \(clErr.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
        }
    }
    
    @objc func continuarBtnTapped() {
        BundleRecoleccion.shared.latitud = String(self.Latitud)
        BundleRecoleccion.shared.longitud = String(self.Longitud)
        // Navigate to the next view controller
        let storyboard = UIStoryboard(name: "Recycle", bundle: nil)
        if let direccionViewController = storyboard.instantiateViewController(withIdentifier: "Materiales") as? DireccionVC {
            self.navigationController?.pushViewController(direccionViewController, animated: true)
        }
    }

    @IBAction func finishUbicacionVC(_ sender: Any) {
        BundleRecoleccion.shared.latitud = String(self.Latitud)
        BundleRecoleccion.shared.longitud = String(self.Longitud)
        // Navigate to the next view controller
        let storyboard = UIStoryboard(name: "Recycle", bundle: nil)
        if let direccionViewController = storyboard.instantiateViewController(withIdentifier: "Materiales") as? MaterialesVC {
            self.navigationController?.pushViewController(direccionViewController, animated: true)
        }
    }
    
    @IBAction func popUpExplanation(_ sender: Any) {
        showPopUpExplanation()
    }
    
    func showPopUpExplanation() {
        self.popUpExplicacion.isUserInteractionEnabled = true
        
        // funciones para botones de los popups
        self.popUpExplicacion.comprendoBtn.addTarget(self, action: #selector(self.comprendoBtn), for: .touchUpInside)
        self.view.addSubview(self.popUpExplicacion)
        
        // Add tap gesture recognizer to handle taps outside the popup
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOutsidePopup))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.popUpExplicacion.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapOutsidePopup(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: popUpExplicacion.container)
            if !popUpExplicacion.container.bounds.contains(location) {
                popUpExplicacion.removeFromSuperview()
            }
        }
    }
    
    @objc func comprendoBtn(){
        self.popUpExplicacion.removeFromSuperview()
    }
    
}


private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
    
}
