//
//  LCPageView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/20.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

protocol LCPageHeaderTitle {
    var pageTitle: String {get}
    var pageTitleID: String {get}
    var pageSelect: Bool? {get set}
    
    
    static func save(newsTitles: [LCPageHeaderTitle], for key: String)
    static func readNewsTitles(for key: String) -> [LCPageHeaderTitle]?
}

protocol LCPageTitleProtocol where Self: UIViewController  {
    var newsTitle: LCPageHeaderTitle? { set get }
}

//protocol LCPageSubViewFrame {
//    var pageContentViewFrame: CGRect {get}
//    var pageHeaderViewFrame: CGRect {get}
//}

let titleHeight: CGFloat = 44


class LCPageViewController : UIViewController {
    func selectVC(_ index: Int) {
        print("select to page \(index)")
    }
    
    func getTitles() {
        fatalError("getTitles() has not been override implemented")
    }
    
    var titles : [LCPageHeaderTitle] = []
    var others : [LCPageHeaderTitle] = []
    var childViewControllerDict: Dictionary<String, UIViewController & LCPageTitleProtocol> = [:]
    var selectIndex: Int = 0
    
    lazy var pageScrollView: LCHomePageScrollView = {
        let scrollView = LCHomePageScrollView()
        scrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(self.titles.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        let height = ScreenHeight
        scrollView.frame = CGRect(x: 0, y: NavBarHeight+titleHeight, width: ScreenWidth, height: height)
        return scrollView
    }()
    lazy var titleHeader: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.estimatedItemSize = CGSize.zero
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: NavBarHeight, width: ScreenWidth, height: titleHeight), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.lc_registerNibCell(cellClass: LCHomeTitleCell.self)
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 30)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        getTitles()
        setupTitleHeader()
        setupPageScrollView()
        selectVC(0)
    }
    
    
    //MARK - Public
    func setupTitleHeader() {
        self.view.addSubview(titleHeader)
        
        let lineH = CGFloat(0.3)
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        self.view.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(titleHeader)
            make.height.equalTo(lineH)
        }
    }
    
    func setupPageScrollView() {
        self.view.addSubview(pageScrollView)
    }
    
    func updateSelectTitle(in index: Int) {
        self.titles[selectIndex].pageSelect = false
        self.titles[index].pageSelect = true
        selectIndex = index
        
        titleHeader.reloadData()
        titleHeader.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func reloadViews() {
        self.titleHeader.reloadData()
        pageScrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(self.titles.count), height: 0)
    }
    
    func reloadAllViews(titles: [LCPageHeaderTitle], others: [LCPageHeaderTitle], selectIndex: Int) {
        self.selectIndex = selectIndex
        self.titles = titles
        self.others = others
        
        LCHomeNewsTitle.save(newsTitles: titles, for: KHomeTitlesKey)
        LCHomeNewsTitle.save(newsTitles: others, for: KHomeOtherTitlesKey)
        
        self.titleHeader.reloadData()
        self.pageScrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(self.titles.count), height: 0)
        
        for newsTitle in self.others {
            if let vc = self.childViewControllerDict[newsTitle.pageTitleID] {
                vc.view.removeFromSuperview()
                vc.willMove(toParentViewController: nil)
                vc.removeFromParentViewController()
            }
            self.childViewControllerDict.removeValue(forKey: newsTitle.pageTitleID)
        }
        
        for index in 0...self.titles.count-1 {
            let newsTitle = self.titles[index]
            if let vc = self.childViewControllerDict[newsTitle.pageTitleID] {
                let height = ScreenHeight - NavBarHeight - TabBarHeight - self.titleHeader.lc_height
                vc.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
            }
            
            if let select = newsTitle.pageSelect, select {
                self.selectIndex = index
                self.pageScrollView.setContentOffset(CGPoint(x: ScreenWidth*CGFloat(index), y: 0), animated: false)
                self.titleHeader.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
        
        self.selectVC(selectIndex)
    }
}


//MARK: - UICollectionViewDataSource Extension
extension LCPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.lc_dequeueReusableCell(indexPath: indexPath) as LCHomeTitleCell
        cell.homeTitle = self.titles[indexPath.row]
        return cell
    }
}


//MARK: - UICollectionViewDelegate Extension
extension LCPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectVC(indexPath.row)
        self.updateSelectTitle(in: indexPath.row)
        pageScrollView.setContentOffset(CGPoint(x: CGFloat(indexPath.row)*ScreenWidth, y: 0), animated: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Extension
extension LCPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let newsTitle = self.titles[indexPath.item]
        let sysFont = UIFont.systemFont(ofSize: 16)
        
        var size = self.titles[indexPath.row].pageTitle.textSize(font: sysFont, width: ScreenWidth)
        
        if let select = newsTitle.pageSelect, select {
            let boldSysFont = UIFont.boldSystemFont(ofSize: 17)
            size = self.titles[indexPath.row].pageTitle.textSize(font: boldSysFont, width: ScreenWidth)
        }
        return CGSize(width: size.width+1, height: size.height)
    }
}

//MARK: - UIScrollViewDelegate Extension
extension LCPageViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == pageScrollView else {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / ScreenWidth)
        guard index != selectIndex else {
            return
        }
        
        selectVC(index)
        updateSelectTitle(in: index)
    }
}
