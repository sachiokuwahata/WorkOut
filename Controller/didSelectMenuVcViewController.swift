//
//  didSelectMenuVcViewController.swift
//  07_14_kuwahatasachio
//
//  Created by sachiokuwahata on 2019/02/21.
//  Copyright © 2019年 sachiokuwahata. All rights reserved.
//

import UIKit

class didSelectMenuVcViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.shared.selectedPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let MenuTextLabel = cell.viewWithTag(1) as! UILabel
        let WeightTextLabel = cell.viewWithTag(2) as! UILabel
        let NumberTextLabel = cell.viewWithTag(3) as! UILabel
        
        MenuTextLabel.text = PostController.shared.selectedPost[indexPath.row].menu
        WeightTextLabel.text = PostController.shared.selectedPost[indexPath.row].weight
        NumberTextLabel.text = PostController.shared.selectedPost[indexPath.row].number
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
    }
    
}
