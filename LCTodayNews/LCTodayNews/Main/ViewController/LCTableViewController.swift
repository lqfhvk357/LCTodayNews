//
//  LCTableViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/21.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import MJRefresh
import Moya
import PromiseKit
import SwiftyJSON


class LCTableViewController: UITableViewController {

    var titles = [LCHomeNewsTitle]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.backgroundColor = UIColor.tableViewBackgoundColor
//        tableView.lc_registerCell(cellClass: UITableViewCell.self)
        self.tableView.mj_header = LCRefreshHeader{ [weak self] in
            
        }
        
//        LCServerTool.requestHomeTiltes(completion: { result in
//            switch result {
//            case .success(let response):
//                print("requestHomeTiltes:\n\(JSON(response.data))");
//
//                if let titles = LCHomerTitleData.modelform(response){
//                    print("requestHomeTiltes:\n\(titles)");
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        })
//
//        LCServerTool.requestHomeMoreTitles { result in
//            switch result {
//            case .success(let response):
//                let titles = LCHomerTitleData.modelArrayform(response)
////                print("requestHomeMoreTitles:\n\(titles)");
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        
//        LCServerTool.requsetHomeSearchBarInfo{ result in
//            switch result {
//            case .success(let response):
//                if let titles = LCHomeSearchInfoData.modelform(response) {
//                    print("requsetHomeSearchBarInfo:\n\(titles)");
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
        
        LCServerTool.requestHomeNews(forCategory:.recommend){ result in
            switch result {
            case .success(let response):
//                print("requestHomeNews:\n\(JSON(response.data))");
//                if let titles = LCHomeNews.modelArrayform(response) {
//                    print("requsetHomeSearchBarInfo:\n\(titles)");
//                }

                if let titles = LCHomeNewsData.modelform(response){
                    print("requsetHomeSearchBarInfo:\n\(titles.data)");
                }


            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
//        datas = ["1", "2"]
        
        

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    


    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


