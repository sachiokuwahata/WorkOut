//
//  EditViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import SDWebImage

class EditViewController: UIViewController {
    
    var userName = String()
    
    //データの取得
    var indexpath = Int()
    var menu = String()
    var date = String()
    var number = String()
    var weight = String()
    var key = String()
//    var data = NSData()
    var imageData = NSData()
    
    @IBOutlet weak var menuTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var pickedImageView: UIImageView!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(menuTextField.isFirstResponder){
            menuTextField.resignFirstResponder()
        } else if(numberTextField.isFirstResponder){
            numberTextField.resignFirstResponder()
        } else if(weightTextField.isFirstResponder){
            weightTextField.resignFirstResponder()
        } else if(dateTextField.isFirstResponder){
            dateTextField.resignFirstResponder()
        }
    }
    
    
    @IBAction func editButton(_ sender: Any) {

        let menu = menuTextField.text
        let number = numberTextField.text
        let weight = weightTextField.text
        let date = dateTextField.text
        let userName = self.userName
        let keys = self.key
        
        RecordViewController.shared.dataSet(date: date!,weight: weight!,number: number!,menu: menu!,keys: keys,userName:userName)

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func deleteButton(_ sender: Any) {

        let userName = self.userName
        let keys = self.key
        
        DeleteViewController.shared.datadelete(keys: keys,userName:userName)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let user = User.shared.firebaseAuth.currentUser?.uid {
            self.userName = user
        }

        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTextField.text = menu
        numberTextField.text = number
        weightTextField.text = weight
        dateTextField.text = date
        pickedImageView.image = UIImage(data: imageData as! Data)
    }
    

}
