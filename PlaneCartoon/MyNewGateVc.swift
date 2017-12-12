//
//  MyNewGateVc.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyNewGateVc: UIViewController {
    private static let instance:MyNewGateVc  = MyNewGateVc()
    //单例
    class func shared()->MyNewGateVc{
        return  instance
    }
    var img = UIImageView(image: UIImage(named: "suo"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.frame = CGRect(x: 0, y: 64, width: www, height: hhh-64)
        let text = UILabel(frame: CGRect(x: 0, y: 64, width: www, height: 160))
        text.textAlignment = .center
        text.text = "本次更新为添加了清空缓存的功能，下次更新将会添加随机刷新猜你喜欢的漫画的功能（才不是随机数字刷新漫画呢，才不是懒得在做新的界面所以拖到下一次呢\n顺便说下，清空缓存是清空的列表里的漫画，收藏里的不会进行清空，然后这个时候，你下次登录app，我到底是要自动帮你继续缓存列表呢，还是让你自己缓存？"
        text.font = UIFont.systemFont(ofSize: 12)
        text.textColor = UIColor.white
        text.numberOfLines = 0
        view.addSubview(UIView())
        view.addSubview(img)
        view.addSubview(text)
        let save = UIBarButtonItem(title:"清空缓存", style: .done, target: self, action: #selector(emptyTheSlowToSave))
        let reload = UIBarButtonItem(title:"刷新数据", style: .done, target: self, action: #selector(reloadDeta))
        navigationItem.rightBarButtonItem = reload
        navigationItem.leftBarButtonItem = save
    }

    func reloadDeta(){
        MyNewSwift.shared().isQueue = true
        MyNewSwift.shared().arrayString.removeAll()
        MyNewSwift.shared().arrayString = [MyBookModel]()
        MyNewSwift.shared().isQueue = false
        MyNewSwift.shared().listOfObjectModel()
    }
    
    func emptyTheSlowToSave(){
        
        let ac:MyAlertController = MyAlertController(title: "清空缓存即将开始", message:"大兄弟，你确定你要看的漫画收藏好了吗？顺便说下，清空缓存完后，下次要有列表必须手动点击刷新列表")
        ac.addAction(actionTitle: "内存不够，点击确定", handler: { (ac) in
            MyNewSwift.shared().isQueue = true
            MyNewSwift.shared().arrayString.removeAll()
            MyNewSwift.shared().arrayString = [MyBookModel]()
            self.clearCache()
            MyListVc.shared().table.reloadData()
        })
        ac.addAction(actionTitle: "手贱手贱", handler: { (ac) in})
        MyNewSwift.thePopUpErrorMessageBox(vc: self, ac: ac)
    }
    
    // 获取缓存大小
    func fileSizeOfCache()-> Int {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = (cachePath! as NSString).appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        let mm = size / 1024 / 1024
        return mm
    }
    // 清除缓存
    func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = (cachePath! as NSString).appending("/\(file)")
            let isBool = path.range(of: "ComicModel.data")
            if isBool?.isEmpty != false {
                if FileManager.default.fileExists(atPath: path) {
                    do {
                        try FileManager.default.removeItem(atPath: path)
                    } catch {
                        
                    }
                }
            }
        }
        MyNetOc.archiverAnObject(withFileName:"Save", andAchiverObject: false)
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
