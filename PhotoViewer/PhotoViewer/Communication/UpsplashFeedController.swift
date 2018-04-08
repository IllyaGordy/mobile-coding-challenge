//
//  UpsplashFeedController.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-07.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

class UpsplashFeedController: NSObject {
    
    static var currentPhotos: [Photo] = []
    
    class func pullFeed(success:@escaping ((Bool) -> Void), failed:@escaping ((NSError) -> Void)) {

        print("PullFeed")
        
        let firstPhoto = Photo.init(id: "1", title: "First", width: 120, height: 100)
        let secondPhoto = Photo.init(id: "2", title: "Second", width: 120, height: 100)
        let thirdPhoto = Photo.init(id: "3", title: "Third", width: 120, height: 100)
        let fourthPhoto = Photo.init(id: "4", title: "First", width: 120, height: 100)
        let fifthPhoto = Photo.init(id: "5", title: "Second", width: 120, height: 100)
        let sixthPhoto = Photo.init(id: "6", title: "Third", width: 120, height: 100)
        
        self.currentPhotos = [firstPhoto, secondPhoto, thirdPhoto, fourthPhoto, fifthPhoto, sixthPhoto]
        
        success(true)
    }

}
