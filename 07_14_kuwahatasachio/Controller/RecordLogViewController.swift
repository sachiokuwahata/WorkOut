//
//  RecordLogViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/25.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Photos

class RecordLogViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UINavigationControllerDelegate ,UIImagePickerControllerDelegate{
    
    var posts = [Post]()
    var posst = Post()

    var data:NSData = NSData()
    var Today = String()
    
    var TodayYMD = [String]()
    
    var userName = String()
    var image = UIImage()
    var mainImage = UIImage()
    var imageChanged:Bool = false
    
    var weightText = String()
    var numberText = String()
    var menuText = String()
    var dateText = String()
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBAction func tapImageView(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "選択してください", preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "カメラ", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            print("カメラ")
            self.presentPicker(souceType: .camera)
            
        }))
        alert.addAction(UIAlertAction(title: "アルバム", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            print("アルバム")
            self.presentPicker(souceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPicker(souceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(souceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = souceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            print ("The SouceType is not found.")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedimage = info[.editedImage] as? UIImage {
            mainImageView.contentMode = .scaleAspectFit
            self.mainImage = pickedimage
            mainImageView.image = self.mainImage
            self.data = self.mainImage.jpegData(compressionQuality: 0.01)! as NSData
            self.imageChanged = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func saveButton(_ sender: Any) {
        
        let userName = self.userName
        let keys = "damyy"

        self.TodayYMD = (self.Today.components(separatedBy: NSCharacterSet.decimalDigits.inverted))
        
        for post in posts {
            
            let date = post.date
            let menu = post.menu
            let number = post.number
            let weight = post.weight
            
            let year = TodayYMD[0]
            let month = TodayYMD[1]
            let day = TodayYMD[2]
            
            RecordViewController.shared.dataSet(date: date,weight: weight,number: number,menu: menu,keys: keys,userName:userName,year:year,month:month,day:day)
        }
        
        RecordViewController.shared.imageSet(date: self.Today, userName:self.userName, imageData:data)

        self.tabBarController!.selectedIndex = 0
        self.posts = [Post]()
        PostController.shared.inputPost = Post()
        
        //imageView初期化
        self.imageChanged = false
        mainImageView.image = UIImage.init(named: "NotImage")
        
        
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
        
        PostController.shared.inputPost = Post()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:break
            case .denied:break
            case .notDetermined:break
            case .restricted:break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else if indexPath.row == 1 {
            return 70
        } else if indexPath.row == 2 {
            return 70
        } else if indexPath.row == 3 {
            return 70
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "TextLabelCell", for: indexPath)
            
            let Label = cell.viewWithTag(1) as! UILabel
            
            if PostController.shared.inputPost.date == "" {
                Label.text = "日付けを入力して下さい"
                Label.textColor = UIColor.lightGray
                return cell
            } else {
                Label.text = PostController.shared.inputPost.date
                Label.textColor = UIColor.black
            }
                return cell
        } else if indexPath.row == 1 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "TextLabelCell", for: indexPath)
            
            let Label = cell.viewWithTag(1) as! UILabel
            
            if PostController.shared.inputPost.menu == "" {
                Label.text = "メニューけを入力して下さい"
                Label.textColor = UIColor.lightGray
                return cell
            } else {
                Label.text = PostController.shared.inputPost.menu
                Label.textColor = UIColor.black
            }
            return cell

        } else if indexPath.row == 2 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "TextLabelCell", for: indexPath)
            
            let Label = cell.viewWithTag(1) as! UILabel
            
            if PostController.shared.inputPost.weight == "",PostController.shared.inputPost.number == "" {
                Label.text = "重量 × 回数を入力して下さい"
                Label.textColor = UIColor.lightGray
                return cell
            } else {
                Label.text = "\(PostController.shared.inputPost.weight) Kg × \(PostController.shared.inputPost.number) 回"
                Label.textColor = UIColor.black
            }
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
            
            let addButton = cell.viewWithTag(1) as! UIButton
            addButton.addTarget(self, action: #selector(addDataButton), for: .touchUpInside)
            
            return cell
            
        }
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        let menuLabel = cell.viewWithTag(1) as! UILabel
        let weightLabel = cell.viewWithTag(2) as! UITextField
        let numberLabel = cell.viewWithTag(3) as! UITextField
        
        let row = indexPath.row - 4
        menuLabel.text = self.posts[row].menu
        weightLabel.text = self.posts[row].weight
        numberLabel.text = self.posts[row].number
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        switch indexPath.row {
//        case 0:
//            return nil
//        default:
//            return indexPath
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let inputDateVC = storyboard!.instantiateViewController(withIdentifier: "inputDateVC")
            self.present(inputDateVC,animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let inputMenu = storyboard!.instantiateViewController(withIdentifier: "inputMenu")
            self.present(inputMenu,animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let inputRecordvol2 = storyboard!.instantiateViewController(withIdentifier: "inputRecordvol2")
            self.present(inputRecordvol2,animated: true, completion: nil)
        }
            
        tableview.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row != 0 else {
            return
        }
        guard indexPath.row != 1 else {
            return
        }
        guard indexPath.row != 2 else {
            return
        }
        guard indexPath.row != 3 else {
            return
        }

        if editingStyle == .delete {
            let row = indexPath.row - 4
            posts.remove(at: row)
            tableview.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    @objc func addDataButton(_ sender: Any) {
        self.posst = Post()
        
        self.posst.date = PostController.shared.inputPost.date
        self.posst.weight = PostController.shared.inputPost.weight
        self.posst.number = PostController.shared.inputPost.number
        self.posst.menu = PostController.shared.inputPost.menu

        
        guard self.validate() else {
            return
        }
        
        self.posts.append(self.posst)
        
        // inputPostのリセット化
        self.Today = PostController.shared.inputPost.date
        PostController.shared.inputPost = Post()
        PostController.shared.inputPost.date = self.Today
        
        print(self.posts)
        self.tableview.reloadData()
    }

    
    private func validate() -> Bool {

        guard self.imageChanged else {
            let title:String = "画像を追加して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }

        guard self.posst.date != "日付", self.posst.date != "" else {
            let title:String = "日付を入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        guard self.posst.weight != "0", self.posst.weight != "" else {
            let title:String = "重さを入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        guard self.posst.number != "0", self.posst.number != "" else {
            let title:String = "回数を入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        guard self.posst.menu != "" else {
            let title:String = "メニューを入力して下さい。"
            let message:String = ""
            displayAlert(title: title, message: message)
            return false
        }
        
        return true
    }

}
