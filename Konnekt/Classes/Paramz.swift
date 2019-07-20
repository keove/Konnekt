//
//  Paramz.swift
//  HobbyDo
//
//  Created by Çağrı Özdeş on 16.05.2019.
//  Copyright © 2019 HobbyDo. All rights reserved.
//

import UIKit

public class Paramz: NSObject {
    
    var dictionary : NSMutableDictionary! = NSMutableDictionary();
    
    
    public static func create() -> Paramz {
        
        let paramz : Paramz! = Paramz();
        return paramz;
    }
    
    override init() {
        dictionary = NSMutableDictionary();
    }
    
    public func add(name:String,val:Any?) -> Paramz {
        dictionary.setValue(val, forKey: name);
        return self;
    }
    
    public func add(name:String,val:Any?,encode:Bool) {
        if(encode) {
            
        }
        else {
            add(name:name,val:val);
        }
    }
    
    public func give() -> NSMutableDictionary {
        return dictionary;
    }
    
}
