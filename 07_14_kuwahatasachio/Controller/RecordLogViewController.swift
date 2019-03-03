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
        print("imageviewTAp")
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
        self.Today = UserDefaults.standard.object(forKey: "selectDate") as! String
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
        //self.navigationController?.popViewController(animated: true)
        self.tabBarController!.selectedIndex = 0
        self.posts = [Post]()
        
//        self.navigationController?.popToRootViewController(animated: true)

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
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:break
            case .denied:break
            case .notDetermined:break
            case .restricted:break
            }
        }
        UserDefaults.standard.set("0", forKey: "selectWeight")
        UserDefaults.standard.set("0", forKey: "selectNumber")
        UserDefaults.standard.set("---------", forKey: "selectMenu")
        UserDefaults.standard.set("yyyy年mm月dd日", forKey: "selectDate")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 355
        }
        return 95
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)

            let dateLabel = cell.viewWithTag(1) as! UILabel
            let dateButton = cell.viewWithTag(8) as! UIButton
            let menuButton = cell.viewWithTag(2) as! UIButton
            let menuTextField = cell.viewWithTag(3) as! UITextField
            let logButton = cell.viewWithTag(4) as! UIButton
            let weightTextField = cell.viewWithTag(5) as! UITextField
            let numberTextField = cell.viewWithTag(6) as! UITextField
            let addButton = cell.viewWithTag(7) as! UIButton
            
            menuButton.addTarget(self, action: #selector(menuPutButton), for: .touchUpInside)
            logButton.addTarget(self, action: #selector(logPutButton), for: .touchUpInside)
            addButton.addTarget(self, action: #selector(addDataButton), for: .touchUpInside)
            dateButton.addTarget(self, action: #selector(dateLogButton), for: .touchUpInside)
            
            dateText = UserDefaults.standard.object(forKey: "selectDate") as! String
            menuText = UserDefaults.standard.object(forKey: "selectMenu") as! String
            weightText = UserDefaults.standard.object(forKey: "selectWeight") as! String
            numberText = UserDefaults.standard.object(forKey: "selectNumber") as! String
            
            dateLabel.text = dateText
            menuTextField.text = menuText
            weightTextField.text = weightText
            numberTextField.text = numberText
            
            return cell
        }
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        let menuLabel = cell.viewWithTag(1) as! UILabel
        let weightLabel = cell.viewWithTag(2) as! UITextField
        let numberLabel = cell.viewWithTag(3) as! UITextField
        
        let row = indexPath.row - 1
        menuLabel.text = self.posts[row].menu
        weightLabel.text = self.posts[row].weight
        numberLabel.text = self.posts[row].number
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.row {
        case 0:
            return nil
        default:
            return indexPath
        }
    }

    @objc func dateLogButton(_ sender: Any) {
        print("datebutton")
        let inputDateVC = storyboard!.instantiateViewController(withIdentifier: "inputDateVC")
        self.present(inputDateVC,animated: true, completion: nil)
    }

    
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
        
        self.posst.date = UserDefaults.standard.object(forKey: "selectDate") as! String
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

        guard self.imageChanged else {
            let title:String = "画像を追加して下さい。"
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
