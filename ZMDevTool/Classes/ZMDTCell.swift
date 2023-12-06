//
//  ZMDTCell.swift
//  ZMDevTool
//
//  Created by Sam Chen on 11/17/23.
//

import Foundation
import UIKit

@objcMembers
class ZMDTCellModel: NSObject {
    var icon: UIImage
    var title: String = ""
    var selectedIcon: UIImage
    init(icon: UIImage, title: String, selectedIcon: UIImage) {
        self.icon = icon
        self.title = title
        self.selectedIcon = selectedIcon
    }
}

@objcMembers
class ZMDTCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

