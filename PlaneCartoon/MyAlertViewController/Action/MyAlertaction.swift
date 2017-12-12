//
//  MyAlertaction.swift
//  employees
//
//  Created by 高子雄 on 2017/3/29.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyAlertaction: NSObject {
    
    typealias MyActionClosure = (MyAlertaction)->Void
    //初始化
    public convenience init(title:String,color:UIColor,handler:@escaping MyActionClosure) {
        self.init()
        //设置标题
        self.title = title
        //回掉
        self.handler =  handler
        //颜色
        self.actionColor = color
    }
    //按钮颜色
    var actionColor : UIColor? = UIColor.white
    //回调
    var handler:MyActionClosure?
    //title
    var title:String?
    
    private override init() {
        super.init()
    }

}
