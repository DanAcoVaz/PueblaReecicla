//
//  StyleCenterPopUp.swift
//  PueblaReecicla
//
//  Created by Alumno on 15/11/23.
//

import UIKit

class ViewCenterStyle: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

class ImageViewStyle: UIImageView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

class ButtonStyle: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
