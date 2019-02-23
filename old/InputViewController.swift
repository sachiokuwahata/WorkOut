//
//  InputViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/22.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class InputViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{

//    static let shared = InputViewController()


    
    
    // UIPickerView の設定
    let pv = UIPickerView()
    let dataList = ["5","10","15","20","25","30","35","40"]
    var selectNumber = String()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択時の処理
        self.selectNumber = dataList[row]
         print(dataList[row])

//        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
//        let menuVC = storyboardMain.instantiateViewController(withIdentifier: "menuVC")
       
    }

    func okFunc(){
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC")
        
        
        
    }
    
    
    func numberInputButton(viewController: UIViewController) {
        
        let title = "トレーニング回数を選択して下さい。"
        let message = "\n\n\n\n\n\n\n\n" //改行入れないとOKCancelがかぶる
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("決定：\(self.selectNumber)")
            self.okFunc()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        pv.selectRow(0, inComponent: 0, animated: true) // 初期値
        //pv.frame = CGRectMake(0, 50, view.bounds.width * 0.85, 150) // 配置、サイズ
        pv.dataSource = self
        pv.delegate = self
        alert.view.addSubview(pv)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
