//
//  UIKit+Extension.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/20.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

extension UIView {
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue){
            frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get { return frame.origin.y }
        set(newValue){
            frame.origin.y = newValue
        }
    }
    
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue){
            frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get { return frame.size.height }
        set(newValue){
            frame.size.height = newValue
        }
    }
    
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: g/255.0, alpha: 1)
    }
    
    convenience init(_ rgb: Int) {
        self.init(red: (CGFloat)((rgb & 0xFF0000) >> 16)/255.0, green: (CGFloat)((rgb & 0x00FF00) >> 8)/255.0, blue: (CGFloat)((rgb & 0x0000FF) >> 0)/255.0, alpha: 1)
    }
    
    
    class var globalBackgroundColor: UIColor {
        get {
            return UIColor(0xf8f9f7)
        }
    }
    
    class var tableViewBackgoundColor: UIColor {
        get {
             return UIColor(0xf6f6f6)
        }
    }
    
    class var navbarBarTint: UIColor {
        get {
            return UIColor(0xD33E42)
        }
    }
    
    class var tarbarTint: UIColor {
        get {
            return UIColor(0xf55a5d)
        }
    }
    
}


// UITableView & UICollectionView
protocol ReusableView {}
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return "\(self)"
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
extension UITableViewCell: ReusableView { }
extension UICollectionReusableView: ReusableView{ }

extension UITableView {
    func lc_registerNibCell<T: UITableViewCell>(cellClass: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func lc_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    func lc_registerNibCell<T: UICollectionViewCell>(cellClass: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func lc_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func lc_registerNibSectionHeader<T: UICollectionReusableView>(reusableViewClass: T.Type) {
        print(T.reuseIdentifier)
        register(T.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
    }
    
    
//    func lc_dequeueReusableSectionHeader<T: UICollectionReusableView>(indexPath: IndexPath) -> T {
//        print(T.reuseIdentifier)
//        return dequeueReusableSupplementaryView(ofKind:UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
//    }
}




protocol bundleLoadableView: class { }
extension bundleLoadableView where Self: UIView {
    static var nibName: String {
        return "\(self)"
    }
    
    static func lc_loadForBundle() -> Self {
        return Bundle.main.loadNibNamed(self.nibName, owner: nil, options: nil)?.last as! Self
    }
}


extension UIView: bundleLoadableView{}


