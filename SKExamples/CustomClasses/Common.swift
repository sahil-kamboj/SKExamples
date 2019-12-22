//
//  Common.swift
//  SewSewYou
//
//  Created by Matrix Mini on 23/10/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import UIKit
import Photos
import Foundation
import QuartzCore
import AVFoundation

let EmptyAtt = NSAttributedString()

let MAINSCREEN_WIDTH = UIScreen.main.bounds.width
let MAINSCREEN_HEIGHT = UIScreen.main.bounds.height

class Common: NSObject {

}

enum LastController {
	case none
	case Login
	case Signup
}
var isLastController = LastController.none

struct AppColor {
	static let AppFadeBlack = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
	static let AppAquaSelection = UIColor(red: 0/255.0, green: 191/255.0, blue: 196/255.0, alpha: 1.0)
	static let AppGreenSelected = UIColor(red: 0/255.0, green: 117/255.0, blue: 121/255.0, alpha: 1.0)
	static let AppGreenHighlighted = UIColor(red: 0/255.0, green: 56/255.0, blue: 57/255.0, alpha: 1.0)
	static let AppTextGray = UIColor(red: 123/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1.0)
	static let AppTextGrayInterface = UIColor(red: 142/255.0, green: 147/255.0, blue: 156/255.0, alpha: 1.0)
	static let AppButtonGreen = UIColor(red: 0/255.0, green: 194/255.0, blue: 54/255.0, alpha: 1.0)
	
}

extension UIScrollView {
    func updateContentViewSize() {
        var newHeight: CGFloat = 0
        for view in subviews {
            let ref = view.frame.origin.y + view.frame.height
            if ref > newHeight {
                newHeight = ref
            }
        }
        let oldSize = contentSize
        let newSize = CGSize(width: oldSize.width, height: newHeight + 100)
        contentSize = newSize
    }
}

//MARK:- NSObject
extension NSObject {
	
