//
//  InputMenuViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/23.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class InputMenuViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    let menuList:[String] = ["スクワット","チェストプレス","レッグプレス","ヒップアダクション","レッグカール","ラットプルダウン","ショルダープレス","バイセップカール","トライセプスエクステンション","ベンチプレス","ヒップスラスト","ニーリングスクワット"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tablewview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let menuLabel = cell.viewWithTag(1) as! UILabel
        menuLabel.text = menuList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(self.menuList[indexPath.row], forKey: "selectMenu")
        print("menuList[indexPath.row]: \(menuList[indexPath.row])")
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var tablewview: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        tablewview.delegate = self
        tablewview.dataSource = self
    }
    
}
