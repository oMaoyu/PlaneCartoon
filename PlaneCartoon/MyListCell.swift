//
//  MyListCell.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyListCell: MyMainTableViewCell {

    // 封面
    var imgCover = UIImageView()
    // 书名
    var title = UILabel()
    // 作者名
    var name = UILabel()
    // 简介
    var introductionToThe = UILabel()
    
    var model:MyBookModel?{
        didSet{
            imgCover.kf.setImage(with: URL(string:(model?.img!)!))
            title.text = model?.book!
            name.text = model?.name!
            var str:String = model!.text!
            let range = str.startIndex..<str.index((str.startIndex), offsetBy: 1)
            str.removeSubrange(range)
            introductionToThe.text = str
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imgCover.clipsToBounds = true
        imgCover.layer.cornerRadius = 6
        imgCover.image = UIImage(named: "jz")
        
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = UIColor.black

        name.font = UIFont.systemFont(ofSize: 12)
        name.textColor = UIColor.black
        
        introductionToThe.numberOfLines = 2
        introductionToThe.font = UIFont.systemFont(ofSize: 12)
        introductionToThe.textColor = UIColor.black
        
        contentView.addSubview(imgCover)
        contentView.addSubview(title)
        contentView.addSubview(name)
        contentView.addSubview(introductionToThe)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgCover.frame = CGRect(x: 24/640*www, y: 24/640*www, width: 128/640*www, height: 160/640*www)
        title.frame = CGRect(x: imgCover.frame.maxX+24/640*www, y: imgCover.frame.origin.y, width: www*0.7, height: 40/640*www)
        name.frame = CGRect(x: title.frame.origin.x, y: title.frame.maxY, width: www*0.7, height: 40/640*www)
        introductionToThe.frame = CGRect(x: title.frame.origin.x, y: name.frame.maxY, width: www*0.7, height: 80/640*www)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
