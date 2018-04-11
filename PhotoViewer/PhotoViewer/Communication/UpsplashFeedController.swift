//
//  UpsplashFeedController.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-07.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import AlamofireImage

class UpsplashFeedController: NSObject {
    
    static var currentPhotos: [Photo] = []
    
    class func pullFeed(success:@escaping ((Bool) -> Void), failed:@escaping ((NSError) -> Void)) {

        let sendUrl = host + "/photos"
        
        let params = ["client_id": "7bc9b88cfd5c060a1acbdbae6478f187a3ea13e6718a35ba0d2da1c443660591"]
        
        
        Alamofire.request(sendUrl, method: .get, parameters: params).responseJSON { response in
            
            
            if let error = response.result.error {
                let errorToPass = NSError.init(domain: error.localizedDescription, code: 0, userInfo: nil)
                failed(errorToPass)
            }else {
                if response.response?.statusCode == 200 {
                    
                    
                    //to get JSON return value
                    guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                        
                        let errorMessage = "Wrong Data Error"
                        let errorToPass: NSError = NSError.init(domain: errorMessage, code: 0, userInfo: nil)
                        failed(errorToPass)
                        return
                    }
                    let customers:[Photo] = Mapper<Photo>().mapArray(JSONArray: responseJSON)
                    
                    debugPrint("Response: \(customers)")
                    
                    
                    
                }else {
                    
                    let errorMessage = "HTTP Error"
                    let errorToPass: NSError = NSError.init(domain: errorMessage, code: 0, userInfo: nil)
                    failed(errorToPass)
                }
                
            }
            
        }
        
        
        
        print("PullFeed")
        
        let firstPhoto = Photo.init(id: "1", img_description: "First", width: 120, height: 100)
        let secondPhoto = Photo.init(id: "2", img_description: "Second", width: 120, height: 100)
        let thirdPhoto = Photo.init(id: "3", img_description: "Third", width: 120, height: 100)
        let fourthPhoto = Photo.init(id: "4", img_description: "First", width: 120, height: 100)
        let fifthPhoto = Photo.init(id: "5", img_description: "Second", width: 120, height: 100)
        let sixthPhoto = Photo.init(id: "6", img_description: "Third", width: 120, height: 100)
        
        self.currentPhotos = [firstPhoto, secondPhoto, thirdPhoto, fourthPhoto, fifthPhoto, sixthPhoto]
        
        success(true)
    }

}
