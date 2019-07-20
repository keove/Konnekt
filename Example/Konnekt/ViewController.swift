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
        Konnekt.post(url: "https://postman-echo.com/post", fortype: .string, params: Paramz.create().add(name: "projectId", val: 21).give(), header: Paramz.create().add(name: "test", val: "test").give()) { result,konnekt in
            print(result)
            
            let l : UILabel = UILabel()
            l.frame = CGRect(x: 20, y: 200, width: self.view.frame.size.width-40, height: 400)
            l.numberOfLines = 0
            l.text = result as? String
            self.view.addSubview(l)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}

