//
//  SKButton.swift
//  BodyFrame
//
//  Created by Matrix Mini on 04/11/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import Foundation
import UIKit

//MARK:- SKButton
@IBDesignable class SKButton: UIButton {
	
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
		refreshButtonFont(value: screenFont)
		refreshCorners(value: cornerRadius)
		refreshBorderColor(_colorBorder: customBorderColor)
		refreshBorder(_borderWidth: borderWidth)
		refreshImageWidth(value: ImageWidth)
		refreshImageMode(value: ImageMode)
		refreshPadding(AllowPadding)
	}
	
	@IBInspectable
	public var screenFont : Bool = false {
		didSet {
			if screenFont {
				refreshButtonFont(value: screenFont)
			}
		}
	}
	
	func refreshButtonFont(value: Bool) {
		let pSize = (self.titleLabel?.font.pointSize)!/568//self.font.pointSize/667
		self.titleLabel?.font = (self.titleLabel?.font.withSize(MAINSCREEN_HEIGHT * pSize))!
	}
	
	@IBInspectable var ImageWidth: CGFloat = 20.0 {
		didSet {
			refreshImageWidth(value: ImageWidth)
		}
	}
	
	func refreshImageWidth(value: CGFloat) {
		let totalWidth = self.frame.width
		let imageWidth = (value * 0.01) * totalWidth
		let rightInset = totalWidth - imageWidth
		self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: rightInset)
	}
	
	@IBInspectable var ImageMode: Int = 1 {
		didSet {
			refreshImageMode(value: ImageMode)
		}
	}
	
	func refreshImageMode(value: Int) {
		self.imageView?.contentMode = UIView.ContentMode(rawValue: value)!
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
	
	@IBInspectable var customBorderColor: UIColor = UIColor.clear {
		didSet {
			refreshBorderColor(_colorBorder: customBorderColor)
		}
	}
	
	func refreshBorderColor(_colorBorder: UIColor) {
		layer.borderColor = _colorBorder.cgColor
	}
	
	@IBInspectable var TitleImagePadding: Bool = true {
		didSet {
			refreshTitleImagepadding(TitleImagePadding)
		}
	}
	
	func refreshTitleImagepadding(_ value: Bool) {
		if value {
			self.titleEdgeInsets = UIEdgeInsets(top: PaddingTop, left: TextImagePadding, bottom: PaddingBottom, right: -TextImagePadding)
		}
		else {
			self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		}
		
	}
	
	@IBInspectable var AllowPadding: Bool = true {
		didSet {
			refreshPadding(AllowPadding)
		}
	}
	
	@IBInspectable var PaddingTop: CGFloat = 10 {
		didSet {
			refreshPadding(AllowPadding)
		}
	}
	
	@IBInspectable var PaddingLeft: CGFloat = 10 {
		didSet {
			refreshPadding(AllowPadding)
		}
	}
	
	@IBInspectable var PaddingRight: CGFloat = 10 {
		didSet {
			refreshPadding(AllowPadding)
		}
	}
	
	@IBInspectable var PaddingBottom: CGFloat = 10 {
		didSet {
			refreshPadding(AllowPadding)
		}
	}
	
	@IBInspectable var TextImagePadding: CGFloat = 10 {
		didSet {
			refreshTitleImagepadding(TitleImagePadding)
		}
	}
	
	func refreshPadding(_ allow: Bool) {
		var padding = UIEdgeInsets()
		padding.top = allow ? PaddingTop : 0
		padding.left = allow ? PaddingLeft : 0
		padding.right = allow ? PaddingRight : 0
		padding.bottom = allow ? PaddingBottom : 0
		
		contentEdgeInsets = padding
	}
	
}
