//
//  PredefinedFunctions.swift
//  Aiungo
//
//  Created by Rajeev Lochan Ranga on 13/06/19.
//  Copyright © 2019 Sahil_iOS. All rights reserved.
//

import UIKit
import Photos
import Foundation
import QuartzCore


let MAINSCREEN_WIDTH = UIScreen.main.bounds.size.width
let MAINSCREEN_HEIGHT = UIScreen.main.bounds.size.height

let USDF = UserDefaults.standard

enum UIUserInterfaceIdiom : Int {
	case unspecified
	case phone
	case pad
}
let CURRENT_DEVICE = UIDevice.current.userInterfaceIdiom




class PredefinedFunctions: NSObject {

}

extension NSObject {
	
	func selectTheNib (_ Name : String) -> UINib {
		return UINib.init(nibName: Name, bundle: nil)
	}
	
	var className: String {
		return String(describing: type(of: self)).components(separatedBy: ".").last!
	}
	
	func setShadowFor(_ view: UIView, withBorder value: CGFloat) {
		
		view.layer.borderColor = UIColor.lightGray.cgColor
		view.layer.borderWidth = value
		//	view.layer.cornerRadius = 10.0f;
		view.layer.shadowPath = UIBezierPath(rect: CGRect(x: view.bounds.origin.x + 3, y: view.bounds.origin.y + 3, width: view.bounds.size.width, height: view.bounds.size.height)).cgPath
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOpacity = 0.6
		view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
		view.layer.shadowRadius = 5.0
		view.layer.masksToBounds = false
	}
	
	func PushViewController (toVC: String, mine: UIViewController) {
		let me = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: toVC) as UIViewController
		
		mine.navigationController?.pushViewController(me, animated: true)
	}
	
	func PopViewController (from : UIViewController) {
		from.navigationController?.popViewController(animated: true)
	}
	
	func PopMultipleViewControllers(_ nb: Int, from: UIViewController) {
		if let viewControllers: [UIViewController] = from.navigationController?.viewControllers {
			guard viewControllers.count < nb else {
				from.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
				return
			}
		}
	}
	
	func CornerRadius (_ input : UIView, value : CGFloat, color : UIColor) {
		input.layer.cornerRadius = input.frame.size.height * value
		input.layer.borderWidth = 1.0
		input.layer.borderColor = color.cgColor
		input.layer.masksToBounds = true
	}
	
	//Language Selection
	func pickLanguage (_ key:String) -> String {
		return NSLocalizedString(key, comment: "Cancel")
	}
	
	//MARK:- Image Encoding to Base64
	func base64EncodeImage(_ image: UIImage) -> String {
		var imagedata = image.pngData()
		
		// Resize the image if it exceeds the 2MB API limit
		if ((imagedata?.count)! > 2097152) {
			let oldSize: CGSize = image.size
			let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
			imagedata = resizeImage(newSize, image: image)
		}
		
		return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
	}
	
	func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
		UIGraphicsBeginImageContext(imageSize)
		image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		let resizedImage = newImage!.pngData()
		UIGraphicsEndImageContext()
		return resizedImage!
	}
	
	//MARK:- Action Sheet
	func showActionSheet(_ title: String?, message: String?, optionsList: /*[Bool : String]*/[String]?, view: UIView, completion: @escaping (_ response: String?) -> Void) {
		
		let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		
		for (/*active,*/string) in optionsList!  {
			let option = UIAlertAction(title: string, style: .default, handler: { action in
				completion(string)
			})
			//			option.isEnabled = active
			actionSheet.addAction(option)
		}
		
		let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
			completion("Cancel")
		})
		actionSheet.addAction(cancelOption)
		
		if let popoverController = actionSheet.popoverPresentationController {
			popoverController.sourceView = view
			popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
			popoverController.permittedArrowDirections = []
		}
		UIApplication.shared.keyWindow?.rootViewController?.present(actionSheet, animated: true)
	}
	
	// MARK: - Alert Controller
	func showAlert(withTitle title: String?, message: String?, okButton okTitle: String?, cancelButton cancelTitle: String?, completion: @escaping (_ response: Bool) -> Void) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		if !(okTitle?.isEqual("") ?? false) {
			let ok = UIAlertAction(title: okTitle, style: .default, handler: { action in
				completion(true)
			})
			alertController.addAction(ok)
		}
		
		if !(cancelTitle?.isEqual("") ?? false) {
			let cancel = UIAlertAction(title: cancelTitle, style: .default, handler: { action in
				completion(false)
			})
			alertController.addAction(cancel)
		}
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
	}
	
	//MARK:- Photo Library Authorization
	func checkPhotoLibraryAutorization (completion: @escaping (_ response: Bool) -> Void) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let status = PHPhotoLibrary.authorizationStatus()
			
			switch status {
			case .authorized:
				print("Photo Library Access is Authorized")
				completion(true)
				break
				
			case .denied:
				print("Photo Library Access is Denied")
				completion(false)
				break
				
			case .notDetermined:
				var newStatusReturn = Bool()
				PHPhotoLibrary.requestAuthorization { (newStatus) in
					if newStatus == PHAuthorizationStatus.authorized {
						newStatusReturn = true
					}
					else {
						newStatusReturn = false
					}
				}
				completion(newStatusReturn)
				break
				
			case .restricted:
				print("Photo Library Access is restricted")
				completion(false)
				break
			@unknown default:
				print("Unknown Default")
				break
			}
		}
		else {
			showAlert(withTitle: "Alert!", message: "Photo Library is not available", okButton: "OK", cancelButton: "") { (response) in
				
			}
		}
	}
	
	//MARK:- Camera Authorization
	func checkCameraAutorization (completion: @escaping (_ response: Bool) -> Void) {
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
			
			switch status {
			case .authorized:
				print("Camera Access is authorized")
				completion(true)
				break
				
			case .denied:
				print("Camera Access is denied")
				completion(false)
				break
				
			case .notDetermined:
				var newStatusReturn = Bool()
				AVCaptureDevice.requestAccess(for: AVMediaType.video) { (newStatus) in
					if newStatus == true {
						print("Camera Access is granted")
						newStatusReturn = true
					}
					else {
						print("Camera Access is denied")
						newStatusReturn = false
					}
				}
				completion(newStatusReturn)
				break
				
			case .restricted:
				print("Camera Access is restricted")
				completion(false)
				break
			
			@unknown default:
				print("Unknown Default")
				break
			}
		}
		else {
			showAlert(withTitle: "Alert!", message: "Camera is not available on this device"/*pickLanguage("Camera not found")*/, okButton: "OK", cancelButton: "") { (response) in
				
			}
		}
	}
}


