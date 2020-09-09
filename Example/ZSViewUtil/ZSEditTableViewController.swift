//
//  ZSEditTableViewController.swift
//  ZSViewUtil_Example
//
//  Created by Josh on 2020/9/1.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ZSViewUtil

class ZSEditTableViewController: UITableViewController, ZSEditTableViewCellDelegate {

    private weak var preEditCell: ZSEditTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(ZSEditTableViewCell.self, forCellReuseIdentifier: ZSEditTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ZSEditTableViewCell.identifier, for: indexPath) as! ZSEditTableViewCell

        cell.imageView?.backgroundColor = .orange
        cell.textLabel?.text = "12312"
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        preEditCell?.endScrollEditing()
        
        print("222")
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        preEditCell?.endScrollEditing()
    }
    
    func zs_cellWillBeginScrollEdit(_ cell: ZSEditTableViewCell) {
        
        guard preEditCell != cell else { return }
        preEditCell?.endScrollEditing()
        preEditCell = cell
    }
}
