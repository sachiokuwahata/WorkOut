//
//  TotalingViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/24.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase

class TotalingViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    var userName = String()

    var totals = [Toatal]()
    var totaln = Toatal()

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
    
    private func prepareData() {
        let Dic = Dictionary(grouping: PostController.shared.posts, by: { $0.menu })
        print(Dic)
        let menukeys = [String](Dic.keys)
        if menukeys == nil { return }
        
        print(menukeys)

        self.totals = [Toatal]()

        for menukey in menukeys {
            self.totaln = Toatal()

            var totalnumber: Int = 0

            let menuNumCount = Dic[menukey]?.count as! Int
            for i in 0..<menuNumCount{
//                print("menukey: \(menukey)")
//                print("Dic[menukey]: \(String(describing: Dic[menukey]?[i])) + / + \(i)")
//                print("Dic[menukey]number: \(String(describing: Dic[menukey]?[i].number))")
                
                totalnumber = totalnumber + Int((Dic[menukey]?[i].number)!)!
            }

            self.totaln.menu = menukey
            self.totaln.number = totalnumber
            self.totals.append(self.totaln)
//            print("self.totaln.menu: \(self.totaln.menu) + / +  \(self.totaln.number)")
            self.tableview.reloadData()
        }

        
    }
    
    func fetchPost() {
        
        PostController.shared.posts = [Post]()
        PostController.shared.posst =  Post()
        let ref = Database.database().reference().child("postdata").child("\(String(describing: self.userName))")
        
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
     self.prepareData()
     self.tableview.reloadData()
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchPost()
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
    


}
