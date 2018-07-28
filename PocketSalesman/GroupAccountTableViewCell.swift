//
//  GroupAccountTableViewCell.swift
//  PocketSalesman
//
//  Created by Kasey - Personal on 7/4/18.
//  Copyright © 2018 Kasey - Personal. All rights reserved.
//

import UIKit

class GroupAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var customerName: UILabel?
    @IBOutlet weak var disclosureIndicator: UIImageView?
    @IBOutlet weak var groupCountBadge: UILabel?
    
    static let rowHeight: CGFloat = 96
    
    override func awakeFromNib() {
        disclosureIndicator?.setIcon(icon: .ionicons(.iosArrowForward))
    }
    
}
