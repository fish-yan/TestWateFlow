//
//  ViewController.swift
//  TestWateFlow
//
//  Created by 薛焱 on 16/7/25.
//  Copyright © 2016年 薛焱. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = NSBundle.mainBundle().pathForResource("1", ofType: "plist")
        dataArray = NSArray(contentsOfFile: path!)!
        
        let flowLayout = WateFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.delegete = self
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.registerClass(HeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.registerClass(HeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ViewController: WateFlowLayoutDelegate {
    func collectionView(collectionView: UICollectionView, width: CGFloat, indexPath: NSIndexPath) -> CGFloat {
        let dict = dataArray[indexPath.row] as! NSDictionary
        let h = CGFloat((dict["h"]?.floatValue)!)
        let w = CGFloat((dict["w"]?.floatValue)!)
        return h / w * width
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 20)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WateFlowCell", forIndexPath: indexPath) as! WateFlowCell
        let dict = dataArray[indexPath.row] as! NSDictionary
        let url = dict["img"] as! String
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: NSURL(string: url)!)
            if data != nil {
                dispatch_async(dispatch_get_main_queue(), { 
                    cell.image.image = UIImage(data: data!)
                })
            }
        }
        

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
            header.backgroundColor = UIColor.redColor()
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath)
            header.backgroundColor = UIColor.orangeColor()
            return header
        }
        
        
    }
    
    
}

