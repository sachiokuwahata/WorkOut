//
//  User.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/13.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

protocol UserDelegate: class {
    func loginTrans(error: Error?)
    func loginLoad()

}

class User {
    // シングルトン実装
    static let shared = User()

    weak var delegate: UserDelegate?
 
    private init(){}
    
    let firebaseAuth = Auth.auth()
    
    func fblogin(){
        if let token = FBSDKAccessToken.current() {
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            User.shared.firebaseAuth.signInAndRetrieveData(with: credential) { (authResult, error) in
                if error != nil {
                    return
                }
                self.delegate?.loginLoad()
                // ログイン時の処理
                print("FirebaseUser: \(User.shared.firebaseAuth.currentUser)")
                print("FBtoken: \(token)")

                self.delegate?.loginTrans(error: error)
            }
            return
        }
    }
    
}
