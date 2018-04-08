//
//  Photo.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-07.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var id: String?
    var title: String?
    var width: Int?
    var height: Int?
    
    init(id: String, title: String, width: Int, height: Int) {
        self.id   = id
        self.title = title
        self.width  = width
        self.height  = height
    }

}
