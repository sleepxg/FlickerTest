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
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
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
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
