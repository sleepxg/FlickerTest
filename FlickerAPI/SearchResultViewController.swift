//
//  SearchResultViewController.swift
//  FlickerAPI
//
//  Created by 鄭文 on 2019/2/25.
//  Copyright © 2019年 Lingo. All rights reserved.
//

import UIKit
private let reuseIdentifier = "myCollectionViewCell"
class SearchResultViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var photoArray : [PhotoContent] = []
    var searchItem : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        self.tabBarController?.navigationItem.title = "搜尋結果\(searchItem)"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveItem(_:)))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func  collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        //imageView.downloaded(from: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
        let photoItem = photoArray[indexPath.row]
        let imageURL = photoItem.url
        cell.imageView.downloaded(from: imageURL)
        let title = photoItem.title
        cell.textLabel.text = title
        
        cell.selectImageView.image = photoItem.isFavorite ? UIImage(named: "circle_Full") : UIImage(named: "circle")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let obj = photoArray[indexPath.row]
        
        var imageName = ""
        if obj.isFavorite {
            obj.isFavorite = false
            imageName = "circle"
        } else {
            obj.isFavorite = true
            imageName = "circle_Full"
        }
        cell.selectImageView.image = UIImage(named: imageName)
    }
    
    @objc func saveItem(_ ibaction:UIBarButtonItem){
        for item in photoArray {
            if item.isAdded == false {
                item.isAdded = true
                MyRealmManager.sharedInstance.saveRealmObject(item)
            }
        }
    }
}

