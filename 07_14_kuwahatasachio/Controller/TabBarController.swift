//
//  TabBarController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/25.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController , UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        let firstViewController  = self.viewControllers![0]
        let secondViewController = self.viewControllers![1]
        let thirdViewController = self.viewControllers![2]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is RecordPhotoViewController {
            if let newVC =  tabBarController.storyboard?.instantiateViewController(withIdentifier: "RecordPhotoVC"){ //withIdentifier: にはStory Board IDを設定
                tabBarController.present(newVC, animated: true, completion: nil)//newVCで設定したページに遷移
                return false
            }
        }
        return true
    }

}
