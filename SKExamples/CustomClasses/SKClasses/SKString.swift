//
//  SKString.swift
//  BodyFrame
//
//  Created by Sahil Kamboj on 22/12/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import Foundation

//MARK:- String
extension String {
	
	//MARK:- Valid Email
	var isValidEmail: Bool {
		let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
		return testEmail.evaluate(with: self)
	}
	//MARK:- Valid Phone
	var isValidPhone: Bool {
		let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
		let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
		return testPhone.evaluate(with: self)
	}
	//MARK:- Valid Name
	var isName: Bool {
		let regularExpressionForName = "[A-Za-z]+(?:\\s[A-Za-z]+)*"
		let testName = NSPredicate(format:"SELF MATCHES %@", regularExpressionForName)
		return testName.evaluate(with: self)
	}
	
	func trim() -> String
	{
		return self.trimmingCharacters(in: CharacterSet.whitespaces)
	}
	
	func stringByTrimingWhitespace() -> String {
		let squashed = replacingOccurrences(of: "[ ]+",
											with: " ",
											options: .regularExpression)
		return squashed.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	// formatting text for currency textField
	func currencyInputFormatting() -> String {
		
		var number: NSNumber!
		let formatter = NumberFormatter()
		formatter.numberStyle = .currencyAccounting
		formatter.currencySymbol = "$"
		formatter.maximumFractionDigits = 2
		formatter.minimumFractionDigits = 0
		
		var amountWithPrefix = self
		
		// remove from String: "$", ".", ","
		let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
		amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
		
		let double = (amountWithPrefix as NSString).doubleValue
		number = NSNumber(value: (double / 100))
		
		// if first number is 0 or all numbers were deleted
		guard number != 0 as NSNumber else {
			return ""
		}
		
		return formatter.string(from: number)!
	}
}
