//
//  UnwindCustomPhotoSegue.swift
//  PhotoViewer
//
//  Created by Illya Gordiyenko on 2018-04-15.
//  Copyright © 2018 Illya Gordiyenko. All rights reserved.
//

import UIKit

class UnwindCustomPhotoSegue: UIStoryboardSegue {

    override func perform() {
        
        
        let sourceView = self.source.view as UIView!
        let destinationView = self.destination.view as UIView!
        let window = UIApplication.shared.delegate?.window!
        
        window?.insertSubview(destinationView!, belowSubview: sourceView!)
        
        destinationView?.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        destinationView?.alpha = 0.0
        
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        
                        destinationView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        destinationView?.alpha = 1.0
                        
        }, completion: {
            (value: Bool) in
            //4. dismiss
            destinationView?.removeFromSuperview()
            if let navController = self.destination.navigationController {
                navController.popToViewController(self.destination, animated: false)
            }
            
            
        })
        
        
        
    }
}
