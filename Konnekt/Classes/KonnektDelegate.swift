//
//  KonnektDelegate.swift
//  HobbyDo
//
//  Created by Çağrı Özdeş on 16.05.2019.
//  Copyright © 2019 HobbyDo. All rights reserved.
//

import UIKit

public protocol KonnektDelegate: NSObject {
    
    func uploadProgress(progress:Float,konnekt:Konnekt,task:URLSessionTask,contract:String)

}
