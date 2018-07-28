//
//  CustomerListTableViewCell.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 6/14/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit
import SwiftIcons

class IndividualAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var customerName: UILabel?
    
    @IBOutlet weak var iconsContainer: UIView?
    @IBOutlet weak var iconStackView: UIStackView?
    
    @IBOutlet weak var monthlyCircularProgressView: CircularProgressView?
    @IBOutlet weak var annualCircularProgressView: CircularProgressView?
    
    @IBOutlet weak var monthlyProgressTotals: UILabel?
    @IBOutlet weak var annualProgressTotals: UILabel?
    
    let icons : [FontType] = [
        .dripicon(.user),
        .dripicon(.checklist),
        .dripicon(.bell),
        .dripicon(.calendar),
    ]
    
    static let rowHeight: CGFloat = 250
    
    override func awakeFromNib() {
        
        // TODO: Subclass iconStackView
        if let iconButtons = iconStackView?.subviews as? [UIButton] {
            for (index, iconButton) in iconButtons.enumerated() {
                iconButton.setIcon(
                    icon: icons[index],
                    iconSize: 24,
                    color: UIColor(red: 129/255, green: 144/255, blue: 165/255, alpha: 1),
                    forState: .normal
                )
            }
        }
        
        // TODO: Subclass UIView for this.
        if let iconsContainer = iconsContainer {
            let iconsContainerTopBorder = UIView(frame: CGRect(x: 0, y: 0, width: iconsContainer.frame.width, height: 1))
            iconsContainerTopBorder.backgroundColor = UIColor(red: 232/255, green: 232/255, blue: 243/255, alpha: 1)
            iconsContainer.addSubview(iconsContainerTopBorder)
        }
        
    }
    
}
