//
//  WindowCenter.swift
//  PueblaReecicla
//
//  Created by Alumno on 14/11/23.
//

import Foundation
import MapKit

class WindowCenter: MKMarkerAnnotationView {
    
    var centerName: String?
    var centerImage: String?
    var favoriteCenter: Bool?
    var centerPhone: String?
    var customCalloutView: CustomWindowView?
    private var customDetailCalloutView: UIView?
    
    override var annotation: MKAnnotation? {
        willSet {
          guard let artwork = newValue as? Center else {
            return
          }

          canShowCallout = true
          markerTintColor = .clear
          image = UIImage(named: artwork.CenterCategory)
          glyphImage = nil
          selectedGlyphImage = nil
            glyphTintColor = .clear
        }
    }

    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubviewToFront(self)
        }
        return hitView
    }


    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if(!isInside) {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
    
}
