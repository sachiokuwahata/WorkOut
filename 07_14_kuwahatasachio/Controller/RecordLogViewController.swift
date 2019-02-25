//
//  RecordLogViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/25.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class RecordLogViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    var posts = [Post]()
    var posst = Post()
    var data:NSData = NSData()
    var Today = String()
    
    var userName = String()
    var image = UIImage()
    
    var weightText = String()
    var numberText = String()
    var menuText = String()
    var dateText = String()
    
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func saveButton(_ sender: Any) {
        
        let userName = self.userName
        let keys = "damyy"
        
        for post in posts {
            
            let menu = post.menu
            let number = post.number
            let weight = post.weight
            let date = post.date
            
            RecordViewController.shared.dataSet(date: date,weight: weight,number: number,menu: menu,keys: keys,userName:userName)
        }
        
        RecordViewController.shared.imageSet(date: self.Today, userName:self.userName, imageData:data)        
        self.navigationController?.popViewController(animated: true)
        self.tabBarController!.selectedIndex = 2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Facebookｂ認証
        if let user = User.shared.firebaseAuth.currentUser?.uid {
            self.userName = user
        }

        tableview.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self

        self.data = self.image.jpegData(compressionQuality: 0.01)! as NSData
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 290
        } else if indexPath.row == 1 {
            return 355
        }
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
            
            cell.imageView?.image = self.image
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)

            let dateLabel = cell.viewWithTag(1) as! UILabel
            let menuButton = cell.viewWithTag(2) as! UIButton
            let menuTextField = cell.viewWithTag(3) as! UITextField
            let logButton = cell.viewWithTag(4) as! UIButton
            let weightTextField = cell.viewWithTag(5) as! UITextField
            let numberTextField = cell.viewWithTag(6) as! UITextField
            let addButton = cell.viewWithTag(7) as! UIButton
            
            dateLabel.text = self.Today
            menuButton.addTarget(self, action: #selector(menuPutButton), for: .touchUpInside)
            logButton.addTarget(self, action: #selector(logPutButton), for: .touchUpInside)
            addButton.addTarget(self, action: #selector(addDataButton), for: .touchUpInside)

            menuText = UserDefaults.standard.object(forKey: "selectMenu") as! String
            weightText = UserDefaults.standard.object(forKey: "selectWeight") as! String
            numberText = UserDefaults.standard.object(forKey: "selectNumber") as! String
            dateText = UserDefaults.standard.object(forKey: "selectDate") as! String
            
            menuTextField.text = menuText
            weightTextField.text = weightText
            numberTextField.text = numberText
            
            return cell
        }
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        let menuLabel = cell.viewWithTag(1) as! UILabel
        let weightLabel = cell.viewWithTag(2) as! UITextField
        let numberLabel = cell.viewWithTag(3) as! UITextField
        
        let row = indexPath.row - 2
        menuLabel.text = self.posts[row].menu
        weightLabel.text = self.posts[row].weight
        numberLabel.text = self.posts[row].number
        
        return cell
    }
    
    var selectNumber = String()
    var selectWeight = String()
    
    @objc func logPutButton(_ sender: Any) {
        let inputRecordvol2 = storyboard!.instantiateViewController(withIdentifier: "inputRecordvol2")
        self.present(inputRecordvol2,animated: true, completion: nil)
    }
    
    @objc func menuPutButton(_ sender: Any) {
        let inputMenu = storyboard!.instantiateViewController(withIdentifier: "inputMenu")
        self.present(inputMenu,animated: true, completion: nil)
    }
    
    @objc func addDataButton(_ sender: Any) {
        self.posst = Post()
        
        self.posst.date = self.Today
        self.posst.weight = self.weightText
        self.posst.number = self.numberText
        self.posst.menu = self.menuText
        
        guard self.validate() else {
            return
        }
        
        self.posts.append(self.posst)
        
        UserDefaults.standard.set("0", forKey: "selectWeight")
        UserDefaults.standard.set("0", forKey: "selectNumber")
        UserDefaults.standard.set("---------", forKey: "selectMenu")
        
        print(self.posts)
        self.tableview.reloadData()
    }

    
    private func validate() -> Bool {
        
        guard self.posst.weight != "0", self.posst.weight != "" else {
            let title:String = "重さを入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        guard self.posst.number != "0", self.posst.number != "" else {
            let title:String = "数字を入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        guard self.posst.menu != "---------", self.posst.number != "" else {
            let title:String = "メニューを入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        return true
    }

}
