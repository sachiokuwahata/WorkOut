//
//  ViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController ,FBSDKLoginButtonDelegate, UserDelegate{
    func loginLoad() {
        self.showIndicator()
    }

    func loginTrans(error: Error?) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    // FBButtonの作成
    let fbLoginBtn = FBSDKLoginButton()
    
    // FBButtonでのLogin完了後に実行
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
        
        self.showIndicator()
        
        if User.shared.firebaseAuth.currentUser?.uid == nil {

            self.hideIndicator()

            self.fbLoginBtn.delegate = self
            self.fbLoginBtn.readPermissions = ["public_profile", "email"]
            self.fbLoginBtn.center = self.view.center
            self.view.addSubview(self.fbLoginBtn)
        }

        User.shared.delegate = self
        User.shared.fblogin()
    }

// FacebookLoginとFirebaseLoginの違いを理解するCheck
//    @IBAction func checkButton(_ sender: Any) {
//        let tokennn = FBSDKAccessToken.current()
//        print("User: \(User.shared.firebaseAuth.currentUser)")
//        print("token: \(tokennn)")
//    }

}

