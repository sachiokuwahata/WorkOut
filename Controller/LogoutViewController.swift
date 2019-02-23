//
//  LogoutViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/15.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LogoutViewController: UIViewController ,FBSDKLoginButtonDelegate , UserDelegate{
    func loginLoad() {
        self.showIndicator()
    }
    

    func loginTrans(error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }


    let fbLoginBtn = FBSDKLoginButton()

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error")
            return
        }
        // ログイン時の処理
        User.shared.fblogin()
    }
    // FBButtonでのLogout完了後に実行
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        do {
            try User.shared.firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        User.shared.delegate = self

        self.fbLoginBtn.delegate = self
        self.fbLoginBtn.readPermissions = ["public_profile", "email"]
        self.fbLoginBtn.center = self.view.center
        self.view.addSubview(self.fbLoginBtn)

    }


}
