//
//  LCHomeNewsController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/8.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

    
//MARK: - life cycle
class LCHomeNewsController: LCTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.lc_registerClassCell(cellClass: LCNewsCell.self)
        print("__\(#file)__\(#function)__\(#line)__")
        

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.lc_dequeueReusableCell(indexPath: indexPath) as LCNewsCell
        cell.news = self.news[indexPath.row].contentModel
        cell.selectionStyle = .none
        return cell
    }
}
