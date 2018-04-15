//
//  CustomPhotoSegue.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-15.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

class CustomPhotoSegue: UIStoryboardSegue {

    override func perform() {
        
        //set the ViewControllers for the animation
        let sourceView = self.source.view as UIView!
        let destinationView = self.destination.view as UIView!
        
        
        let window = UIApplication.shared.delegate?.window!
        // TODO: set the destination View center based on the cell
        // destinationView?.center = CGPoint(x: (sourceView?.center.x)!, y: (sourceView?.center.y)! - (destinationView?.center.y)!)
        
        window?.insertSubview(destinationView!, aboveSubview: sourceView!)
        
        
        
        destinationView?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        destinationView?.alpha = 0.0
        
        UIView.animate(withDuration: 0.4,
                       animations: {

                        destinationView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        destinationView?.alpha = 1.0

        }, completion: {
            (value: Bool) in
            
            self.source.navigationController?.pushViewController(self.destination, animated: false)


        })
        
        
    }
}
