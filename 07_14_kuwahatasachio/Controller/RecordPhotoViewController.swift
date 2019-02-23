//
//  RecordPhotoViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/01/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit
import Photos

class RecordPhotoViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var todayDate: UILabel!
    var Today = String()
    
    @IBAction func photo(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
            
        }else{
            print("エラー")
        }
    }
    
    
    @IBAction func Album(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else{
            print("エラー")
            
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedimage = info[.originalImage] as? UIImage {

        if let pickedimage = info[.editedImage] as? UIImage {
            
//            let menuVC = self.storyboard?.instantiateViewController(withIdentifier: "menuVC") as! RecordMenuViewController
//            menuVC.image = pickedimage
//
//            menuVC.Today = self.Today
//
//            picker.dismiss(animated: true, completion: nil)
//            self.navigationController?.pushViewController(menuVC, animated: true)

            let TrainingVC = self.storyboard?.instantiateViewController(withIdentifier: "TrainingVC") as! RecordTrainingViewController
            TrainingVC.image = pickedimage

            TrainingVC.Today = self.Today
            
            picker.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(TrainingVC, animated: true)

            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        todayDate.text = Today
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:break
            case .denied:break
            case .notDetermined:break
            case .restricted:break
            }
        }
        UserDefaults.standard.set("0", forKey: "selectWeight")
        UserDefaults.standard.set("0", forKey: "selectNumber")
        UserDefaults.standard.set("---------", forKey: "selectMenu")
        UserDefaults.standard.set("yyyy年mm月dd日", forKey: "selectDate")
    }
    
    

}
