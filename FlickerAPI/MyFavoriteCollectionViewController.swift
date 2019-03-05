//
//  MyFavoriteCollectionViewController.swift
//  FlickerAPI
//
//  Created by 鄭文 on 2019/3/2.
//  Copyright © 2019年 Lingo. All rights reserved.
//

import UIKit
import RealmSwift
private let reuseIdentifier = "FavoriteCollectionViewCell"

class MyFavoriteCollectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    let realm = try!Realm()
    var photoArray : [PhotoContent] = []
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
        self.navigationItem.title = "Favorite"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if photoArray.count > 0 {
            photoArray.removeAll()
        }
        let itemArray = try! realm.objects(PhotoContent.self)
        for item in itemArray {
            photoArray.append(item)
        }
        self.tabBarController?.navigationItem.title = "我的最愛"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刪除", style: .plain, target: self, action: #selector(deleteItem(_:)))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("\(reuseIdentifier)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCollectionViewCell
        let item = photoArray[indexPath.row]
        let imagePath = item.url
        cell.imageView.downloaded(from: imagePath)
        let title = item.title
        cell.textLabel.text = title
        //print("url is \(imagePath) and title is \(title)")
        cell.selectImageView.image = item.isDelete ? UIImage(named: "circle_Full") : UIImage(named: "circle")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! FavoriteCollectionViewCell
        let obj = photoArray[indexPath.row]
        
        var imageName = ""
        if obj.isDelete {
            obj.isDelete = false
            imageName = "circle"
        } else {
            obj.isDelete = true
            imageName = "circle_Full"
        }
        cell.selectImageView.image = UIImage(named: imageName)
    }
    
    @objc func deleteItem(_ ibaction:UIBarButtonItem){
        var deletArray = [NSInteger]()
        var i = 0
        for item in photoArray {
            if item.isDelete{
                MyRealmManager.sharedInstance.saveRealmObject(item)
                deletArray.append(i)
            }
            i = i + 1
        }
        photoArray.remove(at: deletArray)
        self.favoriteCollectionView.reloadData()
    }

}
