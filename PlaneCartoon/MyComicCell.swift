//
//  MyComicCell.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/22.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyComicCell: UICollectionViewCell {
    typealias MyBlock = ()->Void
    var handler:MyBlock?
    var img = UIImageView(image: UIImage(named: "jz"))
    // 是否隐藏头
    var hideTheHead = UIButton()
    // 判断横屏
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hideTheHead.addTarget(self, action: #selector(clickBlock), for: .touchUpInside)
        img.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(img)
        contentView.addSubview(hideTheHead)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = contentView.bounds
        img.center = contentView.center
        hideTheHead.frame = contentView.bounds
    }
    // 点击隐藏
    func clickBlock(){
        handler!()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
