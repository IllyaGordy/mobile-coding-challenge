//
//  PhotoCollectionViewController.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-07.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SVProgressHUD

private let reuseIdentifier = "PhotoIdentified"
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
fileprivate let itemsPerRow: CGFloat = 3

class PhotoCollectionViewController: UICollectionViewController {

    var photoIndexToPass:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh() {
        
        if HelperUtils.isInternetAvailable() == true {
            UpsplashFeedController.pullFeed(success: { (success) in
                self.collectionView?.reloadData()
                
            }) { (failedToPullFeed) in
                print("FailedToPullFeed: \(failedToPullFeed)")
            }
        }else {
            SVProgressHUD.showInfo(withStatus: "Internet Connection not Available")
        }
    }

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
        
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.text = UpsplashFeedController.currentPhotos[indexPath.item].img_description
        
        // If Image then Set it, otherwise pull from the backend and set as the current
        if UpsplashFeedController.currentPhotos[indexPath.row].mainImage != nil {
            
            cell.imageView.image = UpsplashFeedController.currentPhotos[indexPath.row].mainImage
            
        }else if UpsplashFeedController.currentPhotos[indexPath.row].img_url != nil {
            
            cell.imageView.image = UIImage.init(named: "emptyState")
            
            UpsplashFeedController.pullImage(with: (UpsplashFeedController.currentPhotos[indexPath.row].img_url)!, success: { (returnedImage) in
                
                cell.imageView.image = returnedImage
                
                UpsplashFeedController.currentPhotos[indexPath.row].mainImage = returnedImage
                
            }, failed: { (errorPullingImage) in
                print("errorPullingImage: \(errorPullingImage)")
            })
            
        }else {
            print("Image URL is empty -> do nothing")
            cell.imageView.image = UIImage.init(named: "emptyState")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if (indexPath.row == UpsplashFeedController.currentPhotos.count - 1) {
            self.refresh()
        }
    }
    
    // Segue Prep
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.photoIndexToPass = indexPath.row
        performSegue(withIdentifier: "showPhotoDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotoDetailSegue" {
            if let photoDetailVC = segue.destination as? PhotoDetailViewController {
                photoDetailVC.currentPhotoIndex = self.photoIndexToPass
            }
        }
    }
    
    @IBAction func unwindToCollectionView(segue: UIStoryboardSegue) {
        
        if segue.source is PhotoDetailViewController {
            if let photoDetailVS = segue.source as? PhotoDetailViewController {
                let index = IndexPath(row: photoDetailVS.currentPhotoIndex!, section: 0)
                self.collectionView?.scrollToItem(at: index, at: .centeredVertically, animated: true)
            }
        }
    }
    
    // MARK: DZNEmptyDataSet
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var titleString = "No Photos Available"
        
        if HelperUtils.isInternetAvailable() == false {
            titleString = "There is no Internet Connection"
        }
        
        return NSAttributedString(string: titleString, attributes: [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Medium", size: 30)!])
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var descriptionString = "Looked like there are no photos available at this time"
        
        if HelperUtils.isInternetAvailable() == false {
            descriptionString = "Seems like you are not connected to the internet, please find some WIFI or turn off Airplane mode and try again."
        }
        
        return NSAttributedString(string: descriptionString, attributes: [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 18)!])
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let buttonString = "Refresh"
        
        return NSAttributedString(string: buttonString, attributes: [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 25)!])

    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
        if HelperUtils.isInternetAvailable() == true {
            self.refresh()
        }else {
            SVProgressHUD.showError(withStatus: "Still no Internet Connection Available")
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
