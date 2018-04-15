//
//  PhotoDetailViewController.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-14.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var currentPhoto: Photo?
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // If Image then Set it, otherwise pull from the backend and set as the current
        if currentPhoto?.mainImage != nil {
            
            mainImageView.image = currentPhoto?.mainImage
            
        }else if currentPhoto?.img_url != nil {
            
            if (currentPhoto?.img_url)! == "self" {
                currentPhoto?.img_url = nil
            }else {
                UpsplashFeedController.pullImage(with: (currentPhoto?.img_url)!, success: { (returnedImage) in
                    
                    self.mainImageView.image = returnedImage
                    
                    self.currentPhoto?.mainImage = returnedImage
                    
                }, failed: { (errorPullingImage) in
                    print("errorPullingImage: \(errorPullingImage)")
                })
            }
        }else {
            print("Image URL is empty -> do nothing")
            mainImageView.image = nil
        }
        
        // Set up detail
        idLabel.text = currentPhoto?.id
        usernameLabel.text = currentPhoto?.username

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
