//
//  FeedViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UICollectionViewDataSource ,UICollectionViewDelegate{
    
    var displayName = String()
    var userName = String()
    
    var menuDateKeys = [String]()
    var imageKyes: [String: String] = [:]
    
    let Mon = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var collectionview: UICollectionView!
    
    let refreshController = UIRefreshControl()
    
    //Firestore
    let db = Firestore.firestore()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuDateKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let dateTextLabel = cell.viewWithTag(5) as! UILabel
        let nameTextLabel = cell.viewWithTag(6) as! UILabel

        dateTextLabel.text = self.menuDateKeys[indexPath.row]
        nameTextLabel.text = self.displayName
        
        
        if let stringurl = self.imageKyes[self.menuDateKeys[indexPath.row]] {
            let imageurl = URL(string:stringurl)
            imageView.sd_setImage(with: imageurl, completed: nil)
            imageView.layer.cornerRadius = 8.0
            imageView.clipsToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateData = self.menuDateKeys[indexPath.row]
        let postFilter = PostController.shared.posts.filter({$0.date == dateData})

        PostController.shared.selectedPost = postFilter
        
        print("SelectedPost: \(PostController.shared.selectedPost)")
        let didSelectMenuVc = self.storyboard?.instantiateViewController(withIdentifier: "didSelectMenuVc") as! didSelectMenuVcViewController
        self.navigationController?.pushViewController(didSelectMenuVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Mon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let Label = cell.viewWithTag(1) as! UILabel
        let mm = Mon[indexPath.row]
        Label.text = "\(mm)月"
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Month.shared.mm = Mon[indexPath.row]
        self.fetchFirestore()
    }
    
    @objc func edit(_ sender:TableButton){
        print(sender.indexpath)
        
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "editVC") as! EditViewController

        // editVCへ編集データの受け渡し
        editVC.indexpath = sender.indexpath! // Int()
        editVC.menu = sender.menu! // String()
        editVC.date = sender.date! // String()
        editVC.number = sender.number! // String()
        editVC.weight = sender.weight! // String()
        editVC.key = sender.key! // String()
//        editVC.imageData = sender.imageData! // NSData()
        
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    func fetchPost() {
        PostController.shared.posts = [Post]()
        PostController.shared.posst =  Post()
        let ref = Database.database().reference().child("postdata").child("\(self.userName)")
        let refImage = Database.database().reference().child("imageData").child("\(self.userName)")
        
        ref.observeSingleEvent(of: .value) { (snap,error) in
            let postsnap = snap.value as? [String:NSDictionary]
            if postsnap == nil {
                return
            }
            
            for (_,post) in postsnap! {
                PostController.shared.posst = Post()
                
                if let date = post["date"] as! String?, let weight = post["weight"] as! String?, let number = post["number"] as! String?, let menu = post["menu"]  as! String?,let key = post["key"] as! String?{
                    
                    PostController.shared.posst.date = date
                    PostController.shared.posst.weight = weight
                    PostController.shared.posst.number = number
                    PostController.shared.posst.menu = menu
                    PostController.shared.posst.key = key                    
                }
                PostController.shared.posts.append(PostController.shared.posst)
            }
            refImage.observeSingleEvent(of: .value) { (snap,error) in
                let postsnap = snap.value as? [String:NSDictionary]
                if postsnap == nil {
                    return
                }
                
                for (_,post) in postsnap! {
                    if let date = post["date"] as! String?, let imageData = post["imageData"] as! String?{
                        self.imageKyes[date] = imageData
                    }
                }
                self.Calculation()
                self.tableview.reloadData()
            }
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

                        if let date = post["date"] as! String?, let weight = post["weight"] as! String?, let number = post["number"] as! String?, let menu = post["menu"]  as! String?,let key = post["key"] as! String?,let month = post["month"] as! String?{
                            
                            PostController.shared.posst.date = date
                            PostController.shared.posst.weight = weight
                            PostController.shared.posst.number = number
                            PostController.shared.posst.menu = menu
                            PostController.shared.posst.key = key
                            PostController.shared.posst.month = month
                        }
                        PostController.shared.posts.append(PostController.shared.posst)
                    })
                        refImage.getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                if let documents = querySnapshot?.documents {
                                    documents.forEach({ (document) in
                                        let post = document.data()
                                        
                                        if let date = post["date"] as! String?, let imageData = post["imageData"] as! String?{
                                            self.imageKyes[date] = imageData
                                            }
                                        }
                                    )}
                                self.Calculation()
                                self.tableview.reloadData()
                            }
                        }
                }
            }
        }
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Month.shared.mm = "02"
        
        // Facebook処理
        if let user = User.shared.firebaseAuth.currentUser?.uid {
            self.userName = user
        }

        // Facebook処理
        if let dName = User.shared.firebaseAuth.currentUser?.displayName {
            self.displayName = dName
        }
        self.fetchFirestore()
        tableview.reloadData()
    }

    
    func Calculation() {
        
        PostController.shared.mmPost = PostController.shared.posts.filter({$0.month == Month.shared.mm})
        print("mmposts: \(PostController.shared.mmPost)")
        
//        let DicMenu = Dictionary(grouping: PostController.shared.posts, by: { $0.date })
        let DicMenu = Dictionary(grouping: PostController.shared.mmPost, by: { $0.date })

        self.menuDateKeys = [String](DicMenu.keys)
        if menuDateKeys == [] { return }
        print("MenuDate: \(self.menuDateKeys)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        collectionview.delegate = self
        collectionview.dataSource = self
        
        refreshController.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshController.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        tableview.addSubview(refreshController)
        
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let LogoutVC = storyboardMain.instantiateViewController(withIdentifier: "LogoutVC")
        self.present(LogoutVC, animated: true, completion: nil)
    }
    
    @objc func reflesh() {
        self.fetchFirestore()
        tableview.reloadData()
        refreshController.endRefreshing()
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
