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
	
	static let URL_LOGIN = "\(BASE_URL)login"
	static let URL_SIGNUP = "\(BASE_URL)sign_up"
	static let URL_FORFOT_PASSWORD = "\(BASE_URL)forgot_password"
	static let URL_UPDATE_FORGOT_PASSWORD = "\(BASE_URL)update_forgot_password"
	static let URL_UPDATE_PASSWORD = "\(BASE_URL)update_password"
	
	static let URL_UPDATEPROFILE = "\(BASE_URL)update_profile"
	static let URL_GETPROFILE = "\(BASE_URL)user"
	
	static let URL_GET_CLIENTS = "\(BASE_URL)trainer/clients?date="
	static let URL_GET_CLIENTDETAILS = "\(BASE_URL)trainer/clients/{id}?date={date}"
	
	static let URL_ASSIGNWORKOUT = "\(BASE_URL)trainer/workouts"
	static let URL_UPDATE_WORKOUT = "\(BASE_URL)"
	static let URL_DELETE_WORKOUT = "\(BASE_URL)"
	
	static let URL_ASSIGNMEAL = "\(BASE_URL)trainer/meals"
	static let URL_UPDATE_MEAL = "\(BASE_URL)"
	static let URL_DELETE_MEAL = "\(BASE_URL)"
	
	static let URL_CATEGORIES_WORKOUT = "\(BASE_URL)workout_categories"
	
	static let URL_CATEGORIES_MEAL = "\(BASE_URL)meal_categories"
}

class Webservices: NSObject {
	
	static let shared = Webservices()
	
