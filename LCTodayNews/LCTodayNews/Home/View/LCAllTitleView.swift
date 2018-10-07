//
//  LCAllTitleView.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/6.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

class LCAllTitleView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var finishButton: UIButton!
    
    var titles: Array< Array<LCHomeNewsTitle> > = [[]]
    var enChange = false
    lazy var panGR = UIPanGestureRecognizer.init(target: self, action: #selector(pan))
    lazy var longPressGR = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress))
    var sysPan: UIPanGestureRecognizer?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        
        flowLayout.itemSize = CGSize(width: 70, height: 44)
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        flowLayout.headerReferenceSize = CGSize(width: ScreenWidth, height: 44)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.lc_registerNibCell(cellClass: LCTitleCell.self)
        self.collectionView.lc_registerNibSectionHeader(reusableViewClass: LCSectionHeader.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        finishButton.layer.cornerRadius = 13
        finishButton.layer.masksToBounds = true
        finishButton.layer.borderWidth = 0.5
        finishButton.layer.borderColor = UIColor.red.cgColor
        

        collectionView.addGestureRecognizer(longPressGR)
        if let gestureRecognizers = collectionView!.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
                    self.sysPan = gestureRecognizer as? UIPanGestureRecognizer
                    break
                }
            }
        }
        panGR.delegate = self
        collectionView.addGestureRecognizer(panGR)
        
//        panGR.isEnabled = false
        
        
    }
    
    @objc func longPress(longPressGR: UILongPressGestureRecognizer) -> () {
        enChange = true
        longPressGR.isEnabled = false
        collectionView.reloadData()
    }
    
    @objc func pan(panPressGR: UIPanGestureRecognizer) -> () {
        switch panPressGR.state {
        case .began:
            if enChange, let selectIndexPath = collectionView.indexPathForItem(at: panPressGR.location(in: collectionView)) {
                collectionView.beginInteractiveMovementForItem(at: selectIndexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(panPressGR.location(in: panPressGR.view))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    @IBAction func finish() {
        enChange = false
        longPressGR.isEnabled = true
        collectionView.reloadData()
    }
    @IBAction func removeSelf() {
        self.removeFromSuperview()
    }
}

extension LCAllTitleView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return enChange
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGR, otherGestureRecognizer == sysPan {
            return true
        }else{
            return false
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension LCAllTitleView: UICollectionViewDataSource, UICollectionViewDelegate {
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
        
//        let header = collectionView.lc_dequeueReusableSectionHeader(indexPath: indexPath) as LCSectionHeader
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LCSectionHeader.nibName, for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if enChange, indexPath.section == 0, indexPath.row != 0 {
            let model = self.titles[0][indexPath.row]
            self.titles[0].remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            
            self.titles[1].insert(model, at: 0)
            collectionView.insertItems(at: [IndexPath(row: 0, section: 1)])
        }else if indexPath.section == 1 {
            let model = self.titles[1][indexPath.row]
            self.titles[1].remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
            
            self.titles[0].append(model)
            collectionView.insertItems(at: [IndexPath(row: self.titles[0].count-1, section: 0)])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
}
