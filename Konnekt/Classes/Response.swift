//
//  Response.swift
//  HobbyDo
//
//  Created by Çağrı Özdeş on 17.05.2019.
//  Copyright © 2019 HobbyDo. All rights reserved.
//

import UIKit

public class Response: NSObject {
    
    
    public static func operationSuccessKey() -> String {
        return UserDefaults.standard.string(forKey: "konnekt_response_operation_success_key") ?? "operationSuccess"
    }
    
    public static func setOperationSuccessKey(successKey:String) {
        UserDefaults.standard.set(successKey, forKey: "konnekt_response_operation_success_key")
    }
    
    
    
    public static func checkSuccess(response:String!) -> Bool {
        
        if let json : NSMutableDictionary = try! JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: .mutableContainers) as? NSMutableDictionary {
            
            let msg:String! = json["message"] as? String
            let show:Bool! = json["showMessage"] as? Bool
            
            
            if(show == true) {
                DispatchQueue.main.async {
                    dialog(title: nil, message: msg, inViewController: getVisibleViewController(nil))
                }
            }
            
            let successKey : String! = Response.operationSuccessKey()
            var operationSuccess:Bool! = json[successKey] as? Bool
            if operationSuccess == nil {
                if json[successKey] as? String == "true" {
                    operationSuccess = true
                }
            }
            if operationSuccess == true {
                return true
            }
            else {
                return false
            }
        }
        
        return false;
    }
    
    
    
    /*
     How to call this ; Response.genericFetch(response: result as? String, completion: { (u:User) in print(""); }) */
    public static func genericFetch<T: Codable>(response: String!, completion: @escaping (T) -> ()) {
        
        if let json = try! JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: .mutableContainers) as? NSMutableDictionary {
            
            let decoder : JSONDecoder = JSONDecoder();
            decoder.dataDecodingStrategy = .deferredToData;
            decoder.keyDecodingStrategy = .useDefaultKeys;
            
            let dataDict = json["data"] as! NSMutableDictionary;
            
            var dataData : Data;
            var dataJson : String!
            do {
                try dataData = JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted);
                dataJson = String(data: dataData, encoding: .utf8);
            } catch {}
            
            do {
                let model = try JSONDecoder().decode(T.self, from: dataJson.data(using: .utf8)!)
                completion(model)
            } catch let jsonErr {
                print("failed to decode, \(jsonErr)")
            }
        }
    }
    
    
    
    public static func array<T>(dataKey:String!="data", response:String!,type:T.Type) -> T! where T:Codable {
        
        let success : Bool! = checkSuccess(response: response)
        if success != true {
            return nil
        }
        
        if let json = try! JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: .mutableContainers) as? NSMutableDictionary {
            
            let decoder : JSONDecoder = JSONDecoder();
            decoder.dataDecodingStrategy = .deferredToData;
            decoder.keyDecodingStrategy = .useDefaultKeys;
            
            let dataDict = json[dataKey] as? NSMutableArray;
            
            var dataData : Data;
            var dataJson : String!
            
            if dataDict == nil {
                return nil
                
            }
            
            do {
                try dataData = JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted);
                dataJson = String(data: dataData, encoding: .utf8);
            } catch {}
            
            
            do {
                let model = try JSONDecoder().decode(T.self, from: dataJson.data(using: .utf8)!)
                return model;
            } catch let jsonErr {
                print("failed to decode, \(jsonErr)")
                return nil;
            }
        }
        else { return nil;}
        
    }
    
    public static func object<T:Codable>(response:String!,type:T.Type) -> T! {
        
        let success : Bool! = checkSuccess(response: response)
        if success != true {
            return nil
        }
        
        if let json = try! JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: .mutableContainers) as? NSMutableDictionary {
            
            let decoder : JSONDecoder = JSONDecoder();
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'mm:ss:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.dataDecodingStrategy = .deferredToData;
            decoder.keyDecodingStrategy = .useDefaultKeys;
            
            let dataDict = json["data"] as? NSMutableDictionary;
            
            if dataDict == nil {
                return nil
                
            }
            var dataData : Data;
            var dataJson : String!
            do {
                try dataData = JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted);
                dataJson = String(data: dataData, encoding: .utf8);
            } catch {}
            
            
            do {
                let model = try JSONDecoder().decode(T.self, from: dataJson.data(using: .utf8)!)
                return model;
            } catch let jsonErr {
                print("failed to decode, \(jsonErr)")
                return nil;
            }
        }
        else { return nil;}
        
        
    }
    
    public static func string(response:String!) -> String! {
        let success : Bool! = checkSuccess(response: response)
        if success != true {
            return nil
        }
        
        if let json = try! JSONSerialization.jsonObject(with: response.data(using: .utf8)!, options: .mutableContainers) as? NSMutableDictionary {
            
            let str = json["data"] as! String;
            return str
        }
        else { return nil;}
    }
    
   
    

    
    
    public static func dialog(title: String!, message: String!, inViewController: UIViewController!, okayText: String = "Okay") {
        
        DispatchQueue.main.async {
            let dialogAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            dialogAlert.addAction(UIAlertAction(title: okayText, style: .default, handler: { (action: UIAlertAction!) in
                
            }))
            inViewController?.present(dialogAlert, animated: true, completion: nil)
        }
        
    }
    
    
    public static func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {

        var rootVC = rootViewController
        if rootVC == nil {
            let windows : [UIWindow] =  UIApplication.shared.windows;
            if(windows.count < 1) {
                return nil;
            }
            rootVC = windows[0].rootViewController;
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }

}
