//
//  TestModal.swift
//  Konnekt_Example
//
//  Created by Çağrı Özdeş on 30.07.2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

class TestModal : Codable {
    
    private enum CodingKeys : String, CodingKey {
        case id,name,header,summary,thumburl,streamAddress,podcastFileUrl,date
    }
    
    var id : Int!
    var name : String!
    var header : String!
    var summary : String!
    var thumburl : String!
    var streamAddress : String!
    var podcastFileUrl : String!
    var date : String!
}
