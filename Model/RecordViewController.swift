//
//  RecordViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase

class RecordViewController: UIViewController {
    
    static let shared = RecordViewController()
    
    func dataSet(date: String,weight: String,number: String,menu: String,keys: String,userName:String){

//        func dataSet(date: String,weight: String,number: String,menu: String,keys: String,userName:String, imageData:NSData){

        
        let rootref = Database.database().reference(fromURL: "https://muscleshow-b3569.firebaseio.com/").child("postdata").child("\(userName)")
        

        let storage = Storage.storage().reference(forURL: "gs://muscleshow-b3569.appspot.com/")
        
        if keys == "damyy" {

            let key = rootref.childByAutoId().key


            let feed = ["date":date, "weight":weight, "number":number ,"menu":menu, "key": key]
            let postFeed = ["\(key)":feed]
                    
            rootref.updateChildValues(postFeed)

            self.dismiss(animated: true, completion: nil)
            
        } else {
            let key = keys as? String
            
            let feed = ["date":date, "weight":weight, "number":number ,"menu":menu, "key": key]
            let postFeed = ["\(key)":feed]
                    
            rootref.updateChildValues(postFeed)
            //SVProgressHUD.dismiss()

            self.dismiss(animated: true, completion: nil)
            
//            let feed = ["date":date, "weight":weight, "number":number ,"menu":menu, "key": key]
//            let postFeed = ["\(key)":feed]
//            rootref.updateChildValues(postFeed)
        }
        
    }
    
    func imageSet(date: String, userName:String, imageData:NSData){

        let rootref = Database.database().reference(fromURL: "https://muscleshow-b3569.firebaseio.com/").child("imageData").child("\(userName)").child("\(date)")
        let storage = Storage.storage().reference(forURL: "gs://muscleshow-b3569.appspot.com/")
        let key = rootref.childByAutoId().key
        let imageRef = storage.child("\(userName)").child("\(key).jpg")
        
        let uploadTask = imageRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                let feed = ["date":date, "imageData": url?.absoluteString]
                rootref.setValue(feed)
            })
        }
        uploadTask.resume()
        self.dismiss(animated: true, completion: nil)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
