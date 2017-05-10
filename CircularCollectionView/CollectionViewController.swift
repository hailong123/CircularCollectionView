//
//  CollectionViewController.swift
//  CircularCollectionView
//
//  Created by Rounak Jain on 10/05/15.
//  Copyright (c) 2015 Rounak Jain. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
  
  let images: [String] = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Images") 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Register cell classes
    collectionView!.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    let imageView = UIImageView(image: UIImage(named: "bg-dark.jpg"))
    imageView.contentMode = UIViewContentMode.scaleAspectFill
    collectionView!.backgroundView = imageView
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CircularCollectionViewCell
    cell.imageName = images[indexPath.row]
      return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    NSLog("你点击了第%ld本书", indexPath.row)

    let indexNum = indexPath.row - 2
    
    collectionView.scrollToItem(at: NSIndexPath.init(row: (indexNum > 0 ? indexNum : 0), section: 0) as IndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    
  }
  
}

