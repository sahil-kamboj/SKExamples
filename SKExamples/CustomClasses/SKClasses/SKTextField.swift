//
//  SKTextField.swift
//  BodyFrame
//
//  Created by Matrix Mini on 04/11/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import Foundation
import UIKit

//MARK:- SKTextField
@IBDesignable class SKTextField: UITextField {
	
	var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
	
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
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	func sharedInit() {
		refreshBottomBorder(BottomBorder)
		refreshRadius(RadiusBorder)
		refreshBorderColor(ColorBorder)
		refreshBorderWidth(WidthBorder)
		refreshPlaceholderColor(PlaceholderColor)
		refreshPadding(AllowPadding)
		refreshLeftView(AllowLeftView)
		refreshRightView(AllowRightView)
	}
	
	//MARK:- Custom Settings
	
	@IBInspectable var BottomBorder: Bool = false {
		didSet {
			refreshBottomBorder(BottomBorder)
		}
	}
	
	func refreshBottomBorder(_ input: Bool) {
		if input {
			let bottomLine = CALayer()
			bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
			bottomLine.backgroundColor = ColorBorder.cgColor
			self.borderStyle = UITextField.BorderStyle.none
			self.layer.addSublayer(bottomLine)
		}
	}
	
	@IBInspectable var RadiusBorder: CGFloat = 1.0 {
		didSet {
			refreshRadius(RadiusBorder)
		}
	}
	
	func refreshRadius(_ value: CGFloat) {
		layer.cornerRadius = (value * 0.1)  * self.frame.height
	}
	
	@IBInspectable var ColorBorder: UIColor = AppColor.AppTextGray {
		didSet {
			refreshBorderColor(ColorBorder)
		}
	}
	
	func refreshBorderColor(_ value: UIColor) {
//		layer.borderWidth = 1.0
		layer.borderColor = value.cgColor
	}
	
	@IBInspectable var WidthBorder: CGFloat = 0.0 {
		didSet {
			refreshBorderWidth(WidthBorder)
		}
	}
	
	func refreshBorderWidth(_ value: CGFloat) {
		layer.borderWidth = value
		//			layer.borderColor = value.cgColor
	}
	
	@IBInspectable var PlaceholderColor: UIColor = AppColor.AppTextGray {	//UIColor.white {
		didSet {
			refreshPlaceholderColor(PlaceholderColor)
		}
	}
	
	func refreshPlaceholderColor(_ value: UIColor) {
		self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: PlaceholderColor])
	}
	
	@IBInspectable var AllowLeftView: Bool = false {
			didSet {
				refreshLeftView(AllowLeftView)
			}
		}
		
		@IBInspectable var WidthLeftView: CGFloat = 10.0 {
			didSet {
				refreshLeftView(AllowLeftView)
			}
		}
		
		@IBInspectable var ImageLeftView: UIImage = UIImage() {
			didSet {
				refreshLeftView(AllowLeftView)
			}
		}
		
		func refreshLeftView(_ value: Bool) {
			if value {
				let viewLimit: CGFloat = (WidthLeftView * 0.01) * self.frame.width
				
				let toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: viewLimit, height: self.frame.height * 0.8))
				toggleButton.setImage(ImageLeftView, for: .normal)
				toggleButton.imageView?.contentMode = .scaleAspectFit
				toggleButton.layer.masksToBounds = true
	//			toggleButton.addTarget(self, action: #selector(toggle_password(sender:)), for: .touchUpInside)
				
				self.leftView = toggleButton
				self.leftViewMode = .always
			}
		}
	
	@IBInspectable var AllowRightView: Bool = false {
		didSet {
			refreshRightView(AllowRightView)
		}
	}
	
	@IBInspectable var WidthRightView: CGFloat = 10.0 {
		didSet {
			refreshRightView(AllowRightView)
		}
	}
	
	@IBInspectable var ImageRightView: UIImage = UIImage() {
		didSet {
			refreshRightView(AllowRightView)
		}
	}
	
	func refreshRightView(_ value: Bool) {
		if value {
			let viewLimit: CGFloat = (WidthRightView * 0.01) * self.frame.width
			
			let toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: viewLimit, height: self.frame.height * 0.8))
			toggleButton.setImage(ImageRightView, for: .normal)
			toggleButton.imageView?.contentMode = .scaleAspectFit
			toggleButton.layer.masksToBounds = true
//			toggleButton.addTarget(self, action: #selector(toggle_password(sender:)), for: .touchUpInside)
			
			self.rightView = toggleButton
			self.rightViewMode = .always
		}
		else {
			self.rightViewMode = .never
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
	
	func refreshPadding(_ allow: Bool) {
		
		padding.top = allow ? PaddingTop : 0
		padding.left = allow ? PaddingLeft : 0
		padding.right = allow ? PaddingRight : 0
		padding.bottom = allow ? PaddingBottom : 0
	}
	
	@IBInspectable var PaddingTextLeft: CGFloat = 10 {
		didSet {
			refreshPadding(AllowPadding)
		}
	}
	
	func limitKyaHai() -> (CGFloat, CGFloat) {
		let viewLimit: CGFloat = (PaddingTextLeft * 0.01) * self.frame.width
		
		let leftlimit: CGFloat = AllowPadding ? (PaddingLeft > 0.0 ? viewLimit : 0.0) : 0.0
		let rightlimit: CGFloat = AllowPadding ? (PaddingRight > 0.0 ? viewLimit : 0.0) : 0.0
		return (leftlimit, rightlimit)
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		
		let textPadding = UIEdgeInsets(top: 10, left: limitKyaHai().0, bottom: 10, right: limitKyaHai().1)
		return bounds.inset(by: textPadding)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		
		let textPadding = UIEdgeInsets(top: 10, left: limitKyaHai().0, bottom: 10, right: limitKyaHai().1)
		return bounds.inset(by: textPadding)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		
		let textPadding = UIEdgeInsets(top: 10, left: limitKyaHai().0, bottom: 10, right: limitKyaHai().1)
		return bounds.inset(by: textPadding)
	}
	
	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		let diffWidth = self.frame.width < (375/2) ? self.frame.width * 0.1 : self.frame.width * 0.1
		var leftInset = UIEdgeInsets()
		leftInset.top = PaddingTop
		leftInset.bottom = PaddingBottom
		leftInset.right = self.frame.width - diffWidth
		leftInset.left = PaddingLeft
		
		return bounds.inset(by: leftInset)
	}
	
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		
		let diffWidth = self.frame.width < (375/2) ? self.frame.width * 0.2 : self.frame.width * 0.1
		var rightInset = UIEdgeInsets()
		rightInset.top = PaddingTop
		rightInset.bottom = PaddingBottom
		rightInset.right = PaddingRight
		rightInset.left = self.frame.width - diffWidth
		
		return bounds.inset(by: rightInset)
	}
}
