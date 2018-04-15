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
    
    static var lastPulledPage = 0
    static var pulledPages:[Int] = []
    static let numberOfPhotosPerPage = 20
    
    class func pullFeed(success:@escaping ((Bool) -> Void), failed:@escaping ((NSError) -> Void)) {

        let sendUrl = host + "/photos"
        
        let params = ["client_id": upsplashKey,
            "page": lastPulledPage + 1,
            "per_page": numberOfPhotosPerPage] as [String : Any]
        
        if !pulledPages.contains(lastPulledPage + 1) {
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
                        let photos:[Photo] = Mapper<Photo>().mapArray(JSONArray: responseJSON)
                        
                        self.currentPhotos.append(contentsOf: photos)
                        self.lastPulledPage += 1
                        self.pulledPages.append(self.lastPulledPage)
                        
                        success(true)
                        
                    }else {
                        
                        let errorMessage = "HTTP Error"
                        let errorToPass: NSError = NSError.init(domain: errorMessage, code: 0, userInfo: nil)
                        failed(errorToPass)
                    }
                }
            }
        }
        
        
        
    }
    
    
    class func pullImage(with stringUrl:String, success:@escaping ((UIImage) -> Void), failed:@escaping ((NSError) -> Void)) {
        
        Alamofire.request(stringUrl, method: .get, parameters: nil).responseImage { (responseImage) in
            
            if let image = responseImage.result.value {
                success(image)
            }else {
                let errorMessage = "Pulling Image Failed"
                let errorToPass: NSError = NSError.init(domain: errorMessage, code: 1, userInfo: nil)
                failed(errorToPass)
            }
        }
        
    }

}
