//
//  MyExtension.swift
//  FlickerAPI
//
//  Created by 鄭文 on 2019/2/28.
//  Copyright © 2019年 Lingo. All rights reserved.
//

import UIKit
import RealmSwift

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

struct PhotoItem {
    var url:URL
    var title:String
}

class PhotoContent : Object {
    @objc dynamic var isFavorite = false
    @objc dynamic var isAdded = false
    @objc dynamic var url = ""
    @objc dynamic var title = ""
    convenience init(isFavorite favorite:Bool,myURL url:String,myTitle title:String) {
        self.init()
        self.isAdded = false
        self.isFavorite = favorite
        self.url = url
        self.title = title
    }
    override static func ignoredProperties() -> [String] {
        return ["isFavorite","isAdded"]
    }
}

class MyRealmManager : NSObject {
    static let sharedInstance = MyRealmManager()
    private override init() {
        print("init...")
    }
    
    deinit {
        print("deinit...")
    }
    
    func saveRealmObject(_ obj:Object) {
        let realm = try! Realm()
        try! realm.write{
            realm.add(obj)
        }
    }
    
    func deleteRealmObject(_ obj:Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(obj)
        }
    }
}
