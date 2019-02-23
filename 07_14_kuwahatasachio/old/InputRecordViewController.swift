//
//  InputRecordViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/23.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class InputRecordViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{

    
    @IBOutlet weak var pickerview1: UIPickerView!    
    
    let dataList_array1 = ["5","10","15","20","25","30","35","40"]
    let dataList_array2 = ["1","2","3","4","5","6","7","8","9","10"]
    
    var selectNumber = String()
    var selectWeight = String()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerview1.tag == 1 {
            return self.dataList_array1.count
        } else {
            return self.dataList_array2.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerview1.tag == 1 {
            return self.dataList_array1[row]
        } else {
            return self.dataList_array2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerview1.tag == 1 {
            self.selectWeight = self.dataList_array1[row]
            print(self.dataList_array2[row])
        } else {
            self.selectNumber = self.dataList_array2[row]
            print(self.dataList_array2[row])
        }
    }
    

    
    
    @IBAction func ok(_ sender: Any) {

        if self.presentingViewController is UINavigationController {
            let nc = self.presentingViewController as! UINavigationController
            
            let vc = nc.topViewController as! RecordTrainingViewController
            vc.menuTextField.text = "スクワット"
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
//        if let navigationController = self.presentingViewController as? UINavigationController,
//            let menuVC = navigationController.topViewController as? RecordMenuViewController {
////            controller.doAnything()
//            menuVC.weightText = self.selectWeight
//            menuVC.dismiss(animated: true, completion: nil)
//        }

        
//        let menuVC = self.presentingViewController as! RecordMenuViewController
//        menuVC.weightText = self.selectWeight
//        UserDefaults.standard.set(self.selectWeight, forKey: "selectWeight")
//        print("self.selectWeight:\(self.selectWeight)")
//        self.dismiss(animated: true, completion: nil)

        
//        let menuVC:RecordMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! RecordMenuViewController
//    self.navigationController?.popViewController(animated: true)
        
//        self.navigationController?.pushViewController(menuVC, animated: true)
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerview1.delegate = self
        pickerview1.dataSource = self
        pickerview1.tag = 1
        pickerview1.selectRow(0, inComponent: 0, animated: true) // 初期値

    }
    

}
