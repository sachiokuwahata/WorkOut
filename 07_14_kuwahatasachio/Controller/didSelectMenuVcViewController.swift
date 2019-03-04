//
//  didSelectMenuVcViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase

class didSelectMenuVcViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var tableview: UITableView!
    
    //Firestore
    let db = Firestore.firestore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.selectedPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let MenuTextLabel = cell.viewWithTag(1) as! UILabel
        let WeightTextLabel = cell.viewWithTag(2) as! UILabel
        let NumberTextLabel = cell.viewWithTag(3) as! UILabel
        
        MenuTextLabel.text = PostController.shared.selectedPost[indexPath.row].menu
        WeightTextLabel.text = PostController.shared.selectedPost[indexPath.row].weight
        NumberTextLabel.text = PostController.shared.selectedPost[indexPath.row].number
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = PostController.shared.selectedPost[indexPath.row].key
        print("key: \(key)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let key = PostController.shared.selectedPost[indexPath.row].key
            guard key != nil else {
                print("key is nil");
                return
            }
            
            let ref = self.getMenuCollectionRef()
            ref.document(key).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            PostController.shared.selectedPost.remove(at: indexPath.row)
            tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
    }

    // Firestore
    private func getMenuCollectionRef() -> CollectionReference {
        guard let uid = User.shared.getUid() else {
            fatalError ("Uidを取得出来ませんでした。")
        }
        return db.collection("PostData").document(uid).collection("Menu")
    }
    
    // Firestore
    private func getImageDocumentRef() -> CollectionReference {
        guard let uid = User.shared.getUid() else {
            fatalError ("Uidを取得出来ませんでした。")
        }
        return db.collection("ImageData").document(uid).collection("Image")
    }

    
}