class ActionButton : UIButton {
	
	override func awakeFromNib() {
		
		super.awakeFromNib()
		
	}
	
	@IBInspectable
	public var screenFont : Bool = false {
		didSet {
			if screenFont {
				let pSize = (self.titleLabel?.font.pointSize)!/568//self.font.pointSize/667
				self.titleLabel?.font = (self.titleLabel?.font.withSize(MAINSCREEN_HEIGHT * pSize))!
			}
		}
	}
	
	@IBInspectable
	public var ApplyBorder : Bool = false {
		didSet {
			if ApplyBorder {
				self.layer.borderWidth = 0.5
				self.layer.borderColor = UIColor.lightGray.cgColor
			}
		}
	}
	
	@IBInspectable
	public var ApplyInsets : Bool = false {
		
		didSet {
			if ApplyInsets {
				self.contentEdgeInsets = UIEdgeInsets(top: 0, left: MAINSCREEN_WIDTH * 0.06, bottom: 0, right: 0)
			}
		}
	}
	
	@IBInspectable
	public var ApplyImageInsets : Bool = false {
		
		didSet {
			if ApplyImageInsets {
				self.imageView?.contentMode = .scaleAspectFit
				self.contentEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.size.width * 0.2, bottom: 0, right: self.frame.size.width * 0.2)
			}
		}
	}
	
}

//MARK: - Label Class
class TitleLabel: UILabel {
	
	override var text: String? {
		didSet {
			if var text = text {
				text = pickLanguage(text)
			}
		}
	}
	
	override func awakeFromNib() {
		
		super.awakeFromNib()
		self.text = self.pickLanguage(self.text!)
	}
	
	@IBInspectable
	public var masksBounds : Bool = false {
		didSet {
			self.layer.masksToBounds = self.masksBounds
		}
	}
	
	@IBInspectable
	public var sizeFit : Bool = false {
		didSet {
			sizeFit ? self.sizeToFit() : nil
		}
	}
	
	@IBInspectable
	public var screenFont : Bool = false {
		didSet {
			if screenFont {
				let pSize = self.font.pointSize/667
				self.font = self.font.withSize(MAINSCREEN_HEIGHT * pSize)
			}
		}
	}
}

class IndentLabel: UILabel {
	
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
		super.drawText(in: rect.inset(by: insets))
	}
}



//MARK: - Text Field Class
class TextField: UITextField {
	
	
	let padding = UIEdgeInsets(top: 0, left: MAINSCREEN_WIDTH * 0.05, bottom: 0, right: 20)
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	override open func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
	
	override open func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.inset(by: padding)
	}
}

class TextView : UITextView {
	
	let pad = MAINSCREEN_WIDTH * 0.025
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.textContainerInset = UIEdgeInsets(top: pad, left: pad, bottom: 5, right: pad)
	}
}
