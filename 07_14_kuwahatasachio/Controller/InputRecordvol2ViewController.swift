//
//  InputRecordvol2ViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/23.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class InputRecordvol2ViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    

    @IBOutlet weak var pickerview2: UIPickerView!

    let dataList_array1 = ["","自重","5","10","15","20","25","30","35","40","45","50","55","60"]
    let dataList_array2 = ["","5","10","15","20","25","30","35","40"]
    
    var selectNumber = String()
    var selectWeight = String()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.dataList_array1.count
        } else {
            return self.dataList_array2.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return self.dataList_array1[row]
        } else {
            return self.dataList_array2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.selectWeight = self.dataList_array1[row]
            print(self.dataList_array1[row])
        } else {
            self.selectNumber = self.dataList_array2[row]
            print(self.dataList_array2[row])
        }
    }
    
    
    @IBAction func ok(_ sender: Any) {
        
        UserDefaults.standard.set(self.selectNumber, forKey: "selectNumber")
        UserDefaults.standard.set(self.selectWeight, forKey: "selectWeight")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerview2.delegate = self
        pickerview2.dataSource = self
//        pickerview2.tag = 2
//        pickerview2.selectRow(0, inComponent: 0, animated: true) // 初期値
        pickerview2.selectRow(0, inComponent: 0, animated: true)
        pickerview2.selectRow(0, inComponent: 1, animated: true)
        
        
    }
    
}
