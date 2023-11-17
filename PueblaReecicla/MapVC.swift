//
//  MapVC.swift
//  PueblaReecicla
//
//  Created by David Bo on 07/11/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var MapOS: MKMapView!
    @IBOutlet var FilterButton: UIButton!
    
    
    var LocationManager: CLLocationManager?
    var CenterPin:Center! = nil
    var CenterPin2:Center! = nil
    var Latitud = 0.0
    var Longitud = 0.0
    var CurrentLocation:CLLocation! = nil
    var region:MKCoordinateRegion! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MapOS.delegate = self
        Latitud = 19.058220
        Longitud = -98.212781
        LocationManager = CLLocationManager()
        LocationManager?.delegate = self
        LocationManager?.requestWhenInUseAuthorization()
        
        requestOnTimeLocation()
        
    }
    
    
    @IBAction func openCategorySheet(_ sender: UIGestureRecognizer) {
        print("El botón fue presionado")
        configureBottomDialogSheet()
    }
    
    func UpdateLocation(latitud lat: Double, longitud lon: Double) {
        CurrentLocation = CLLocation(latitude: lat, longitude: lon)
        MapOS.centerToLocation(CurrentLocation)
        
        region = MKCoordinateRegion(
              center: CurrentLocation.coordinate,
              latitudinalMeters: 50000,
              longitudinalMeters: 60000)
        MapOS.setCameraBoundary(
              MKMapView.CameraBoundary(coordinateRegion: region),
              animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        MapOS.setCameraZoomRange(zoomRange, animated: true)
        
        CenterPin = Center(title: "Centro 1", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), image: "location", telefono: "7714834386", FavoriteCenter: true)
        
        CenterPin2 = Center(title: "Centro 1", coordinate: CLLocationCoordinate2D(latitude: 19.058330, longitude: lon), image: "location", telefono: "7714834386", FavoriteCenter: true)
        
        MapOS.addAnnotation(CenterPin)
        MapOS.addAnnotation(CenterPin2)
        
    }
    
    func requestOnTimeLocation() {
        LocationManager?.requestLocation()
    }
    
    private func stopLocationUpdate() {
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
    
    private func configureBottomDialogSheet() {
        let vc = DialogSheet()
        let navVC = UINavigationController(rootViewController: vc)
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController?.present(navVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Center {
            
            let identifier = "Center"
            var annotationView: MKMarkerAnnotationView
            
            
            annotationView = WindowCenter(annotation: annotation, reuseIdentifier: identifier)
            annotationView.glyphImage = UIImage(named: "location")
            annotationView.canShowCallout = true
            annotationView.isDraggable = true
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            switch newState {
            case .starting:
                view.dragState = .dragging
            case .ending, .canceling:
                if let annotation = view.annotation as? Center {
                            let newCoordinate = annotation.coordinate
                            print("New Coordinates: \(newCoordinate.latitude), \(newCoordinate.longitude)")

                            Latitud = newCoordinate.latitude
                            Longitud = newCoordinate.longitude
                        }
                view.dragState = .none
            default: break
            }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotationView = view as? WindowCenter {
            // Create and display your custom callout view
            let customCalloutView = CustomWindowView()
            // Position the callout view relative to the marker annotation
            customCalloutView.frame = CGRect(x: -50, y: -250, width: 115, height: 200)
            customAnnotationView.addSubview(customCalloutView)
            customCalloutView.printLabels()
            customCalloutView.setLabels(annotation: CenterPin)
            customCalloutView.setUIContext(context: self)
        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for subview in view.subviews {
            if let customCalloutView = subview as? CustomWindowView {
                customCalloutView.removeFromSuperview()
            }
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

