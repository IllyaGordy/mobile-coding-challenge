//
//  PhotoCollectionViewController.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-07.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoIdentified"
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 3

class PhotoCollectionViewController: UICollectionViewController {

    var photoToPass:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpsplashFeedController.pullFeed(success: { (success) in
            self.collectionView?.reloadData()
            
        }) { (failedToPullFeed) in
            print("FailedToPullFeed: \(failedToPullFeed)")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UpsplashFeedController.currentPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridPhotoCollectionViewCell
        
        cell.backgroundColor = UIColor.blue
        
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.text = UpsplashFeedController.currentPhotos[indexPath.item].img_description
        
        // If Image then Set it, otherwise pull from the backend and set as the current
        if UpsplashFeedController.currentPhotos[indexPath.row].mainImage != nil {
            
            cell.imageView.image = UpsplashFeedController.currentPhotos[indexPath.row].mainImage
            
        }else if UpsplashFeedController.currentPhotos[indexPath.row].img_url != nil {
            
            if (UpsplashFeedController.currentPhotos[indexPath.row].img_url)! == "self" {
                UpsplashFeedController.currentPhotos[indexPath.row].img_url = nil
            }else {
                UpsplashFeedController.pullImage(with: (UpsplashFeedController.currentPhotos[indexPath.row].img_url)!, success: { (returnedImage) in
                    
                    cell.imageView.image = returnedImage
                    
                    UpsplashFeedController.currentPhotos[indexPath.row].mainImage = returnedImage
                    
                }, failed: { (errorPullingImage) in
                    print("errorPullingImage: \(errorPullingImage)")
                })
            }
            
        }else {
            print("Image URL is empty -> do nothing")
            cell.imageView.image = nil
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath.row == UpsplashFeedController.currentPhotos.count - 1) {
            
            UpsplashFeedController.pullFeed(success: { (success) in
                self.collectionView?.reloadData()
                
            }) { (failedToPullFeed) in
                print("FailedToPullFeed: \(failedToPullFeed)")
            }
        }
        
    }
    
    // Segue Prep
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.photoToPass = UpsplashFeedController.currentPhotos[indexPath.row]
        performSegue(withIdentifier: "showPhotoDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotoDetailSegue" {
            if let photoDetailVC = segue.destination as? PhotoDetailViewController {
                photoDetailVC.currentPhoto = self.photoToPass //?.copy() as? Photo
            }
        }
    }

}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
