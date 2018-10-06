//
//  LCHomeViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/29.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

class LCHomeViewController: UIViewController  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .slide
        }
    }
    
    var titles : [LCHomeNewsTitle] = []
    weak var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        if let titles = UserDefaults.standard.object(forKey: HomeTitlesKey) as? Array<Dictionary<String, String>> {
            self.titles = titles.map { dict -> LCHomeNewsTitle in
                if let category = dict["category"], let name = dict["name"]{
                    return LCHomeNewsTitle.init(category: category, name: name)
                }else{
                    return LCHomeNewsTitle.init(category: "", name: "")
                }
            }
            let defaultTitle = LCHomeNewsTitle.init(category: "", name: "推荐", select: true)
            self.titles.insert(defaultTitle, at: 0)
//            self.titles = titles as! [String :String]s
        }else{
            LCServerTool.requestHomeTiltes { result in
                switch result {
                case .success(let response):
                    if let titleDatas = LCHomeNewsTitleData.modelform(response){
                        self.titles = titleDatas.data.data
                        let defaultTitle = LCHomeNewsTitle.init(category: "", name: "name", select: true)
                        self.titles.insert(defaultTitle, at: 0)
                        print(self.titles)
                        self.collectionView?.reloadData()
                        
                        let titleDicts = titleDatas.data.data.map{ newsTitle in
                            return newsTitle.titleDict
                        }
                        UserDefaults.standard.set(titleDicts, forKey: HomeTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        
        
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.lc_registerNibCell(cellClass: LCHomeTitleCell.self)
        collectionView.delegate = self
        collectionView.dataSource  = self
        
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        
        // Do any additional setup after loading the view.
    }

}

extension LCHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.lc_dequeueReusableCell(indexPath: indexPath) as LCHomeTitleCell
        cell.homeTitle = self.titles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LCAllNewsTitlesController.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.present(vc, animated: true, completion: nil)
    }
}
