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
    @IBOutlet weak var yearlyCircularProgressView: CircularProgressView?
    
    @IBOutlet weak var monthlyProgressTotals: UILabel?
    @IBOutlet weak var yearlyProgressTotals: UILabel?
    
    let icons : [FontType] = [
        .fontAwesome(.userCircleO),
        .fontAwesome(.barChart),
        .fontAwesome(.bellO),
        .fontAwesome(.calendarO),
    ]
    
    static let rowHeight: CGFloat = 250
    
    override func awakeFromNib() {
        
        // TODO: Subclass iconStackView
        if let iconImageViews = iconStackView?.subviews as? [UIImageView] {
            for (index, iconImageView) in iconImageViews.enumerated() {
                iconImageView.setIcon(
                    icon: icons[index],
                    textColor: UIColor(red: 129/255, green: 144/255, blue: 165/255, alpha: 1)
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
