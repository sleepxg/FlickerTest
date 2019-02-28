//
//  ViewController.swift
//  FlickerAPI
//
//  Created by 鄭文 on 2019/2/25.
//  Copyright © 2019年 Lingo. All rights reserved.
//

import UIKit
import FlickrKit
class ViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var countField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    var photoArray : [PhotoItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        countField.delegate = self
        searchBtn.isEnabled = false
        searchBtn.setBackgroundColor(color: UIColor.blue, forState:.normal)
        searchBtn.setBackgroundColor(color: UIColor.lightGray, forState:.disabled)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isEqual(countField)  {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchBtnCheck()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchBtnCheck()
    }
    
    func searchBtnCheck() {
        guard let sea = searchField.text,let cou = countField.text else {
            searchBtn.backgroundColor = UIColor.lightGray
            searchBtn.isEnabled = false
            return
        }
        if sea.count>0,cou.count>0 {
            searchBtn.backgroundColor = UIColor.blue
            searchBtn.isEnabled = true
        } else {
            searchBtn.backgroundColor = UIColor.lightGray
            searchBtn.isEnabled = false
        }
        
    }
    
    @IBAction func searchBtnClick(_ sender: Any) {
        guard let searchItem = searchField.text,let counts = countField.text else {
            return
        }
        if searchItem.count==0 || counts.count == 0 {
            return
        }
        self.photoArray.removeAll()
        
        FlickrKit.shared().initialize(withAPIKey: "yourKEY", sharedSecret: "yourSecretKey")
        let photoSearch = FKFlickrPhotosSearch()
        photoSearch.text = searchItem
        photoSearch.per_page = counts

        FlickrKit.shared().call(photoSearch) { (response, error) in
            if let result = response{
                DispatchQueue.main.sync {
                    let topPhotos = result["photos"] as! [NSString:AnyObject]
                    let photoArray = topPhotos["photo"] as! [[NSString:AnyObject]]
                    for photoDic in photoArray {
                        let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.unknown, fromPhotoDictionary: photoDic)
                        print(photoURL)
                        self.photoArray.append(PhotoItem(url: photoURL, title: photoDic["title"] as! String))
                    }
                    let resultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
                    resultVC.photoArray = self.photoArray
                    resultVC.searchItem = searchItem
                    self.navigationController?.pushViewController(resultVC, animated: true)
                }
            } else if let err = error{
                print(err)
            }
        }
    }
    
}