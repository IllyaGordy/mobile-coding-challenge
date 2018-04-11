//
//  Photo.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-07.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo: NSObject, Mappable {
    
    var id: String?
    var img_description: String?
    var width: Int?
    var height: Int?
    var img_url: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {

        id <- map["id"]
        img_description <- map["description"]
        width <- map["width"]
        height <- map["height"]
        img_url <- map["urls.regular"]
    }
    
    init(id: String, img_description: String, width: Int, height: Int) {
        self.id   = id
        self.img_description = img_description
        self.width  = width
        self.height  = height
    }

}
