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
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: g/255.0, alpha: 1)
    }
    
    convenience init(_ rgb: Int) {
        self.init(red: (CGFloat)((rgb & 0xFF0000) >> 16)/255.0, green: (CGFloat)((rgb & 0x00FF00) >> 8)/255.0, blue: (CGFloat)((rgb & 0x0000FF) >> 0)/255.0, alpha: 1)
    }
    
    
    class func globalBackgroundColor() -> UIColor {
        return UIColor(0xf8f9f7)
    }
    
    class func tableViewBackgoundColor() -> UIColor {
        return UIColor(0xf6f6f6)
    }
}


// UITableView & UICollectionView
protocol ReusableView {}
extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }


protocol NibLoadableView: class { }
extension NibLoadableView where Self: UIView {
    static var NibName: String {
        return NSStringFromClass(self)
    }
}
extension UITableViewCell: NibLoadableView { }
extension UICollectionViewCell: NibLoadableView { }


extension UITableView {
    func registerCell<T: UITableViewCell>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView{
    func registerCell<T: UICollectionViewCell>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}





