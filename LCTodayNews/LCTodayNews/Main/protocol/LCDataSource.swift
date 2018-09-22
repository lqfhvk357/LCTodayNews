
//
//  dataSource.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

public protocol LCDataSource {
    var datas:[Any] { get }
}

extension LCDataSource where Self: UITableViewController{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datas.count
    }
    
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        cell.textLabel?.text = datas[indexPath.row] as? String
        return cell
    }
}

