//
//  Webservices.swift
//  BodyFrame
//
//  Created by Matrix Mini on 06/11/19.
//  Copyright © 2019 Matrix Mini. All rights reserved.
//

import UIKit
//import Alamofire

struct AppURL {
	static let BASE_URL = ""
	
}

//Webservices
enum Result_Status {
	case Success
	case Failure
	case Unauthorized
	case ServerError
	case InternetFailure
}


class Webservices: NSObject {
	
	static let shared = Webservices()
	
	class var isReachable: Bool {
		return NetworkReachabilityManager()!.isReachable
	}
	
	//MARK:-
	//MARK:-
	//MARK:- GET REQUEST
	func GET_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Result_Status,_ header: NSDictionary,_ response: [String: Any]) -> Void) {
		
		let urlPath:URL = URL(string: path)!
		
		var request = URLRequest(url: urlPath)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		print("GET Method")
		print("Path : ", path)
		
		if headers.count > 0 {
			request.setValue(headers["access-token"], forHTTPHeaderField: "access-token")
			request.setValue(headers["expiry"], forHTTPHeaderField: "expiry")
			request.setValue(headers["token-type"], forHTTPHeaderField: "token-type")
			request.setValue(headers["uid"], forHTTPHeaderField: "uid")
			request.setValue(headers["client"], forHTTPHeaderField: "client")
			print("GET REQUEST HEADERS: ", headers)
		}
		
		if param.count > 0 {
			let data = try! JSONSerialization.data(withJSONObject: param, options: [])
			
			let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
			if let json = json {
				print("GET REQUEST JSON: ", json)
			}
			request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
		}
		
		Alamofire.request(request).responseJSON { (response) in
			
			if response.result.value != nil {
				print("GET Request Response : ", response)
				print("GET Request Headers : ", response.response!.allHeaderFields as NSDictionary)
				
				let statusCode = response.response!.statusCode
				let ResponseHeaders: NSDictionary = response.response!.allHeaderFields as NSDictionary
				guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
					return
				}
				
				if statusCode == 200 {
					print("Request Status 200: Success")
					completion(.Success, ResponseHeaders, json)
				}
				else if statusCode == 401 {
					print("Request Status 401: Unauthorized")
					completion(.Unauthorized, ResponseHeaders, json)
				}
				else if statusCode == 500 {
					print("Request Status 500: Server Error")
					completion(.ServerError, ResponseHeaders, json)
				}
				else {
					print("Request Status Not 200: Not Success")
					completion(.Failure, ResponseHeaders, json)
				}
			}
			else {
				let emptyHeader = NSDictionary()
				completion(.ServerError, emptyHeader, ["error": "Something went wrong. Please try again"])
			}
			
		}
	}
	
	
	
	
	//MARK:-
	//MARK:-
	//MARK:- POST REQUEST
	func POST_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Result_Status,_ header: NSDictionary,_ response: [String: Any]) -> Void) {
		
		let urlPath:URL = URL(string: path)!
		
		var request = URLRequest(url: urlPath)
		request.httpMethod = "POST"
		
		print("POST Method")
		print("Path : ", path)
		
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		if headers.count > 0 {
			request.setValue(headers["access-token"], forHTTPHeaderField: "access-token")
			request.setValue(headers["expiry"], forHTTPHeaderField: "expiry")
			request.setValue(headers["token-type"], forHTTPHeaderField: "token-type")
			request.setValue(headers["uid"], forHTTPHeaderField: "uid")
			request.setValue(headers["client"], forHTTPHeaderField: "client")
			print("POST REQUEST HEADERS: ", headers)
		}
		
		let data = try! JSONSerialization.data(withJSONObject: param, options: [] /*JSONSerialization.WritingOptions.prettyPrinted*/)
		
		let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
		if let json = json {
			print("POST REQUEST JSON : ", json)
		}
		request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
		
		Alamofire.request(request).responseJSON { (response) in
			
			if response.result.value != nil {
				print("POST Request Response : ", response)
				print("POST Request Headers : ", response.response!.allHeaderFields as NSDictionary)
				
				let statusCode = response.response!.statusCode
				let ResponseHeaders: NSDictionary = response.response!.allHeaderFields as NSDictionary
				
				guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
					return
				}
				
				if statusCode == 200 {
					print("Request Status 200: Success")
					completion(.Success, ResponseHeaders, json)
				}
				else if statusCode == 201 {
					print("Request Status 201: Signup Success")
					completion(.Success, ResponseHeaders, json)
				}
				else if statusCode == 401 {
					print("Request Status 401: Unauthorized")
					completion(.Unauthorized, ResponseHeaders, json)
				}
				else if statusCode == 500 {
					print("Request Status 500: Server Error")
					completion(.ServerError, ResponseHeaders, json)
				}
				else {
					print("Request Status \(statusCode): Not Success")
					completion(.Failure, ResponseHeaders, json)
				}
			}
			else {
				let emptyHeader = NSDictionary()
				completion(.ServerError, emptyHeader, ["error": "Something went wrong. Please try again"])
			}
			
		}
	}
	
	
	
	
	//MARK:-
	//MARK:-
	//MARK:- PATCH REQUEST
	func PATCH_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Result_Status,_ header: NSDictionary,_ response: [String: Any]) -> Void) {
		
		let urlPath:URL = URL(string: path)!
		
		var request = URLRequest(url: urlPath)
		request.httpMethod = "PATCH"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		if headers.count > 0 {
			request.setValue(headers["access-token"], forHTTPHeaderField: "access-token")
			request.setValue(headers["expiry"], forHTTPHeaderField: "expiry")
			request.setValue(headers["token-type"], forHTTPHeaderField: "token-type")
			request.setValue(headers["uid"], forHTTPHeaderField: "uid")
			request.setValue(headers["client"], forHTTPHeaderField: "client")
		}
		
		print("PATCH REQUEST HEADERS: ", headers)
		if param.count > 0 {
			let data = try! JSONSerialization.data(withJSONObject: param, options: [])
			
			let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
			if let json = json {
				print("PATCH REQUEST JSON: ",json)
			}
			request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
		}
		
		
		Alamofire.request(request).responseJSON { (response) in
			
			if response.result.value != nil {
				print("PATCH Request Response : ", response)
				print("PATCH Response Headers : ", response.response! )
				
				let statusCode = response.response!.statusCode
				let ResponseHeaders: NSDictionary = response.response!.allHeaderFields as NSDictionary
				
				guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
					return
				}
				
				if statusCode == 200 {
					print("Request Status 200: Success")
					completion(.Success, ResponseHeaders, json)
				}
				else if statusCode == 401 {
					print("Request Status 401: Unauthorized")
					completion(.Unauthorized, ResponseHeaders, json)
				}
				else if statusCode == 500 {
					print("Request Status 500: Internal Server Error")
					completion(.ServerError, ResponseHeaders, json)
				}
				else {
					print("Request Status \(statusCode): Failure")
					completion(.Failure, ResponseHeaders, json)
				}
			}
			else {
				let emptyHeader = NSDictionary()
				completion(.ServerError, emptyHeader, ["error": "Something went wrong. Please try again"])
			}
		}
	}
	
	
	
	
	//MARK:-
	//MARK:-
	//MARK:- DELETE REQUEST
	func DELETE_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Bool,_ header: NSDictionary,_ response: [String: Any]) -> Void) {
		
		let urlPath:URL = URL(string: path)!
		
		var request = URLRequest(url: urlPath)
		request.httpMethod = "DELETE"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		if headers.count > 0 {
			request.setValue(headers["access-token"], forHTTPHeaderField: "access-token")
			request.setValue(headers["expiry"], forHTTPHeaderField: "expiry")
			request.setValue(headers["token-type"], forHTTPHeaderField: "token-type")
			request.setValue(headers["uid"], forHTTPHeaderField: "uid")
			request.setValue(headers["client"], forHTTPHeaderField: "client")
		}
		
		print("DELETE REQUEST HEADERS: ", headers)
		if param.count > 0 {
			let data = try! JSONSerialization.data(withJSONObject: param, options: [])
			
			let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
			if let json = json {
				print("DELETE REQUEST JSON: ",json)
			}
			request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
		}
		
		Alamofire.request(request).responseJSON { (response) in
			
			if response.result.value != nil {
				print("DELETE Request Response : ", response)
				print("DELETE Response Headers : ", response.response! )
				
				let statusCode = response.response!.statusCode
				let ResponseHeaders: NSDictionary = response.response!.allHeaderFields as NSDictionary
				
				guard let data = response.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
					return
				}
				
				if statusCode == 200 {
					print("Request Status 200: Success")
					completion(true, ResponseHeaders, json)
				}
				else {
					print("Request Status \(statusCode): Not Success")
					completion(false, ResponseHeaders, json)
				}
			}
			else {
				let emptyHeader = NSDictionary()
				completion(false, emptyHeader, ["error": "Something went wrong. Please try again"])
			}
		}
	}
	
}

