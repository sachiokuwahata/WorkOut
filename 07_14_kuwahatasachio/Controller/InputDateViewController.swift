//
//  InputDateViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/03/03.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class InputDateViewController: UIViewController {

    var yymmdd = String()
    let dateFormat = DateFormatter()
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBAction func didDateButton(_ sender: Any) {
        
        dateFormat.dateFormat = "yyyy年MM月dd日"
        self.yymmdd = dateFormat.string(from: datePickerView.date)
        print(self.yymmdd)
        
//        let RecordLogVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordLogVC") as! RecordLogViewController
//        RecordLogVC.Today = self.yymmdd
        UserDefaults.standard.set(self.yymmdd, forKey: "selectDate")

        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
