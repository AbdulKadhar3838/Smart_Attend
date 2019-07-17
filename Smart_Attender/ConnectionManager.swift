//
//  ConnectionManager.swift
//  SwiftLearn
//
//  Created by CIPL137-MOBILITY on 20/12/16.
//  Copyright © 2016 Colan. All rights reserved.
//

import UIKit
import Foundation

    typealias SuccessCompletionHandler = (_ statusCode : Int, _ serverResponse : Any) -> Void
    typealias FailureCompletionHandler = (_ error : Any) -> Void
    
    // MARK: - Connection Methods
    func requestGetServiceAPI(urlString : String, onSuccess :@escaping SuccessCompletionHandler, onFailure : @escaping FailureCompletionHandler){
        
        print("===============================GET REQUESTING API======================================================")
        print("URL String =\(urlString)")
        
        let theURL                  = URL(string: urlString)
        var urlRequest              = URLRequest(url: theURL!)
        urlRequest.timeoutInterval  = 60 //120
        urlRequest.cachePolicy      = .reloadIgnoringCacheData
        urlRequest.httpMethod       = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let urlSessionConfig    = URLSessionConfiguration.default
        let urlSession          = URLSession(configuration: urlSessionConfig)
        
        if Reachability.isConnectedToNetwork() == true {
            
            let task    = urlSession.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                
                if error != nil
                {
                    onFailure(error!.localizedDescription)
                }
                else
                {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        onSuccess(statusCode, jsonResponse)
                    }
                    catch {
                        print("Error in JSON Serialisation");
                        onFailure("JSON Parse Error")
                    }
                }
            })
            task.resume();
        }
        else {
            onFailure("Please check internet connection")
        }
    }
    
    func requestPostServiceAPI(urlString : String, postParamter : Any, onSuccess :@escaping SuccessCompletionHandler, onFailure : @escaping FailureCompletionHandler){
        
        print("=============REQUESTING API=====================")
        print("URL String =\(urlString)")
        
        let theURL                  = URL(string: urlString)
        var urlRequest              = URLRequest(url: theURL!)
        urlRequest.timeoutInterval  = 60 //120
        urlRequest.cachePolicy      = .reloadIgnoringCacheData
        urlRequest.httpMethod       = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postParamter, options: .prettyPrinted)
        }
        catch {
            print("Cannot Parse post json")
        }
        
        let urlSessionConfig    = URLSessionConfiguration.default
        let urlSession          = URLSession(configuration: urlSessionConfig)
        
        if Reachability.isConnectedToNetwork() == true {
            
            let task    = urlSession.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                
                if error != nil
                {
                    onFailure(error!.localizedDescription)
                }
                else
                {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
                        onSuccess(statusCode, jsonResponse)
                    }
                    catch
                    {
                        print("Error in JSON Serialisation");
                        onFailure("JSON Parse Error")
                    }
                }
            })
            task.resume();

        } else {
            
            onFailure("Please check internet connection")
        }
    }