	func textFieldSpacing (textF: UITextField) {
		let space = UIScreen.main.bounds.width * 0.12
		let attributedString = NSMutableAttributedString(string: textF.text!)
		print("Attributed String : ", attributedString)
		
		if textF.text!.count < 4 {
			attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(space), range: NSRange(location: 0, length: attributedString.length))
		}
		else if textF.text!.count == 4 {
			attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(space), range: NSRange(location: 0, length: attributedString.length - 1))
		}
		else {
			attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(space), range: NSRange(location: 0, length: attributedString.length - 1))
		}
		textF.attributedText = attributedString
	}
	
	func characterSpacing (text: String, or AttributedText: NSAttributedString, WithSpace: CGFloat) -> NSAttributedString {
		
		let attributedString = (text == "") ? NSMutableAttributedString(attributedString: AttributedText) : NSMutableAttributedString(string: text)
		attributedString.addAttribute(NSAttributedString.Key.kern, value: WithSpace, range: NSRange(location: 0, length: attributedString.length - 1))
		return attributedString
	}
	
	func wordSpacing (text: String, or AttributedText: NSAttributedString, WithSpace: CGFloat, andLineDistance: CGFloat, textAlign: NSTextAlignment) -> NSAttributedString {
		let attributedString = (text == "") ? NSMutableAttributedString(attributedString: AttributedText) : NSMutableAttributedString(string: text)
		attributedString.addAttribute(NSAttributedString.Key.kern, value: WithSpace, range: NSRange(location: 0, length: attributedString.length - 1))
		let paraStyle = NSMutableParagraphStyle()
		paraStyle.lineSpacing = WithSpace
		paraStyle.alignment = textAlign
		attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraStyle, range: NSRange(location: 0, length: attributedString.length - 1))
		return attributedString
	}
	
	func twoFonts() {
		
		let textLayer = UILabel(frame: CGRect(x: 30, y: 425, width: 315, height: 24))
		textLayer.lineBreakMode = .byWordWrapping
		textLayer.numberOfLines = 0
		textLayer.textColor = UIColor(red:0.14, green:0.65, blue:0.68, alpha:1)
		textLayer.textAlignment = .center
		let textContent = "Don’t have an account? Sign Up"
		let textString = NSMutableAttributedString(string: textContent, attributes: [
			NSAttributedString.Key.font: UIFont(name: "Muli-SemiBold", size: 14)!
		])
		let textRange = NSRange(location: 0, length: textString.length)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 1.71
		textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
		textString.addAttribute(NSAttributedString.Key.kern, value: 0.07, range: textRange)
		textLayer.attributedText = textString
		textLayer.sizeToFit()
//		self.view.addSubview(textLayer)
		
	}
	
	func differentFonts(textOne: String, textTwo: String/*, fontOne: [NSAttributedString.Key: Any], fontTwo: [NSAttributedString.Key: Any]*/) -> NSAttributedString {
		
		let attributedText = NSMutableAttributedString(string: textOne, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
		attributedText.append(NSAttributedString(string: textTwo, attributes: [ NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .semibold)]))
		
		return attributedText
	}
	
	func isValidPhoneNumber (_ textField: UITextField, limit: Int) -> Bool {
		if textField.text!.count == limit {
			return true
		}
		else {
			return false
		}
	}
	
	//MARK:- Phone Numbe Formats Settings
	func formatNumber_Remove(text : String) -> String { // Remove phone format elements other than numbers
		var mobileNumber: String = text
		
		mobileNumber = mobileNumber.replacingOccurrences(of: "(", with: "")
		mobileNumber = mobileNumber.replacingOccurrences(of: ")", with: "")
		mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
		mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
		mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
		
		return mobileNumber
	}
	
	func formatNumber_RemoveNonNumbers(text: String) -> String { // Remove all elements other than number
		
		return text.replacingOccurrences( of:"[^0-9]", with: "", options: .regularExpression)
	}
	
	//MARK:- Currently Using for Phone Number
	func formatNumber_PhoneNumber(number: String) -> String {//FormatNumber_PhoneNumber
		let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		let mask = "(XXX) XXX-XXXXXX"

		var result = ""
		var index = cleanPhoneNumber.startIndex
		for ch in mask where index < cleanPhoneNumber.endIndex {
			if ch == "X" {
				result.append(cleanPhoneNumber[index])
				index = cleanPhoneNumber.index(after: index)
			} else {
				result.append(ch)
			}
		}
		return result
	}
	
	//MARK:- Currently Using for Credit Cards
	func formatNumber_CreditCard(number: String) -> String {
		let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		let mask = "XXXX XXXX XXXX XXXX"

		var result = ""
		var index = cleanNumber.startIndex
		for ch in mask where index < cleanNumber.endIndex {
			if ch == "X" {
				result.append(cleanNumber[index])
				index = cleanNumber.index(after: index)
			} else {
				result.append(ch)
			}
		}
		return result
	}
	
	//MARK:- Image and Base64 String
	func convertImageToBase64String (img: UIImage) -> String {
		return "data:image/jpg;base64," + (img.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? "")
	}
	
	func convertBase64StringToImage (imageBase64String:String) -> UIImage {
		let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
		let image = UIImage(data: imageData!)
		return image!
	}
	
}

//MARK:- UIViewController
extension UIViewController {
	
	//MARK:- Photo Library Authorization
	func checkPhotoLibraryAutorization (completion: @escaping (_ response: PermissionCases,_ message: String) -> Void) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let status = PHPhotoLibrary.authorizationStatus()
			
