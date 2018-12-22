//
//  LCTitleCell.swift
//  LCTodayNews
//
//  Created by 罗超 on 2018/10/7.
//  Copyright © 2018年 罗超. All rights reserved.
//

import UIKit

class LCTitleCell: UICollectionViewCell {
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    func setupCell(with title: LCHomeNewsTitle, enChange: Bool, in indexPath: IndexPath) -> () {
        if indexPath.section == 0 {
            newsTitleLabel.text = title.name
            close.isHidden = indexPath.row == 0 ? true : !enChange
        }else{
            let attachment = NSTextAttachment.init()
            attachment.image = UIImage(named: "pgc_tabbar_icon_more")
            attachment.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
            let imageAttri = NSAttributedString(attachment: attachment)
            
            let contentAttri = NSAttributedString.init(string: title.name, attributes: [.font : UIFont.systemFont(ofSize: 14)])
            let m_attri = NSMutableAttributedString(attributedString: imageAttri)
            m_attri.append(contentAttri)
    
            newsTitleLabel.attributedText = m_attri
//            "+\(title.name)"
            close.isHidden = true;
        }
        
        
        
        if let select = title.pageSelect, select {
            newsTitleLabel.textColor = UIColor.red
        }else{
            if indexPath.row == 0, indexPath.section == 0 {
                newsTitleLabel.textColor = UIColor.lightGray
            }else{
                newsTitleLabel.textColor = UIColor.black
            }
        }
        
    }
    
    
    
//    var title: LCHomeNewsTitle? {
//        didSet{
//            newsTitleLabel.text = title?.name
//            if let select = title?.select {
//                newsTitleLabel.textColor = select ? UIColor.red : UIColor.black
//            }else{
//                newsTitleLabel.textColor = UIColor.black
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
