//
//  SearchResultViewController.swift
//  FlickerAPI
//
//  Created by 鄭文 on 2019/2/25.
//  Copyright © 2019年 Lingo. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var photoArray : [PhotoItem] = []
    var searchItem : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        self.navigationItem.title = "搜尋結果\(searchItem)"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func  collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCollectionViewCell", for: indexPath) as! CollectionViewCell
        //imageView.downloaded(from: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
        let photoItem = photoArray[indexPath.row]
        let imageURL = photoItem.url
        cell.imageView.downloaded(from: imageURL)
        cell.textLabel.text = photoItem.title
        return cell
    }
    
}

