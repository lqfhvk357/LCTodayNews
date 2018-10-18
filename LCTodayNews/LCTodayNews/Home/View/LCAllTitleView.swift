//
//  LCAllTitleView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/6.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LCAllTitleView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    lazy var finishButton = UIButton()
    
    var disposeBag = DisposeBag()
    var titles: Array< Array<LCHomeNewsTitle> > = [[]]
    var sectionTitles = [[KMainTitle:"我的频道", KSubTitle:"点击进入频道"], [KMainTitle:"频道推荐", KSubTitle:"点击添加频道"]]
    
    var enChange = false {
        didSet {
            longPressGR.isEnabled = !enChange
            self.sectionTitles[0][KSubTitle] = enChange ? "拖拽可以排序" : "点击进入频道"
            collectionView.reloadData()
        }
    }
    var titleShouldScroll = false
    
    
    
    lazy var panGR = UIPanGestureRecognizer.init(target: self, action: #selector(pan))
    lazy var longPressGR = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress))
    var sysPan: UIPanGestureRecognizer?
    
    public typealias Completion = (_ completionTitles: Array< Array<LCHomeNewsTitle> >, _ titleShouldScroll: Bool, _ selectIndex: Int) -> Void
    var completion: Completion?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
        self.setupViewEvents()
    }
    
    //MARK: - Views
    fileprivate func setupViews() -> Void {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        
        flowLayout.itemSize = CGSize(width: 70, height: 44)
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        flowLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: 44)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.lc_registerNibCell(cellClass: LCTitleCell.self)
        self.collectionView.lc_registerNibSectionHeader(reusableViewClass: LCSectionHeader.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        finishButton.setTitle("编辑", for: .normal)
        finishButton.setTitle("完成", for: .selected)
        finishButton.setTitleColor(.red, for: .normal)
        finishButton.layer.cornerRadius = 13
        finishButton.layer.masksToBounds = true
        finishButton.layer.borderWidth = 0.5
        finishButton.layer.borderColor = UIColor.red.cgColor
        collectionView.addSubview(finishButton)
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView)
            make.right.equalTo(self).offset(-8)
            make.width.equalTo(50)
            make.height.equalTo(26)
        }
    }
    
    //MARK: - Events
    fileprivate func setupViewEvents() -> Void {
        finishButton.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        collectionView.addGestureRecognizer(longPressGR)
        collectionView.addGestureRecognizer(panGR)
        panGR.delegate = self
        if let gestureRecognizers = collectionView!.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
                    self.sysPan = gestureRecognizer as? UIPanGestureRecognizer
                    break
                }
            }
        }
    }
    
    @objc func click(button: UIButton) -> Void {
        button.isSelected = !button.isSelected
        enChange = button.isSelected
    }
    
    @objc func longPress(longPressGR: UILongPressGestureRecognizer) -> () {
        finishButton.isSelected = true
        enChange = true
    }
    
    @objc func pan(panPressGR: UIPanGestureRecognizer) -> () {
        
        switch panPressGR.state {
        case .began:
            if let selectIndexPath = collectionView.indexPathForItem(at: panPressGR.location(in: collectionView)) {
                collectionView.beginInteractiveMovementForItem(at: selectIndexPath)
            }
        case .changed:
//            if let movetoPath = collectionView.indexPathForItem(at: panPressGR.location(in: collectionView)), movetoPath.item == 0 {
//                collectionView.endInteractiveMovement()
//            }
            collectionView.updateInteractiveMovementTargetPosition(panPressGR.location(in: panPressGR.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    
    @IBAction func removeSelf() {
        self.removeFromSuperview()
        
        var index = 0
        for i in 0...self.titles[0].count-1 {
            let model = self.titles[0][i]
            if let select = model.select, select {
                index = i
                break
            }
        }
        
        if let completion = completion {
            completion(titles, titleShouldScroll, index)
        }
    }
}


//MARK: - UIGestureRecognizerDelegate Extension
extension LCAllTitleView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return enChange
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGR, otherGestureRecognizer == sysPan {
            if let selectIndexPath = collectionView.indexPathForItem(at: gestureRecognizer.location(in: collectionView)), selectIndexPath.section == 0 {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: - UICollectionViewDataSource Extension
extension LCAllTitleView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.lc_dequeueReusableCell(indexPath: indexPath) as LCTitleCell
        cell.setupCell(with: titles[indexPath.section][indexPath.row], enChange: enChange, in: indexPath)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LCSectionHeader.nibName, for: indexPath) as! LCSectionHeader
        header.dataDict = sectionTitles[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0, indexPath.row != 0{
            return true
        }else{
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var model = self.titles[0].remove(at: sourceIndexPath.row)
        if let select = model.select, select{
            titleShouldScroll = true
            model.select = false
            self.titles[0][0].select = true
        }
        self.titles[destinationIndexPath.section].insert(model, at: destinationIndexPath.row)
    }
}

//MARK: - UICollectionViewDelegate Extension
extension LCAllTitleView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if enChange, indexPath.section == 0, indexPath.row != 0 {
            var model = self.titles[0].remove(at: indexPath.row)
            if let select = model.select, select {
                titleShouldScroll = true
                model.select = false
                self.titles[0][0].select = true
            }
            collectionView.deleteItems(at: [indexPath])
            self.titles[1].insert(model, at: 0)
            collectionView.insertItems(at: [IndexPath(row: 0, section: 1)])
            
        }else if indexPath.section == 1 {
            let model = self.titles[1].remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            self.titles[0].append(model)
            collectionView.insertItems(at: [IndexPath(row: self.titles[0].count-1, section: 0)])
            
        }else if !enChange, indexPath.section == 0 {
            self.titles[0] = self.titles[0].map{ LCHomeNewsTitle(category: $0.category, name: $0.name) }
            self.titles[0][indexPath.row].select = true
            self.removeSelf()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout Extension
extension LCAllTitleView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let top = CGFloat(0)
        let left = CGFloat(10)
        let right = CGFloat(8)
        let bottom = section == 0 ? CGFloat(12) : CGFloat(120)
        
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}


//MARK: - Private
