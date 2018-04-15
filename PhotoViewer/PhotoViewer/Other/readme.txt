README:

TradeRev - Mobile Challange
By: Illya Gordiyenko
Date: April 15th, 2018

General:
- Version: iOS 10.0 +
- Swift 4.0
- Using Cocoapods - most are helper UI functions + Alamofire

Project Notes:
- There is not much commenting, but most of the code is fairly straight forward.
- I've kept track of my changes in the GIT, for further investigation on what I did, please read that.
- Project all together is lacking Unit Testing, ran out of time for this functionality

Bugs and Future Improvements:
- There is a number of TODO for future improvements:
  - CustomPhotoSegue: should segue out from the actual cell, so would need to pass in the coordinates of the cell and set the destinationVS center from there
  - PhotoDetailViewController: There is no functionality for the edge case of getting to the end of the photo list, this should pull up the next batch of items from the backend
  - UI: Should setup the collectionView cells around the provided width/height of the photos, this would look much better.
