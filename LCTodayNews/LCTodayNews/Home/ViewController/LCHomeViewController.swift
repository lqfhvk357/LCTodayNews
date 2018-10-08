//
//  LCHomeViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/29.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import SnapKit

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
    var others : [LCHomeNewsTitle] = []
    
    weak var collectionView: UICollectionView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.getTitles()
        self.getOtherTitles()
        self.sutupNewsTitleView()
    }
    
    
    func sutupNewsTitleView() -> (){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.estimatedItemSize = CGSize.zero
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 44), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.yellow
        collectionView.lc_registerNibCell(cellClass: LCHomeTitleCell.self)
        collectionView.delegate = self
        collectionView.dataSource  = self
    
        
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func getTitles() -> () {
        if let titles = self.readNewsTitles(for: HomeTitlesKey) {
            self.titles = titles
            let defaultTitle = LCHomeNewsTitle.init(category: "", name: "推荐", select: true)
            self.titles.insert(defaultTitle, at: 0)
        }else{
            LCServerTool.requestHomeTiltes { result in
                switch result {
                case .success(let response):
                    if let titleDatas = LCHomeNewsTitleData.modelform(response){
                        self.titles = titleDatas.data.data
                        let defaultTitle = LCHomeNewsTitle.init(category: "", name: "推荐", select: true)
                        self.titles.insert(defaultTitle, at: 0)
                        self.collectionView?.reloadData()
                        
                        self.save(newsTitles: titleDatas.data.data, for: HomeTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getOtherTitles() -> Void {
        if let otherTitles = self.readNewsTitles(for: HomeOtherTitlesKey) {
            self.others = otherTitles
        }else{
            LCServerTool.requestHomeMoreTitles { result in
                switch result {
                case .success(let response):
                    if let titleDatas = LCHomeNewsTitleData.modelform(response){
                        self.others = titleDatas.data.data
                        self.save(newsTitles: titleDatas.data.data, for: HomeOtherTitlesKey)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func save(newsTitles: [LCHomeNewsTitle], for key: String) -> Void {
        UserDefaults.standard.set(newsTitles.map { $0.titleDict }, forKey: key)
    }
    
    func readNewsTitles(for key: String) -> [LCHomeNewsTitle]? {
        if let titleDicts = UserDefaults.standard.object(forKey: HomeOtherTitlesKey) as? Array<Dictionary<String, String>> {
            let newsTitles = titleDicts.map { dict -> LCHomeNewsTitle? in
                if let category = dict["category"], let name = dict["name"]{
                    return LCHomeNewsTitle.init(category: category, name: name)
                }else{
                    return nil
                }
            }
            
            func textNil() -> Void{
                let nilString:String? = nil
                let nilStrings:[String?]? = [nilString]
                if let test = nilStrings {
                    print("Is test nil?  ---  \(test)")
                }
            }
            textNil()
            
            if (newsTitles.first != nil) {
                return newsTitles as? [LCHomeNewsTitle]
            }else{
                return nil
            }
            
        }else{
            return nil
        }
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
        let titleView = LCAllTitleView.lc_loadForBundle()
        let keyWindow = UIApplication.shared.keyWindow!
        titleView.titles = [self.titles, self.others]
        keyWindow.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(keyWindow.safeAreaLayoutGuide)
            }else{
                make.top.equalTo(keyWindow).offset(20)
                make.left.right.bottom.equalTo(keyWindow)
            }
        }
        titleView.completion = { completionTitles in
            print("i am here")
            self.titles = completionTitles[0]
            self.others = completionTitles[1]
            
            self.collectionView?.reloadData()
        }
        
    }
}

extension LCHomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = NSString.init(string: self.titles[indexPath.row].name).size(withAttributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)]).width
        let height:CGFloat = 28
        
        return CGSize(width: width, height: height)

    }
    
}
