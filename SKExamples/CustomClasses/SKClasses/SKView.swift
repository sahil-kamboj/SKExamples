//
//  SKView.swift
//  BodyFrame
//
//  Created by Matrix Mini on 20/11/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SKView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		sharedInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
	}
	
	override func prepareForInterfaceBuilder() {
		sharedInit()
	}
	
	func sharedInit() {
		refreshCorners(value: cornerRadius)
	}
	
	@IBInspectable var cornerRadius: CGFloat = 0.0 {
		didSet {
			refreshCorners(value: cornerRadius)
		}
	}
	
	func refreshCorners(value: CGFloat) {
		layer.cornerRadius = (value * 0.1) * self.frame.height
	}
	
}

extension UIView {
    func setRoundBorderEdgeView(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
