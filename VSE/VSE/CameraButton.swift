//
//  CameraButton.swift
//  VSE
//
//  Created by kehlin swain on 5/27/16.
//  Copyright © 2016 Darian Nwankwo. All rights reserved.
//

import UIKit

class CameraButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1.0
    }

}
