//
//  ViewController.swift
//  Konnekt
//
//  Created by cozdes on 07/21/2019.
//  Copyright (c) 2019 cozdes. All rights reserved.
//

import UIKit
import Konnekt



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        /*
        Konnekt.post(url: "https://postman-echo.com/post", fortype: .string, params: Paramz.create().add(name: "projectId", val: 21).give(), header: Paramz.create().add(name: "test", val: "test").give()) { result,konnekt in
            print(result)
            
            let l : UILabel = UILabel()
            l.frame = CGRect(x: 20, y: 200, width: self.view.frame.size.width-40, height: 400)
            l.numberOfLines = 0
            l.text = result as? String
            self.view.addSubview(l)
            
        }*/
        
        
        Response.setOperationSuccessKey(successKey: "success")  
        
        Konnekt.post(url: "http://radyoapp.criturk.com/appservice.aspx", fortype: .string, params: Paramz.create().add(name: "cmd", val: "get_podcasts").give(), header: Paramz.create().give()) { (result, konnekt) in
            
            
            var objs : Array<TestModal>! = Response.array(dataKey: "podcasts", response: result as? String, type: [TestModal].self)
            
            for obj in objs! {
                print(obj.name)
            }
        }
        
        /*
        Konnekt.post(url: "https://assldkfslk.com", fortype: .string, params: Paramz.create().give(), header: Paramz.create().give()) { (result, konnekt) in
            print(result)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

