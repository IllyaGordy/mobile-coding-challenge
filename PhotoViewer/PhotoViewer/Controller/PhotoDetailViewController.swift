//
//  PhotoDetailViewController.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-14.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    var currentPhotoIndex: Int?
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupPhotoDetails()
        
        // Swipe Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPhotoDetails() {
        // If Image then Set it, otherwise pull from the backend and set as the current
        if UpsplashFeedController.currentPhotos[currentPhotoIndex!].mainImage != nil {
            
            mainImageView.image = UpsplashFeedController.currentPhotos[currentPhotoIndex!].mainImage
            
        }else if UpsplashFeedController.currentPhotos[currentPhotoIndex!].img_url != nil {
            
            if (UpsplashFeedController.currentPhotos[currentPhotoIndex!].img_url)! == "self" {
                UpsplashFeedController.currentPhotos[currentPhotoIndex!].img_url = nil
            }else {
                UpsplashFeedController.pullImage(with: (UpsplashFeedController.currentPhotos[currentPhotoIndex!].img_url)!, success: { (returnedImage) in
                    
                    self.mainImageView.image = returnedImage
                    
                    UpsplashFeedController.currentPhotos[self.currentPhotoIndex!].mainImage = returnedImage
                    
                }, failed: { (errorPullingImage) in
                    print("errorPullingImage: \(errorPullingImage)")
                })
            }
        }else {
            print("Image URL is empty -> do nothing")
            mainImageView.image = nil
        }
        
        // Set up detail
        idLabel.text = UpsplashFeedController.currentPhotos[currentPhotoIndex!].id
        usernameLabel.text = UpsplashFeedController.currentPhotos[currentPhotoIndex!].username
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if (currentPhotoIndex! > 0) {
                currentPhotoIndex! -= 1
                self.setupPhotoDetails()
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            
            if (UpsplashFeedController.currentPhotos.count > currentPhotoIndex!) {
                currentPhotoIndex! += 1
                self.setupPhotoDetails()
            }else if (UpsplashFeedController.currentPhotos.count == currentPhotoIndex!) {
                // Pull more photos and refresh
            }
        }
    }

}
