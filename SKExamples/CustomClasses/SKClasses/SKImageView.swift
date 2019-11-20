//
//  SKImageView.swift
//  BodyFrame
//
//  Created by Matrix Mini on 04/11/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class SKImageView: UIImageView {
	
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
		refreshBorderColor(_colorBorder: customBorderColor)
		refreshBorder(_borderWidth: borderWidth)
	}
	
	@IBInspectable var cornerRadius: CGFloat = 1.0 {
		didSet {
			refreshCorners(value: cornerRadius)
		}
	}
	
	func refreshCorners(value: CGFloat) {
		layer.cornerRadius = (value * 0.1)  * self.frame.height
	}
	
	@IBInspectable var borderWidth: CGFloat = 1 {
		didSet {
			refreshBorder(_borderWidth: borderWidth)
		}
	}
	
	func refreshBorder(_borderWidth: CGFloat) {
		layer.borderWidth = _borderWidth
	}
	
	@IBInspectable var customBorderColor: UIColor = UIColor.init (red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1){
		didSet {
			refreshBorderColor(_colorBorder: customBorderColor)
		}
	}
	
	func refreshBorderColor(_colorBorder: UIColor) {
		layer.borderColor = _colorBorder.cgColor
	}
}
