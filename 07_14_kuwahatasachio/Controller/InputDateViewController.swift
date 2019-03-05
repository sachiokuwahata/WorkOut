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
        
//        UserDefaults.standard.set(self.yymmdd, forKey: "selectDate")
        PostController.shared.inputPost.date = self.yymmdd

        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
