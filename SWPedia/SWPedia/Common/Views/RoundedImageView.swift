//
//  RoundedImageView.swift
//  SWPedia
//
//  Created by Emilio Pavia on 18/02/21.
//

import UIKit

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2.0
    }
}
