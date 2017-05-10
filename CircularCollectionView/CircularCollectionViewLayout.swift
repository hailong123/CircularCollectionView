//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by 123456 on 2017/5/10.
//  Copyright © 2017年 Rounak Jain. All rights reserved.
//

import UIKit

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var anchorPoint = CGPoint(x:0.5, y:0.5)
		
  var angle: CGFloat = 0 {
    didSet {
      zIndex = Int(angle * 100000)
      transform = transform.rotated(by: angle)
    }
  }
  
  override func copy(with zone: NSZone? = nil) -> Any {
    let copiedAttributes:CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
    
    copiedAttributes.angle       = self.angle
    copiedAttributes.anchorPoint = self.anchorPoint
    return copiedAttributes
    
  }
  
}

class CircularCollectionViewLayout: UICollectionViewLayout {

  let itemSize = CGSize(width:133, height:173)
  
  var angleAtExtreme:CGFloat {
    return collectionView!.numberOfItems(inSection: 0) > 0 ? -CGFloat(collectionView!.numberOfItems(inSection:0) - 1) * anglePerItem : 0
  }
		
  var anlge : CGFloat {
    
    return angleAtExtreme * collectionView!.contentOffset.x / (collectionViewContentSize.width - collectionView!.bounds.width)
    
  }
		
  
  var radius:CGFloat = 500 {
    
    didSet {
      invalidateLayout()
    }
    
  }
  
  var anglePerItem: CGFloat {
    return atan(itemSize.width*0.5 / radius)
  }
  
  override var collectionViewContentSize: CGSize {
    return CGSize(width:CGFloat(collectionView!.numberOfItems(inSection: 0)) * itemSize.width,height:collectionView!.bounds.height)
  }
  
  override class var layoutAttributesClass: Swift.AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }
  
  var attributesList = [CircularCollectionViewLayoutAttributes]()
		
  
  override func prepare() {
    
    super.prepare()
    
    let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
    
    let theta = atan2(collectionView!.bounds.width / 2.0, radius + (itemSize.height / 2.0) - collectionView!.bounds.height / 2.0)
    
    var startIndex = 0
    
    var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
    
    if anlge < -theta {
      startIndex = Int(floor((-theta - anlge) / anglePerItem))
    }
    
    endIndex = min(endIndex, Int(ceil((theta - anlge) / anglePerItem)))
    
    if endIndex < startIndex {
      endIndex   = 0
      startIndex = 0
    }
    
    let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
   
    attributesList = (startIndex...endIndex).map({ (i) -> CircularCollectionViewLayoutAttributes in
      
      let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath.init(row: i, section: 0))
      
      attributes.size        = self.itemSize
      attributes.center      = CGPoint(x:centerX, y:self.collectionView!.bounds.midY)
//      attributes.angle       = self.anglePerItem * CGFloat(i)
      attributes.anchorPoint = CGPoint(x:0.5, y:anchorPointY)
      attributes.angle       = self.anlge + (self.anglePerItem * CGFloat(i))
      
      return attributes
      
    })
    
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  

  override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    
    var finalContentOffset = proposedContentOffset
    
    let factor = -angleAtExtreme/(collectionViewContentSize.width - collectionView!.bounds.width)
    
    let proposedAngle = proposedContentOffset.x * factor
    
    let ratio = proposedAngle / anglePerItem
    
    var muliplier : CGFloat

    if velocity.x > 0 {
      muliplier = ceil(ratio)
    } else if velocity.x < 0 {
      muliplier = floor(ratio)
    } else {
      muliplier = round(ratio)
    }
   
    finalContentOffset.x = muliplier * anglePerItem / factor
    
    return finalContentOffset
    
  }
  
}
