
//
//  RecordTrainingViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/22.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class RecordTrainingViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
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


    @IBOutlet weak var menuTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var TodayDate: UILabel!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(menuTextField.isFirstResponder){
            menuTextField.resignFirstResponder()
        } else if(numberTextField.isFirstResponder){
            numberTextField.resignFirstResponder()
        } else if(weightTextField.isFirstResponder){
            weightTextField.resignFirstResponder()
        }
    }
    
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
    
    
    @IBAction func addDataButton(_ sender: Any) {
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
        
        menuTextField.text = UserDefaults.standard.object(forKey: "selectMenu") as! String
        weightTextField.text = UserDefaults.standard.object(forKey: "selectWeight") as! String
        numberTextField.text = UserDefaults.standard.object(forKey: "selectNumber") as! String
        
        
        print(self.posts)
        self.tableview.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Facebookｂ認証
        if let user = User.shared.firebaseAuth.currentUser?.uid {
            self.userName = user
        }
        
        menuText = UserDefaults.standard.object(forKey: "selectMenu") as! String
        weightText = UserDefaults.standard.object(forKey: "selectWeight") as! String
        numberText = UserDefaults.standard.object(forKey: "selectNumber") as! String
        dateText = UserDefaults.standard.object(forKey: "selectDate") as! String
        
        menuTextField.text = menuText
        weightTextField.text = weightText
        numberTextField.text = numberText
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        pickedImageView.image = image
        
        TodayDate.text = Today
        
        if let image = pickedImageView.image {
            self.data = image.jpegData(compressionQuality: 0.01)! as NSData
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "celladd", for: indexPath)
        
        let menuLabel = cell.viewWithTag(1) as! UILabel
        let weightLabel = cell.viewWithTag(2) as! UITextField
        let numberLabel = cell.viewWithTag(3) as! UITextField
        
        menuLabel.text = self.posts[indexPath.row].menu
        weightLabel.text = self.posts[indexPath.row].weight
        numberLabel.text = self.posts[indexPath.row].number
        
        return cell
    }

    var selectNumber = String()
    var selectWeight = String()
    
    @IBAction func numberButton(_ sender: Any) {
        let inputRecordvol2 = storyboard!.instantiateViewController(withIdentifier: "inputRecordvol2")
        self.present(inputRecordvol2,animated: true, completion: nil)
    }
    
    @IBAction func menuButton(_ sender: Any) {
        let inputMenu = storyboard!.instantiateViewController(withIdentifier: "inputMenu")
        self.present(inputMenu,animated: true, completion: nil)
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