			switch status {
			case .authorized:
				print("Photo Library Access is Authorized")
				completion(PermissionCases.Authorized, PermissionCases.Authorized.rawValue)
				break
				
			case .denied:
				print("Photo Library Access is Denied")
				completion(PermissionCases.Denied, PermissionCases.Denied.rawValue)
				break
				
			case .notDetermined:
				var newStatusReturn = PermissionCases.AskPermission
				PHPhotoLibrary.requestAuthorization { (newStatus) in
					if newStatus == PHAuthorizationStatus.authorized {
						newStatusReturn = PermissionCases.Authorized
						completion(newStatusReturn, PermissionCases.Authorized.rawValue)
					}
					else if  newStatus == PHAuthorizationStatus.denied {
						newStatusReturn = PermissionCases.Denied
						completion(newStatusReturn, PermissionCases.Denied.rawValue)
					}
				}
				completion(newStatusReturn, PermissionCases.AskPermission.rawValue)
				break
				
			case .restricted:
				print("Photo Library Access is restricted")
				completion(PermissionCases.Restricted, PermissionCases.Restricted.rawValue)
				break
				
			@unknown default:
				print("Unknown Default")
				break
			}
		}
		else {
			showAlertWithMessage(title: "Alert", message: "Photo Library is not Available")
		}
	}
	
	//MARK:- Camera Authorization
	func checkCameraAutorization (completion: @escaping (_ response: Bool,_ message: String) -> Void) {
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			
			let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
			
			switch status {
			case .authorized:
				print("Camera Access is authorized")
				completion(true, PermissionCases.Authorized.rawValue)
				break
				
			case .denied:
				print("Camera Access is denied")
				completion(false, PermissionCases.Denied.rawValue)
				break
				
			case .notDetermined:
				var newStatusReturn = Bool()
				AVCaptureDevice.requestAccess(for: AVMediaType.video) { (newStatus) in
					
					guard newStatus == true else { return }
					if newStatus == true {
						print("Camera Access is granted")
						newStatusReturn = true
						completion(newStatusReturn, PermissionCases.Authorized.rawValue)
					}
					else {
						print("Camera Access is denied")
						newStatusReturn = false
						completion(newStatusReturn, PermissionCases.Denied.rawValue)
					}
				}
				completion(newStatusReturn, PermissionCases.AskPermission.rawValue)
				break
				
			case .restricted:
				print("Camera Access is restricted")
				completion(false, PermissionCases.Restricted.rawValue)
				break
			
			@unknown default:
				print("Unknown Default")
				break
			}
		}
		else {
			showAlertWithMessage(title: "Alert", message: "Camera is not available on this device")
		}
	}
	
	//MARK:- Calendar Date Setting
	
	func changeDateToString(input: Date) -> String {
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"

		let date: Date? = input
		print(dateFormatter.string(from: date!))
		return dateFormatter.string(from: date!)
	}
	
	func getCalendarDates () -> (Date, Date) {
		let calendar = Calendar(identifier: .gregorian)

		let currentDate = Date()
		var components = DateComponents()
		components.calendar = calendar

		components.year = -16
		components.month = 12
		let maxDate = calendar.date(byAdding: components, to: currentDate)!

		components.year = -150
		let minDate = calendar.date(byAdding: components, to: currentDate)!
		return (minDate, maxDate)
	}
	
	func setLeftImage(TF: UITextField, Image: String) {
		
		let toggleButton = UIButton(frame: CGRect(x: 0, y: 0, width: TF.bounds.width * 0.1, height: TF.bounds.height * 0.8))
		toggleButton.setImage(UIImage(named: Image), for: .normal)
		toggleButton.imageView?.contentMode = .scaleAspectFit
		
		TF.leftViewMode = .always
		TF.leftView = toggleButton
	}
	
	func popBackMultiple(_ nb: Int) {
		let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        guard viewControllers.count < nb else {
			self.navigationController!.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
            return
        }
    }
	
	func popToControllerIndex(_ index: Int) {
		let viewControllers: [UIViewController] = self.navigationController!.viewControllers
		self.navigationController!.popToViewController(viewControllers[index], animated: true)
	}
	
	func pushViewController(_ viewId: String, animated: Bool) {
		let Instace = self.storyboard!.instantiateViewController(withIdentifier: viewId)
		self.navigationController?.pushViewController(Instace, animated: animated)
	}
	
	func presentViewController(_ viewId: String) {
		let Instace = self.storyboard!.instantiateViewController(withIdentifier: viewId)
		self.present(Instace, animated: true, completion: nil)
	}
	
	func popViewController(_ animate: Bool) {
		self.navigationController?.popViewController(animated: animate)
	}
	
	func showAlertWithMessage(title: String, message : String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let posAction = UIAlertAction(title: "OK", style: .default) { (action) in
			
		}
		alertController.addAction(posAction)
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
	
	func showAlert(title: String, message : String, posTitle: String, negTitle : String, completion: @escaping (Bool) -> ()) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		if posTitle != "" {
			let posAction = UIAlertAction(title: posTitle, style: .default) { (action) in
				completion(true)
			}
			alertController.addAction(posAction)
		}
		
		if negTitle != "" {
			let negAction = UIAlertAction(title: negTitle, style: .default) { (action) in
				completion(false)
			}
			alertController.addAction(negAction)
		}
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
	
	func showActionSheet(title: String, message: String, options: Array<String>, completion: @escaping(_ optionType: String) -> Void) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		
		for i in options {
			let action = UIAlertAction(title: i, style: .default) { (optionAction) in
				completion(i)
			}
			alertController.addAction(action)
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
			
		}
		alertController.addAction(cancel)
		
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
	
}

