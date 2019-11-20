//
//  BaseController.swift
//  BodyFrame
//
//  Created by Sahil Kamboj on 02/11/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView


let USDF = UserDefaults.standard

enum AttachmentType: String{
 case camera, video, photoLibrary
}

enum PermissionCases: String, CaseIterable {
	case Authorized = "Authorized"
	case Denied = "Denied"
	case AskPermission = "Ask Permission"
	case Restricted = "Restricted"
}

class BaseController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		TapGesture()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func StartAnimation() {
		self.startAnimating(CGSize(width: MAINSCREEN_WIDTH * 0.2, height: MAINSCREEN_WIDTH * 0.2), message: "", messageFont: nil, type: .circleStrokeSpin, color: .white, padding: 0.0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: .clear, textColor: .white, fadeInAnimation: .none)
	}
	
	func StopAnimation() {
		self.stopAnimating()
	}
	
	@IBAction func action_BackButton() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func TapGesture() {
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		
		self.view.addGestureRecognizer(tap)
	}
	
	func CancelEditing(inView: UIView) {
		for view in inView.subviews {
			if view .isKind(of: UITextField.self) {
				view.resignFirstResponder()
			}
		}
	}
	
	func selectUploadMedia() {
		
		self.showActionSheet(title: "Select Profile Picture", message: "Please select image from following", options: [PictureOption.Camera.rawValue, PictureOption.Gallery.rawValue]) { (response) in
						
						switch response {
							case PictureOption.Camera.rawValue:
		//						imagePicker.sourceType = .camera
								self.openCamera()
								break
							
							case PictureOption.Gallery.rawValue:
		//						imagePicker.sourceType = .photoLibrary
								self.openPhotoGallery()
								break
							
							default:
								break
						}
						print(response)
					}
		
	}
	
	func openCamera() {
		self.checkCameraAutorization { (action, message)  in
			if action {
				DispatchQueue.main.async {
					let imagePicker = UIImagePickerController()
					imagePicker.delegate = self
					imagePicker.allowsEditing = true
					imagePicker.sourceType = .camera
					self.present(imagePicker, animated: true, completion: nil)
				}
			}
			else {
				print("Camera Check Else")
			}
		}
	}
	
	func openPhotoGallery() {
		self.checkPhotoLibraryAutorization { (action, message) in
			if action == .Authorized {
				DispatchQueue.main.async {
					let imagePicker = UIImagePickerController()
					imagePicker.delegate = self
					imagePicker.allowsEditing = true
					imagePicker.sourceType = .photoLibrary
					self.present(imagePicker, animated: true, completion: nil)
				}
			}
			else if action == .AskPermission {
				
				print("Gallery Check Else")
			}
		}
	}

}
