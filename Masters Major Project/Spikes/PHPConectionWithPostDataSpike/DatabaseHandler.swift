//
//  DatabaseHandler.swift
//  PHPConectionWithPostDataSpike
//
//  Created by Doug Williams on 07/09/2017.
//  Copyright © 2017 Doug Williams. All rights reserved.
//

import Foundation
import UIKit

class DatabaseHandler {
    
    func getUser(urlStringPath:String,username:String,password:String) {
        let url:URL = URL(string: urlStringPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("fundamental networking error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString!))")
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
            task.resume()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
}
