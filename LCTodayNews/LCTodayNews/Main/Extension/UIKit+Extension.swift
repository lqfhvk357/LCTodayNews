//
//  UIKit+Extension.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/9/20.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit
import YogaKit

//MARK: - UIView
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

extension UIView {
    func yogaLayout() {
        self.yoga.display = .none
        self.yoga.display = .flex
    }
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




//MARK: - UIColor
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


//MARK: - UITableView & UICollectionView
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
    
    func lc_registerClassCell<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: T.reuseIdentifier)
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

//MARK: - String
extension String {
    func textSize(systemFontSize: CGFloat, width: CGFloat) -> CGSize {
        
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                 options: .usesLineFragmentOrigin,
                                 attributes: [.font: UIFont.systemFont(ofSize: systemFontSize)],
                                 context: nil).size
    }
    
}

extension TimeInterval {
    // 把秒数转换成时间的字符串
    func timeString() -> String {
        // 把获取到的秒数转换成具体的时间
        let createDate = Date(timeIntervalSince1970: self)
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: createDate, to: Date())
        // 日期格式
        let formatter = DateFormatter()
        // 判断当前日期是否为今年
        guard createDate.isTheYear() else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: createDate)
        }
        // 是否是昨天
        if createDate.isYesterday() {
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.string(from: createDate)
        } else if createDate.isToday(){
            // 判断是否是今天
            if comps.hour! >= 1 {
                return String(format: "%d小时前", comps.hour!)
            } else if comps.minute! >= 1 {
                return String(format: "%d分钟前", comps.minute!)
            } else {
                return "刚刚"
            }
        } else {
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: createDate)
        }
    }
}


//extension Int {
//
//    func convertString() -> String {
//        guard self >= 10000 else {
//            return String(describing: self)
//        }
//        return String(format: "%.1f万", Float(self) / 10000.0)
//    }
//}


extension Date {
    
    /// 判断当前日期是否为今年
    func isTheYear() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let date = Date()
        
        return formatter.string(from: date) == formatter.string(from: self)
    }
    
    
    /// 是否是昨天
    func isYesterday() -> Bool {
        let date = Date()
        let since = date.timeIntervalSince(self)
        
//        print(since)
        return since > 60*60*24 && since < 60*60*24*2
    }
    

    /// 判断是否是今天
    func isToday() -> Bool {
        let date = Date()
        let since = date.timeIntervalSince(self)
        
//        print(since)
        return since < 60*60*24
    }
    
    
}

