//
//  LCHomeBaseViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/29.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import SnapKit
import PromiseKit
import Alamofire
import CoreLocation
import RxCocoa
import RxSwift
import SwiftyJSON

protocol SelectChildVCProtocol where Self: UIViewController {
    var titles : [LCHomeNewsTitle] {get set}
    var others : [LCHomeNewsTitle] {get set}
    var childViewControllerDict: Dictionary<String, NewsTitleProtocol> {get set}
    var selectIndex: Int {get set}
    
    func selectVC(_ index: Int)
}


class LCHomeBaseViewController: UIViewController, SelectChildVCProtocol {
    
    var titles : [LCHomeNewsTitle] = []
    var others : [LCHomeNewsTitle] = []
    var childViewControllerDict: Dictionary<String, NewsTitleProtocol> = [:]
    var selectIndex = 0
    
    let titleHeight: CGFloat = 44
    
    
    lazy var pageScrollView: LCHomePageScrollView = {
        let scrollView = LCHomePageScrollView()
        scrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(self.titles.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        let height = ScreenHeight
        scrollView.frame = CGRect(x: 0, y: titleHeight, width: ScreenWidth, height: height)
        return scrollView
    }()
    lazy var titleHeader: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.estimatedItemSize = CGSize.zero
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: titleHeight), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.lc_registerNibCell(cellClass: LCHomeTitleCell.self)
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 30)
        
        return collectionView
    }()
    lazy var titleView: LCAllTitleView = {
        let titleV = LCAllTitleView.lc_loadForBundle()
        titleV.completion = { [weak self] completionTitles, titleShouldScroll, selectIndex in

            self?.selectIndex = selectIndex
            self?.titles = completionTitles[0]
            self?.others = completionTitles[1]
            
            LCHomeNewsTitle.save(newsTitles: self!.titles, for: KHomeTitlesKey)
            LCHomeNewsTitle.save(newsTitles: self!.others, for: KHomeOtherTitlesKey)
            
            self!.titleHeader.reloadData()
            self!.pageScrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(self!.titles.count), height: 0)
            
            for newsTitle in self!.others {
                if let vc = self!.childViewControllerDict[newsTitle.category] as? UIViewController {
                    vc.view.removeFromSuperview()
                    vc.willMove(toParentViewController: nil)
                    vc.removeFromParentViewController()
                }
                self!.childViewControllerDict.removeValue(forKey: newsTitle.category)
            }
            
            for index in 0...self!.titles.count-1 {
                let newsTitle = self!.titles[index]
                if let vc = self!.childViewControllerDict[newsTitle.category] as? UIViewController {
                    let height = ScreenHeight - NavBarHeight - TabBarHeight - self!.titleHeader.height
                    vc.view.frame = CGRect(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: height)
                }
                
                if let select = newsTitle.select, select {
                    self!.selectIndex = index
                    self!.pageScrollView.setContentOffset(CGPoint(x: ScreenWidth*CGFloat(index), y: 0), animated: false)
                    self!.titleHeader.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
                }
            }
            
            self!.selectVC(selectIndex)
        }
        
        return titleV
    }()

    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        getTitles()
        getOtherTitles()
        setupTitleHeader()
        setupPageScrollView()
        selectVC(0)
    }
    
    //MARK: - Datas
    func getTitles() {
        fatalError("getTitles() has not been override implemented")
    }
    
    func getOtherTitles() {

    }
    func selectVC(_ index: Int) {
        fatalError("selectVC(_ index: Int) has not been override implemented")
    }
    
    //MARK: - Views
    
    func setupTitleHeader() {
        self.view.addSubview(titleHeader)
        
        let lineH = CGFloat(0.3)
        let line = UIView(frame: CGRect(x: 0, y: titleHeight - lineH, width: ScreenWidth, height: lineH))
        line.backgroundColor = UIColor.lightGray
        self.view.addSubview(line)
    }
    
    func setupPageScrollView() {
        self.view.addSubview(pageScrollView)
    }
    
    func updateSelectTitle(in index: Int) -> Void {
        self.titles[selectIndex].select = false
        self.titles[index].select = true
        selectIndex = index
        titleHeader.reloadData()
        titleHeader.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func showTitlesView() {
        titleView.enChange = false
        titleView.titles = [self.titles, self.others]
        
        let keyWindow = UIApplication.shared.keyWindow!
        keyWindow.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(keyWindow.safeAreaLayoutGuide)
            }else{
                make.top.equalTo(keyWindow).offset(20)
                make.left.right.bottom.equalTo(keyWindow)
            }
        }
        
        
        titleView.transform = CGAffineTransform(translationX: 0, y: ScreenHeight)
        UIView.animate(withDuration: 0.3) {
            self.titleView.transform = CGAffineTransform.identity
        }
    }
}

//MARK: - UICollectionViewDataSource Extension
extension LCHomeBaseViewController: UICollectionViewDataSource {
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
extension LCHomeBaseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectVC(indexPath.row)
        self.updateSelectTitle(in: indexPath.row)
        pageScrollView.setContentOffset(CGPoint(x: CGFloat(indexPath.row)*ScreenWidth, y: 0), animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Extension
extension LCHomeBaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.titles[indexPath.row].name.textSize(systemFontSize: 17, width: ScreenWidth).width
        let height:CGFloat = 28
        return CGSize(width: width, height: height)
    }
}

//MARK: - UIScrollViewDelegate Extension
extension LCHomeBaseViewController: UIScrollViewDelegate {
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

