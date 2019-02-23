//
//  DeleteViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase

class DeleteViewController: UIViewController {

    static let shared = DeleteViewController()

    
    func datadelete(keys: String,userName:String) {
        
        let key = keys as? String
        let rootref = Database.database().reference(fromURL: "https://muscleshow-b3569.firebaseio.com/").child("postdata").child("\(userName)").child("\(key)")
        
        rootref.removeValue()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
