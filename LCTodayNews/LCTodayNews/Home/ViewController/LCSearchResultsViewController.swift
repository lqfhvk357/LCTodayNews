//
//  LCSearchViewController.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/12/17.
//  Copyright © 2018 罗超. All rights reserved.
//

import UIKit

class LCSearchResultsViewController: UIViewController {
    
    struct Keyword {
        var texts: [String]
        var isOpen = false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    
    var keywords = [Keyword]()
    
    
    let backView = UIView(frame: CGRect(x: 0, y: NavBarHeight, width: ScreenWidth, height: ScreenHeight-NavBarHeight))
    
    lazy var navBar: LCFakeNavBar = {
        let navBar = Bundle.main.loadNibNamed("LCFakeNavBar", owner: nil, options: nil)?.last as! LCFakeNavBar
        navBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: NavBarHeight)
        navBar.backClick = { [weak self] in
            self!.navigationController?.popViewController(animated: true)
        }
        return navBar
    }()
    
    lazy var keywordsView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
        flowLayout.estimatedItemSize = CGSize.zero
        
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: NavBarHeight, width: ScreenWidth, height: ScreenHeight-NavBarHeight), collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.init(0xF5F5F5)
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.alwaysBounceVertical = true
        
        collectionView.lc_registerNibCell(cellClass: LCKeyWordCell.self)
        collectionView.lc_registerNibSectionHeader(reusableViewClass: LCkeyWordHeader.self)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(navBar)
        
        setupKeyWord()
        setupViews()
        
//                self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
//        let internalTargets = self.navigationController?.interactivePopGestureRecognizer?.value(forKey: "targets") as? Array<NSObject>
//        let internalTarget = internalTargets!.first?.value(forKey: "target")
//        let selector = Selector("handleNavigationTransition:")
        
    
        
//        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
//        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
//        self.fd_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
//        [self.fd_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
//        let screenEdgePanGR = UIPanGestureRecognizer(target: internalTarget, action: selector)
        //        screenEdgePanGR.delegate = self
    }
    func setupKeyWord() {
        for i in 0...2 {
            var strings = [String]()
            for j in 0...5 {
                let string = "\(i)\(j) 搜索关键词！！！"
                strings.append(string)
            }
            let keyword = Keyword(texts: strings, isOpen: false)
            keywords.append(keyword)
        }
    }

    func setupViews() {
        self.view.addSubview(keywordsView)
    }
}



extension LCSearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return keywords[section].texts.count
        case 1:
            return keywords[section].isOpen ? keywords[section].texts.count : 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.lc_dequeueReusableCell(indexPath: indexPath) as LCKeyWordCell
        cell.keyWord = keywords[indexPath.section].texts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LCkeyWordHeader.nibName, for: indexPath) as! LCkeyWordHeader
        header.setup(is: keywords[indexPath.section].isOpen, section: indexPath.section)
        header.tapLeftView = {[weak self] isOpen in
            self?.keywords[indexPath.section].isOpen = isOpen
            self?.keywordsView.reloadSections(IndexSet.init(integer: indexPath.section))
        }
        return header
    }
}

extension LCSearchResultsViewController: UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: ScreenWidth/3, height: 36)
        case 1, 2:
            return CGSize(width: ScreenWidth/2, height: 36)
        default:
            return CGSize.zero
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 1, 2:
            return CGSize(width: ScreenWidth, height: 38)
        default:
            return CGSize.zero
        }
    }
    
}