	//MARK:-
	//MARK:-
	//MARK:- GET REQUEST
	func GET_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Bool,_ response: DataResponse<Any>) -> Void) {
		
		let urlPath:URL = URL(string: path)!
		
		var request = URLRequest(url: urlPath)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		if headers.count > 0 {
			request.setValue(headers["access-token"], forHTTPHeaderField: "access-token")
			request.setValue(headers["expiry"], forHTTPHeaderField: "expiry")
			request.setValue(headers["token-type"], forHTTPHeaderField: "token-type")
			request.setValue(headers["uid"], forHTTPHeaderField: "uid")
			request.setValue(headers["client"], forHTTPHeaderField: "client")
		}
		print("GET REQUEST HEADERS: ", headers)
		if param.count > 0 {
			let data = try! JSONSerialization.data(withJSONObject: param, options: [])
			
			let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
			if let json = json {
				print("GET REQUEST JSON: ", json)
			}
			request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
		}
		/*
		Alamofire.request(request).responseJSON { (response) in
			print("GET Request Response : ", response)
			print("GET Request Headers : ", response.response!.statusCode )
			
			let statusCode = response.response!.statusCode
			
			if statusCode == 200 {
				print("Request Status 200: Success")
				completion(true, response)
			}
			else {
				print("Request Status Not 200: Not Success")
				completion(false, response)
			}
		}*/
	}
	
	//MARK:- Request GET PROFILE
	func Request_GetProfile(completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		GET_Request(path: AppURL.URL_GETPROFILE, headers: LoginHeaderData.shared.Req_Headers(), param: [:]) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Get Profile Response : ", json)
			
			if ResponseStatus {
				let mainData = json["data"]
				print("Main Data : ", mainData as! [String: Any])
				completion(true, mainData as! [String : Any])
			}
			else {
				let errorMessage = json["error"] as! String
				completion(false, ["error": errorMessage])
			}
		}
	}
	
	//MARK:- Request GET CLIENTS
	func Request_GetClients(completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		var headers: [String: String] = LoginHeaderData.shared.Req_Headers()
//		let todayDate: String = ""
		headers["date"] = "2019-11-15"
		GET_Request(path: AppURL.URL_GET_CLIENTS, headers: headers, param: [:]) { (Status, Data) in
			
			guard let data = Data.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = Data.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Get Clients Response : ", json)
			
			if Status {
				let mainData: NSArray = json["data"] as! NSArray
				print("Client Data : ", mainData)
				let sendData: [String: Any] = ["data" : mainData]
				completion(true, sendData)
			}
			else { // Get Clients Response :  ["error": Internal Server Error, "status": 500]
				let errorMessage = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0]])
			}
		}
	}
	
	
	//MARK:- Request GET CLIENT DETAILS
	func Request_GetClientDetails(date: String, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		var headers: [String: String] = LoginHeaderData.shared.Req_Headers()
		//		let todayDate: String = ""
//		headers["date"] = date
		headers["id"] = ClientAttributes.shared.Client_Id
		let path1 = AppURL.URL_GET_CLIENTDETAILS.replacingOccurrences(of: "{id}", with: ClientAttributes.shared.Client_Id!)
		let path2 = path1.replacingOccurrences(of: "{date}", with: date)
		GET_Request(path: path2, headers: headers, param: [:]) { (Status, Data) in
			
			guard let data = Data.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = Data.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Get Clients Detail Response : ", json)
			
			if Status {
				let mainData: [String: Any] = json["data"] as! [String: Any]
//				print("Client Data : ", mainData)
//				let sendData: [String: Any] = ["data" : mainData]
				completion(true, mainData)
			}
			else {
				let errorMessage = json["error"] as! String
				completion(false, ["error": errorMessage])
			}
		}
	}
	
	
	//MARK:- Request GET WORKOUT CATEGORIES
	func Request_GetWorkoutCategories(completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		GET_Request(path: AppURL.URL_CATEGORIES_WORKOUT, headers: [:], param: [:]) { (Status, Data) in
			
			guard let data = Data.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = Data.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Workout Categories Response : ", json)
			
			if Status {
				let mainData: NSArray = json["data"] as! NSArray
				print("Main Data : ", mainData)
				completion(true, ["data": mainData])
			}
			else {
				let errorMessage = json["error"] as! String
				completion(false, ["error": errorMessage])
			}
		}
	}
	
	//MARK:- Request GET MEAL CATEGORIES
	func Request_GetMealCategories(completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		GET_Request(path: AppURL.URL_CATEGORIES_MEAL, headers: [:], param: [:]) { (Status, Data) in
			
			guard let data = Data.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = Data.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Meal Categories Response : ", json)
			
			if Status {
				let mainData: NSArray = json["data"] as! NSArray
				print("Main Data : ", mainData)
				completion(true, ["data": mainData])
			}
			else {
				let errorMessage = json["error"] as! String
				completion(false, ["error": errorMessage])
			}
		}
	}
	
	
	//MARK:-
	//MARK:-
	//MARK:- POST REQUEST
	func POST_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Bool,_ response: DataResponse<Any>) -> Void) {
		
		let urlPath:URL = URL(string: path)!
		
		var request = URLRequest(url: urlPath)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		if headers.count > 0 {
			request.setValue(headers["access-token"], forHTTPHeaderField: "access-token")
			request.setValue(headers["expiry"], forHTTPHeaderField: "expiry")
			request.setValue(headers["token-type"], forHTTPHeaderField: "token-type")
			request.setValue(headers["uid"], forHTTPHeaderField: "uid")
			request.setValue(headers["client"], forHTTPHeaderField: "client")
			print("POST REQUEST HEADERS: ", headers)
		}
		
		let data = try! JSONSerialization.data(withJSONObject: param, options: []/*JSONSerialization.WritingOptions.prettyPrinted*/)
		
		let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
		if let json = json {
			print(json)
		}
		request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
		
		Alamofire.request(request).responseJSON { (response) in
			print("POST Request Response : ", response)
			print("POST Request Headers : ", response.response!.statusCode )
			
			let statusCode = response.response!.statusCode
			
			if statusCode == 200 {
				print("Request Status 200: Success")
				completion(true, response)
			}
			else if statusCode == 201 {
				print("Request Status 201: Signup Success")
				completion(true, response)
			}
			else {
				print("Request Status Not 200: Not Success")
				completion(false, response)
			}
			
		}
	}
	
	//MARK:- Request LOGIN
	func Request_Login(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		POST_Request(path: AppURL.URL_LOGIN, headers: [:], param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("Login Response Headers : ", headerData)
			LoginHeaderData.shared.storeData(headerData)
			print("Login Response : ", json)
			
			if ResponseStatus {
				let mainData = json["data"]
				print("Main Data : ", mainData as! [String: Any])
				completion(true, mainData as! [String : Any])
			}
			else {
				
				let errorMessage: NSArray = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
	
	//MARK:- Request SIGNUP
	func Request_Signup(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		POST_Request(path: AppURL.URL_SIGNUP, headers: [:], param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("SIGNUP Response Headers : ", headerData)
			LoginHeaderData.shared.storeData(headerData)
			print("SIGNUP Response : ", json)
			
			if ResponseStatus {
				let mainData = json["success"] as! String
				//				print("Main Data : ", mainData as! [String: Any])
				completion(true, ["success": mainData])
			}
			else {
				
				let errorMessage: NSArray = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
	
	//MARK:- Request FORGOT PASSWORD
	func Request_ForgotPassword(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		POST_Request(path: AppURL.URL_FORFOT_PASSWORD, headers: [:], param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("Forgot Password Response Headers : ", headerData)
			LoginHeaderData.shared.storeData(headerData)
			print("Forgot Password Response : ", json)
			
			if ResponseStatus {
				let mainData = json["success"]
				print("Main Data : ", mainData as! String)
				completion(true, ["success": mainData ?? ""])
			}
			else {
				
				let errorMessage: NSArray = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
	
	//MARK:- Request CREATE WORKOUT
	func Request_CreateWorkout(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		POST_Request(path: AppURL.URL_ASSIGNWORKOUT, headers: LoginHeaderData.shared.Req_Headers(), param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("ASSIGN Workout Response Headers : ", headerData)
			LoginHeaderData.shared.storeData(headerData)
			print("ASSIGN Workout Response : ", json)
			
			if ResponseStatus {
				let mainData = json["data"] as! [String: Any]
				//				print("Main Data : ", mainData as! [String: Any])
				completion(true, mainData)
			}
			else {
				
				let errorMessage: NSArray = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
	
	//MARK:- Request CREATE MEAL
	func Request_CreateMeal(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		POST_Request(path: AppURL.URL_ASSIGNMEAL, headers: LoginHeaderData.shared.Req_Headers(), param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("ASSIGN Meal Response Headers : ", headerData)
			LoginHeaderData.shared.storeData(headerData)
			print("ASSIGN Meal Response : ", json)
			
			if ResponseStatus {
				let mainData = json["data"] as! [String: Any]
				completion(true, mainData)
			}
			else {
				
				let errorMessage: NSArray = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
	
	
	//MARK:-
	//MARK:-
	//MARK:- PATCH REQUEST
	func PATCH_Request(path: String, headers: [String: String], param: Parameters, completion: @escaping(_ status: Bool,_ response: DataResponse<Any>) -> Void) {
		
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
			print("PATCH Request Response : ", response)
			print("PATCH Response Headers : ", response.response! )
			
			let statusCode = response.response!.statusCode
			
			if statusCode == 200 {
				print("Request Status 200: Success")
				completion(true, response)
			}
			else {
				print("Request Status Not 200: Not Success")
				completion(false, response)
			}
			
		}
	}
	
	//MARK:- Request UPDATE PROFILE
	func Request_UpdateProfile(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		PATCH_Request(path: AppURL.URL_UPDATEPROFILE, headers: LoginHeaderData.shared.Req_Headers(), param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("UPDATE PROFILE Response : ", json)
			//				let mainData = json["success"]
			//				print("Main Data : ", mainData as! [String: Any])
			if ResponseStatus {
				let mainData = json["success"]
				completion(true, ["success": mainData as! String])
			}
			else {
				let errorMessage = json["error"]
				completion(false, ["error": errorMessage as! String])
			}
		}
	}
	
	
	//MARK:- Request UPDATE PASSWORD
	func Request_UpdatePassword(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		PATCH_Request(path: AppURL.URL_UPDATE_PASSWORD, headers: LoginHeaderData.shared.Req_Headers(), param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Update Password Response : ", json)
			//				let mainData = json["success"]
			//				print("Main Data : ", mainData as! [String: Any])
			if ResponseStatus {
				let mainData = json["success"]
				completion(true, ["success": mainData as! String])
			}
			else {
				let errorMessage = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
	
	//MARK:- Request UPDATE FORGOT PASSWORD
	func Request_UpdateForgotPassword(param: Parameters, completion: @escaping(_ success: Bool,_ response: [String: Any]) -> Void) {
		
		PATCH_Request(path: AppURL.URL_UPDATE_FORGOT_PASSWORD, headers: [:], param: param) { (ResponseStatus, ResponseData) in
			
			guard let data = ResponseData.data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
				return
			}
			
			let headerData: NSDictionary = ResponseData.response!.allHeaderFields as NSDictionary
			print("Response Header Data: ", headerData)
			print("Update Forgot Password Response : ", json)
			//				let mainData = json["success"]
			//				print("Main Data : ", mainData as! [String: Any])
			if ResponseStatus {
				let mainData = json["success"]
				completion(true, ["success": mainData as! String])
			}
			else {
				let errorMessage = json["errors"] as! NSArray
				completion(false, ["error": errorMessage[0] as! String])
			}
		}
	}
}
