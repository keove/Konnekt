//
//  konnekt.swift
//  HobbyDo
//
//  Created by Çağrı Özdeş on 15.05.2019.
//  Copyright © 2019 HobbyDo. All rights reserved.
//

import UIKit




public class Konnekt: NSObject,URLSessionTaskDelegate,URLSessionDelegate,URLSessionDataDelegate {
    
    public static var CUSTOM_EVENT_TRIGGER_STRING : String! = ""
    public static var CUSTOM_EVENT_NAME : String! = ""
    
    
    public enum KonnektResponseType {
        case string,json,data,object,arrayobject
    }
    
    
    public var responseString : String! = "";
    public var responseData : Data!
    
    public var delegate : KonnektDelegate!
    public var responseType : KonnektResponseType! = KonnektResponseType.string;
    public var contract : String! = "";
    public var statusCode : Int = 0;
    
    public var method : String = "GET";
    public var postParams : NSMutableDictionary!
    public var headerParams : NSMutableDictionary!
    public var getParams : NSMutableDictionary!
    public var postFile : PostFile! = nil
    public var session : URLSession!
    
    public var expectedContentLength = 0
    
    
    public func post(url:String, completion : @escaping (_ result:Data) -> ()) {
        let u : URL! = URL(string:url);
        var request : URLRequest = URLRequest(url:u);
        request.httpMethod = "POST";
        
        if(headerParams != nil) {
            for(key,value)in headerParams {
                
                let v : String = "\(value)"
                let h : String = key as! String;
                
                /*
                if let i = value as? Int {
                    
                }
                else {
                    let v : String = value as! String;
                    let h : String = key as! String;
                }*/
                
                
                request.addValue(v, forHTTPHeaderField: h);
            }
        }
        
        
        if(postFile != nil) {
            let boundary : String = "____KonnektBoundary____";
            let contentType : String = ("multipart/form-data; boundary="+boundary)
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let body : NSMutableData = NSMutableData()
            
            
            if(postParams != nil && postParams.count > 0) {
                
                for(key,value) in postParams {
                    var paramName : String = "";
                    let v : String = "\(value)"
                    paramName = key as! String;
                    
                    
                    body.append(("\r\n--"+boundary+"\r\n").data(using: .utf8)!)
                    body.append(("Content-Disposition: form-data; name=\""+paramName+"\"\r\n\r\n").data(using: .utf8)!)
                    body.append(v.data(using: .utf8)!)
                }
            }
            
            body.append(("\r\n--"+boundary+"\r\n").data(using: .utf8)!)
            body.append(("Content-Disposition: form-data; name=\""+postFile.fileKey+"\"; filename=\""+postFile.fileName+"\"\r\n").data(using: .utf8)!)
            body.append(("Content-Type: application/octet-stream\r\n\r\n").data(using: .utf8)!)
            body.append(postFile.fileData!)
            body.append(("\r\n--"+boundary+"\r\n").data(using: .utf8)!)
            request.httpBody = body as Data
            request.setValue(String(format: "%lu", body.length), forHTTPHeaderField: "Content-Lenght")

            
        }
        else if(postParams != nil) {
            var paramsString : String = "";
            for(key,value) in postParams {
                let v : String = "\(value)"
                paramsString += (key as! String+"="+v)+"&";
            }
            
            request.httpBody = paramsString.data(using: .utf8);
        }
        
        
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        
        let task = session.dataTask(with: request) {
            (data,response,error) in
            
            if let error = error {
                print("konnekt error \(error)");
            }
            else {
                if let response = response as? HTTPURLResponse {
                    self.statusCode = response.statusCode;
                }
                if let data = data {
                    self.responseData = data;
                    self.responseString = String(data:data,encoding: .utf8);
                    
                    if self.responseString.contains(Konnekt.CUSTOM_EVENT_TRIGGER_STRING) {
                        //GlobalEventHub.fireEvent(eventName: Konnekt.CUSTOM_EVENT_NAME, object: nil, flag: false, code: 0)
                    }
                    //print("konnekt response \(self.responseString)");
                    completion(self.responseData);
                    
                }
                else {
                    print("konnekt - no data");
                }
            }
        }
        task.resume()
        
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        //print("Konnekt upload progress : \(uploadProgress)")
        if delegate != nil {
            delegate.uploadProgress(progress: uploadProgress, konnekt: self, task: task, contract: self.contract)
        }
    }
    
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        expectedContentLength = Int(response.expectedContentLength)
        completionHandler(.allow)
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        //let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
        //progress.progress =  percentageDownloaded
        print("Konnekt download progress")
    }
    
    
    public func get(url:String, completion : @escaping (_ result : Data) -> ()) {
        
        var finalUrl : String = url;
        
        if(getParams != nil) {
            
            var paramsString : String = "";
            for (key,value) in getParams {
                let v : String = value as! String;
                paramsString += (key as! String+"="+v)+"&";
            }
            
            finalUrl += "?";
            finalUrl += paramsString;
        }
        
        let u : URL! = URL(string:url);
        var request : URLRequest = URLRequest(url:u);
        request.httpMethod = "GET";
        
        if(headerParams != nil) {
            for(key,value)in headerParams {
                let v : String = value as! String;
                let h : String = key as! String;
                request.addValue(v, forHTTPHeaderField: h);
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data,response,error) in
            
            if let error = error {
                print("konnekt error \(error)");
            }
            else {
                if let response = response as? HTTPURLResponse {
                    self.statusCode = response.statusCode;
                }
                if let data = data {
                    self.responseData = data;
                    self.responseString = String(data:data,encoding: .utf8);
                    //print("konnekt response \(self.responseString)");
                    completion(self.responseData);
                    
                }
                else {
                    print("konnekt - no data");
                }
            }
            
        }
        task.resume()
    }
    
    
    
    public static func post(postFile:PostFile! = nil,delegate:KonnektDelegate! = nil, url:String,fortype:KonnektResponseType,params:NSMutableDictionary,header:NSMutableDictionary, completion : @escaping (_ result:Any, _ konnekt:Konnekt)
        -> ()) {
        
        let konnekt : Konnekt = Konnekt();
        konnekt.headerParams = header;
        konnekt.postParams = params;
        konnekt.responseType = fortype;
        konnekt.postFile = postFile
        konnekt.delegate = delegate
        konnekt.post(url: url) { result in
            if(fortype == .string) {
                DispatchQueue.main.async {
                    completion(konnekt.responseString!,konnekt)
                }
                
            }
            else if(fortype == .data) {
                DispatchQueue.main.async {
                    completion(konnekt.responseData!,konnekt);
                }
                
            }
            else if(fortype == .json) {
                do {
                    let json = try JSONSerialization.jsonObject(with: konnekt.responseData, options: JSONSerialization.ReadingOptions.mutableContainers);
                    DispatchQueue.main.async {
                        completion(json,konnekt);
                    }
                    
                }
                catch let jsonError {
                    print("\(jsonError)")
                }
            }
            else if(fortype == .object) {
                
            }
        }
    }
    
    
    
    public func post(url:String,fortype:KonnektResponseType,params:NSMutableDictionary,header:NSMutableDictionary, completion : @escaping (_ result:Any, _ konnekt:Konnekt)
        -> ()) {
        
        self.headerParams = header;
        self.postParams = params;
        self.responseType = fortype;
        
        post(url: url) { result in
            if(fortype == .string) {
                completion(self.responseString!,self)
            }
            else if(fortype == .data) {
                completion(self.responseData!,self);
            }
            else if(fortype == .json) {
                do {
                    let json = try JSONSerialization.jsonObject(with: self.responseData, options: JSONSerialization.ReadingOptions.mutableContainers);
                    completion(json,self);
                }
                catch let jsonError {
                    print("\(jsonError)")
                }
            }
            else if(fortype == .object) {
                
            }
        }
        
        
    }
    
    
    public func get(url:String,contract:String,fortype:KonnektResponseType,params:NSMutableDictionary,header:NSMutableDictionary, completion : @escaping (_ result :Any) -> ()) {
        self.headerParams = header;
        self.getParams = params;
        self.responseType = fortype;
        self.contract = contract;
        //get(url: url, contract: contract, fortype: fortype,params: params);
        /*get(url:url,contract: contract,fortype: fortype,params: params,completion: {
            result in
            completion(result);
        })*/
        get(url: url) { result in
            
            if(fortype == .string) {
                completion(self.responseString!)
            }
            else if(fortype == .data) {
                completion(self.responseData!);
            }
            else if(fortype == .json) {
                do {
                    let json = try JSONSerialization.jsonObject(with: self.responseData, options: JSONSerialization.ReadingOptions.mutableContainers);
                    completion(json);
                }
                catch let jsonError {
                    print("\(jsonError)")
                }
            }
            else if(fortype == .object) {
                
            }
            
            
        }
    }
    
    
    
    
    

}
