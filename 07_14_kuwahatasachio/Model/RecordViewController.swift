//
//  RecordViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RecordViewController: UIViewController {
    
    static let shared = RecordViewController()
    
    // Firestore
    let db = Firestore.firestore()
    
    func dataSet(date: String,weight: String,number: String,menu: String,userName:String){

        // Firestore
        guard let uid = User.shared.getUid() else {
            fatalError("Uidを取得出来ません。")
        }
        let ref = self.getManuCollectionRef()
        
        
//        let rootref = Database.database().reference(fromURL: "https://muscleshow-b3569.firebaseio.com/").child("postdata").child("\(userName)")
        
//        let storage = Storage.storage().reference(forURL: "gs://muscleshow-b3569.appspot.com/")
        
//        if keys == "damyy" {
//
//            let key = rootref.childByAutoId().key
            let feed = ["date":date, "weight":weight, "number":number ,"menu":menu]
//            let postFeed = ["\(key)":feed]
//            rootref.updateChildValues(postFeed)

            // Firestore
            let documentRef = ref.addDocument(data: feed)
            self.dismiss(animated: true, completion: nil)
            
//        } else {
//            let key = keys as? String
//
//            let feed = ["date":date, "weight":weight, "number":number ,"menu":menu, "key": key]
//            let postFeed = ["\(key)":feed]
//
//            rootref.updateChildValues(postFeed)
//            //SVProgressHUD.dismiss()
//
//            self.dismiss(animated: true, completion: nil)
//        }
        
    }
    
    func imageSet(date: String, userName:String, imageData:NSData){
        
        //Firestore
        guard let uid = User.shared.getUid() else {
            fatalError("Uidを取得出来ません。")
        }
        let ref = self.getImageCollectionRef()


//        let rootref = Database.database().reference(fromURL: "https://muscleshow-b3569.firebaseio.com/").child("imageData").child("\(userName)").child("\(date)")

        let storage = Storage.storage().reference(forURL: "gs://muscleshow-b3569.appspot.com/")
//        let key = rootref.childByAutoId().key

        let key = ref.document().documentID
        print("key: \(key)")
        let imageRef = storage.child("\(userName)").child("\(key).jpg")
        
        print("dataimageeeee: \(imageData)")
        let uploadTask = imageRef.putData(imageData as Data, metadata: nil) { (metadata, error) in
            if error != nil {
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Errorrrrr: \(error)")
                    return
                }
                print("url: \(url)")
                let feed = ["date":date, "imageData": url?.absoluteString]
//                rootref.setValue(feed)
                
                // Firestore
                ref.document("\(date)").setData(feed)
            })
        }
        uploadTask.resume()
        self.dismiss(animated: true, completion: nil)

    }
    
    // Firestore
    private func getManuCollectionRef () -> CollectionReference {
        guard let uid = User.shared.getUid() else {
            fatalError ("Uidを取得出来ませんでした。")
        }
        return db.collection("PostData").document(uid).collection("Menu")
    }

    // Firestore
    private func getImageCollectionRef () -> CollectionReference {
        guard let uid = User.shared.getUid() else {
            fatalError ("Uidを取得出来ませんでした。")
        }
        return db.collection("ImageData").document(uid).collection("Image")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
