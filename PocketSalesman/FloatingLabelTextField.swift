//
//  FloatingLabelTextField.swift
//  PocketSalesman
//
//  Created by Kasey Cowley on 7/29/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import SwiftIcons

class FloatingLabelTextField: UITextField, UITextFieldDelegate {
    
    var leftIcon: FontType? {
        didSet {
            if let icon = leftIcon {
                setLeftViewIcon(icon: icon, leftViewMode: .always, textColor: .lightGray, backgroundColor: .clear, size: CGSize(width: HEIGHT, height: HEIGHT))
            }
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            floatingLabel.textColor = tintColor
        }
    }
    
    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
        }
    }
    
    private let LEFT_PADDING: CGFloat = 30.0
    private let HEIGHT: CGFloat = 25.0
    
    lazy private var floatingLabel: UILabel = {
        let label = UILabel()
        
        label.frame = CGRect(origin: CGPoint(x: LEFT_PADDING, y: bounds.midY), size: bounds.size)
        label.alpha = 1
        label.font = font
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        delegate = self
        frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: HEIGHT))
        tintColor = .lightGray
        borderStyle = .none
        
        addSubview(floatingLabel)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        placeholder = ""
        tintColor = UIColor.Theme.primaryBlue
        animateFloatingLabel(toAlpha: 1, toY: (floatingLabel.frame.height / 2) - 35)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tintColor = .lightGray
        
        if textField.isEmpty {
            placeholder = floatingLabel.text
            animateFloatingLabel(toAlpha: 0, toY: bounds.minY)
        }
    }
    
    func animateFloatingLabel(toAlpha alpha: CGFloat, toY y: CGFloat) {
        UIView.animate(withDuration: 1.0) {
            self.floatingLabel.alpha = alpha
            self.floatingLabel.frame.origin.y = y
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return paddingInsets(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return paddingInsets(forBounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return paddingInsets(forBounds: bounds)
    }
    
    func paddingInsets(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, LEFT_PADDING, 0, 0))
    }

}
