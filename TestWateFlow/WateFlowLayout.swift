//
//  WateFlowLayout.swift
//  TestWateFlow
//
//  Created by 薛焱 on 16/7/25.
//  Copyright © 2016年 薛焱. All rights reserved.
//

import UIKit

@objc protocol WateFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, width: CGFloat, indexPath: NSIndexPath) -> CGFloat
}

class WateFlowLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    var delegete: WateFlowLayoutDelegate!
    var column = 3
    var attributesArray = [UICollectionViewLayoutAttributes]()
    var yArray = [CGFloat]()
    var totalHeight = 0
    override func prepareLayout() {
        super.prepareLayout()
        for _ in 0..<column {
            yArray.append(0)
        }
        
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let width = (CGRectGetWidth((collectionView?.frame)!) - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(column - 1)) / CGFloat(column)
        let height = delegete.collectionView(collectionView!, width: width, indexPath: indexPath)
        var minY: CGFloat = CGFloat(MAXFLOAT)
        for y in yArray {
            if minY > y {
                minY = y
            }
        }
        let index = yArray.indexOf(minY)
        let x = sectionInset.left + (width + minimumInteritemSpacing) * CGFloat(index!)
        let y = yArray[index!] + sectionInset.top
        yArray[index!] = height + y  + minimumLineSpacing
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.frame = CGRect(x: x, y: y, width: width, height: height)
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var sectionY: CGFloat = 0
        for y in yArray {
            if sectionY < y {
                sectionY = y
            }
        }
        let sectionAttributs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        var size = CGSizeZero
        if elementKind == UICollectionElementKindSectionHeader {
            if delegete.respondsToSelector(#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForHeaderInSection:))) {
                size = (delegete.collectionView?(collectionView!, layout: self, referenceSizeForHeaderInSection: indexPath.section))!
            }
        } else {
            if delegete.respondsToSelector(#selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForFooterInSection:))) {
                size = (delegete.collectionView?(collectionView!, layout: self, referenceSizeForFooterInSection: indexPath.section))!
            }
            sectionY += sectionInset.bottom
        }
        for i in 0 ..< yArray.count {
            yArray[i] = size.height + sectionY
        }
        sectionAttributs.frame = CGRect(x: 0, y: sectionY, width: size.width, height: size.height)
        return sectionAttributs
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        return CGSize(width: collectionView!.frame.width, height: getMaxY())
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    func getMaxY() -> CGFloat {
        let sectionCount = collectionView?.numberOfSections()
        for section in 0..<sectionCount! {
            let rowCount = collectionView?.numberOfItemsInSection(section)
            let headerAttributes = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: section))
            attributesArray.append(headerAttributes!)
            for row in 0..<rowCount! {
                let attributes = layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: row, inSection: section))
                attributesArray.append(attributes!)
            }
            let footerAttributes = layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter, atIndexPath: NSIndexPath(forItem: 0, inSection: section))
            attributesArray.append(footerAttributes!)
        }
        var maxY: CGFloat = 0
        for attributes in attributesArray {
            if maxY < CGRectGetMaxY(attributes.frame) {
                maxY = CGRectGetMaxY(attributes.frame)
            }
        }
        return maxY
    }
}
