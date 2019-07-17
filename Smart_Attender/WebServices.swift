//
//  WebServices.swift
//  AleefCoin
//
//  Created by Samson  on 20/03/18.
//  Copyright © 2018 Samson . All rights reserved.
//

import UIKit
class WebServices: NSObject {
    
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
                    print("Error  ==",error!.localizedDescription);
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
            
        } else {
            
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
    
    func getAPI<Element: Decodable>(urlString : String, onSuccess :@escaping SuccessCompletionHandler, onFailure : @escaping FailureCompletionHandler,myStruct:Element.Type){
        
        print("===============================GET REQUESTING API======================================================")
        print("URL String =\(urlString)")
        
        let theURL                  = URL(string: urlString)
        var urlRequest              = URLRequest(url: theURL!)
        urlRequest.timeoutInterval  = 60 //120
        urlRequest.cachePolicy      = .reloadIgnoringCacheData
        urlRequest.httpMethod       = "GET"
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
                    
                    let decoder = JSONDecoder()

                    do {
                        let jsonResponse = try decoder.decode(myStruct, from: data!)
                        
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
        }
        else {
            onFailure("Please check internet connection")
        }
    }
    
    func postAPI<Element: Decodable>(urlString : String, postParamter : [String:AnyObject], onSuccess :@escaping SuccessCompletionHandler, onFailure : @escaping FailureCompletionHandler,myStruct:Element.Type){
        
        DispatchQueue.main.async {
            // Update UI
        print("=============REQUESTING API=====================")
        print("URL String =\(urlString)")
        
        let theURL                  = URL(string: urlString)
        var urlRequest              = URLRequest(url: theURL!)
        urlRequest.timeoutInterval  = 60 //120
        urlRequest.cachePolicy      = .reloadIgnoringCacheData
        urlRequest.httpMethod       = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
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
                    print("Error  ==",error!.localizedDescription);
                    onFailure(error!.localizedDescription)
                }
                else
                {
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    let decoder = JSONDecoder()
                    
                    do
                    {
                        let jsonResponse = try decoder.decode(myStruct, from: data!)
                        
                        onSuccess(statusCode, jsonResponse)
                    }
                    catch let errors
                    {
                        print(errors)
                        do
                        {
                            let failResponse = try decoder.decode(DefaultResponseCodable.self, from: data!)
                            onSuccess(statusCode, failResponse)
                        }
                        catch
                        {
                            onFailure("Json Parse Error")
                        }
                    }
                }
            })
            task.resume();
            
        } else
        {
            onFailure("Please check internet connection")
        }
        }
    }
    
    func SecureAPI(urlString : String, postParamter : [String:AnyObject], onSuccess :@escaping SuccessCompletionHandler, onFailure : @escaping FailureCompletionHandler){
        
        print("===============================REQUESTING API======================================================")
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
                    print("Error  ==",error!.localizedDescription);
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
}
