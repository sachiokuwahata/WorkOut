//
//  RecordDateViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/20.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class RecordDateViewController: UIViewController {
    
    var yymmdd = String()
    let dateFormat = DateFormatter()
    
    @IBOutlet weak var datepickerview: UIDatePicker!
    
    @IBAction func dateDecideButton(_ sender: Any) {
        dateFormat.dateFormat = "yyyy年MM月dd日"
        self.yymmdd = dateFormat.string(from: datepickerview.date)
        print(self.yymmdd)
       
        let RecordPhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "RecordPhotoVC") as! RecordPhotoViewController
        RecordPhotoVC.Today = self.yymmdd        
        self.navigationController?.pushViewController(RecordPhotoVC, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

}
