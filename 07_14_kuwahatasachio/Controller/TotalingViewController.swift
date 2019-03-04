//
//  TotalingViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/24.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TotalingViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var userName = String()
    var menuKeyssss = [String]()
    
    var totals = [Toatal]()
    var totaln = Toatal()

    //Firestore
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "totalcell", for: indexPath)
        
        let menuLabel = cell.viewWithTag(1) as! UILabel
        let intLabel = cell.viewWithTag(2) as! UILabel
        
        menuLabel.text = totals[indexPath.row].menu
        intLabel.text = String(totals[indexPath.row].number)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectMenu = self.menuKeyssss[indexPath.row]
        var postFilter = PostController.shared.posts.filter({$0.menu == selectMenu})
        postFilter = postFilter.sorted(by:{$0.date > $1.date})
        PostController.shared.menuSelectPost = postFilter
        print("SelectedPost: \(PostController.shared.menuSelectPost)")
        
        let didSelectMenuVcVol2 = self.storyboard?.instantiateViewController(withIdentifier: "didSelectMenuVcVol2") as! didSelectMenuVcVol2ViewController
        self.navigationController?.pushViewController(didSelectMenuVcVol2, animated: true)

        tableview.deselectRow(at: indexPath, animated: true)

    }
    
    private func prepareData() {
        let Dic = Dictionary(grouping: PostController.shared.posts, by: { $0.menu })
        let menukeys = [String](Dic.keys)
        self.menuKeyssss = [String](Dic.keys)
        if menukeys == [] { return }
        print("menukeys: \(menukeys)")

        self.totals = [Toatal]()

        for menukey in menukeys {
            self.totaln = Toatal()
            var totalnumber: Int = 0
            
            if let menuNumCount = Dic[menukey]?.count {
                for i in 0..<menuNumCount{
                    totalnumber = totalnumber + Int((Dic[menukey]?[i].number)!)!
                }
            }   
            self.totaln.menu = menukey
            self.totaln.number = totalnumber
            self.totals.append(self.totaln)
            self.tableview.reloadData()
        }
    }
    
    // Firestore
    func fetchFirestore() {
        
        PostController.shared.posts = [Post]()
        PostController.shared.posst =  Post()
        
        guard let uid = User.shared.getUid() else {
            fatalError("Uidを取得出来ません。")
        }
        
        let ref = self.getMenuCollectionRef()
        let refImage = self.getImageDocumentRef()
        
        
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let documents = querySnapshot?.documents {
                    documents.forEach({ (document) in
                        
                        PostController.shared.posst = Post()
                        let post = document.data()
                        
                        if let date = post["date"] as! String?, let weight = post["weight"] as! String?, let number = post["number"] as! String?, let menu = post["menu"]  as! String?,let key = post["key"] as! String?{
                            
                            PostController.shared.posst.date = date
                            PostController.shared.posst.weight = weight
                            PostController.shared.posst.number = number
                            PostController.shared.posst.menu = menu
                            PostController.shared.posst.key = key
                        }
                        PostController.shared.posts.append(PostController.shared.posst)
                    })
                    self.prepareData()
                    self.tableview.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchFirestore()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Facebook処理
        if let user = User.shared.firebaseAuth.currentUser?.uid {
            self.userName = user
        }
        
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
