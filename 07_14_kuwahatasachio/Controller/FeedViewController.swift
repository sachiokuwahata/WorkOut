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

class FeedViewController: UIViewController ,UICollectionViewDataSource ,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    var displayName = String()
    var userName = String()
    
    var menuDateKeys = [String]()
    var imageKyes: [String: String] = [:]
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    let refreshController = UIRefreshControl()
    
    //Firestore
    let db = Firestore.firestore()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuDateKeys.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let ImageView = cell.viewWithTag(1) as! UIImageView
        let Label = cell.viewWithTag(2) as! UILabel

        Label.text = self.menuDateKeys[indexPath.row]
        
        if let stringurl = self.imageKyes[self.menuDateKeys[indexPath.row]] {
            let imageurl = URL(string:stringurl)
            ImageView.sd_setImage(with: imageurl, completed: nil)
            ImageView.layer.cornerRadius = 8.0
            ImageView.clipsToBounds = true
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dateData = self.menuDateKeys[indexPath.row]
        let postFilter = PostController.shared.posts.filter({$0.date == dateData})
        
        PostController.shared.selectedPost = postFilter
        
        let didSelectMenuVc = self.storyboard?.instantiateViewController(withIdentifier: "didSelectMenuVc") as! didSelectMenuVcViewController
        
        didSelectMenuVc.title = "\(dateData)のMenu"
        self.navigationController?.pushViewController(didSelectMenuVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 2
        let cellSize:CGFloat = self.view.bounds.width/2 - horizontalSpace
        let textLabelSpace:CGFloat = 6
        let cellSizeHight:CGFloat = cellSize + textLabelSpace
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSizeHight)
        
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
                                self.collectionview.reloadData()
                            }
                        }
                }
            }
        }
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Facebook処理
        if let user = User.shared.firebaseAuth.currentUser?.uid {
            self.userName = user
        }

        // Facebook処理
        if let dName = User.shared.firebaseAuth.currentUser?.displayName {
            self.displayName = dName
        }
        self.fetchFirestore()
        collectionview.reloadData()
    }

    
    func Calculation() {
        
        let DicMenu = Dictionary(grouping: PostController.shared.posts, by: { $0.date })

        self.menuDateKeys = [String](DicMenu.keys)
        if menuDateKeys == [] { return }
        print("BeforeMenuDate: \(self.menuDateKeys)")
        
        self.menuDateKeys.sort(by: {$0 > $1})
        print("AfterMenuDate: \(self.menuDateKeys)")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.delegate = self
        collectionview.dataSource = self
        refreshController.attributedTitle = NSAttributedString(string: "引っ張って更新")
        refreshController.addTarget(self, action: #selector(reflesh), for: .valueChanged)
        collectionview.addSubview(refreshController)
        
    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let LogoutVC = storyboardMain.instantiateViewController(withIdentifier: "LogoutVC")
        self.present(LogoutVC, animated: true, completion: nil)
    }
    
    @objc func reflesh() {
        self.fetchFirestore()
        collectionview.reloadData()
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
