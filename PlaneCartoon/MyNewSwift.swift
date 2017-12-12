//
//  MyNewSwift.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit
let www = UIScreen.main.bounds.width
let hhh = UIScreen.main.bounds.height
let red = MyNewSwift.shared().transferStringToColor("#ce0a2d")

class MyNewSwift: NSObject {
    private static let instance:MyNewSwift  = MyNewSwift()
    //单例
    class func shared()->MyNewSwift{
        return  instance
    }
    var arrayString = [MyBookModel]()
    var collectComicArray = [MyBookModel]()
    var updateTheComic = [MyBookModel]()
    // 图片 //img  .attributes["src"]
    // 书名 [3]
    // 作者 [4]
    // 简介 [6]
    let queue = DispatchQueue(label: "oMaoyu.Plane")
    var isQueue = false
    
    func collectAry(){
        collectComicArray = UnArchiverComic() as! [MyBookModel]
    }
    
    func listOfObjectModel(){
        arrayString = UnArchiverAnArray() as! [MyBookModel]
        queue.async { [weak self] in //异步方法不阻塞UI
            var num = NSInteger(self?.arrayString.last?.num ?? "0")!
            if num == 0 {
                num = num + 1000000
            }
            for i in num..<1008000 {
                if (self?.isQueue)! {
                    return
                }
                var url = "http://smp.yoedge.com/view/omnibus/"
                url.append("\(i)")
                let jiAppleSupportDoc = Ji(htmlURL: URL(string: url)!)
                if jiAppleSupportDoc == nil {
                    continue
                }
                let titleNode = jiAppleSupportDoc?.xPath("body")?.first
                let img = jiAppleSupportDoc?.xPath("//img")?.first
                let html = jiAppleSupportDoc?.xPath("//a/@href")
                var arrayHtml = [String]()
                for ing in (html?.enumerated())! {
                    if ing.0 < (html?.count)! - 2{
                        arrayHtml.append(ing.1.content!)
                    }
                }
                let str = titleNode?.content
                let v = str?.components(separatedBy: "\r\n\t\t\t\t")
                let model = self?.ImgTextNameHtml(img:(img?["src"])!, book:(v?[3])!, text:(v?[6])!, name: (v?[4])!, html: arrayHtml,url:url,num:"\(i)")
                self?.arrayString.append(model!)
                MyListVc.shared().UIUpdate()
            }
        }
        MyListVc.shared().table.reloadData()
    }
    func ImgTextNameHtml(img:String,book:String,text:String,name:String,html:[String],url:String,num:String)->MyBookModel{
        let model = MyBookModel()
        model.book = book
        model.text = text
        model.img = img
        model.name = name
        model.html = html
        model.url = url
        model.num = num
        return model
    }
    
    func listOfObject(url:String)->MyBookModel{
        let jiAppleSupportDoc = Ji(htmlURL: URL(string: url)!)
        if jiAppleSupportDoc == nil {
            return MyBookModel()
        }
        let titleNode = jiAppleSupportDoc?.xPath("body")?.first
        let img = jiAppleSupportDoc?.xPath("//img")?.first
        let html = jiAppleSupportDoc?.xPath("//a/@href")
        var arrayHtml = [String]()
        for ing in (html?.enumerated())! {
            if ing.0 < (html?.count)! - 2{
                arrayHtml.append(ing.1.content!)
            }
        }
        let str = titleNode?.content
        let v = str?.components(separatedBy: "\r\n\t\t\t\t")
        let model = ImgTextNameHtml(img:(img?["src"])!, book:(v?[3])!, text:(v?[6])!, name: (v?[4])!, html: arrayHtml,url:url,num: "-1")
        return model
    }
    
    // 归档数组到本地
    func ArchiverAnArray(){
        MyNetOc.archiverAnObject(withFileName:"ObjectModel", andAchiverObject: arrayString)
    }
    //从本地获取数组数组
    func UnArchiverAnArray()->Any{
        return MyNetOc.unArchiverAnObject(withFileName: "ObjectModel") ?? [MyBookModel]()
    }
    func ArchiverComic(){
        MyNetOc.archiverAnObject(withFileName:"ComicModel", andAchiverObject: collectComicArray)
    }
    func UnArchiverComic()->Any{
        return MyNetOc.unArchiverAnObject(withFileName: "ComicModel") ?? [MyBookModel]()
    }
    // 判断是否有漫画更新
    func updateTheComicArray(model:MyBookModel){
        updateTheComic.append(model)
    }
    // 获取漫画当前的id
    class func accessToComicsId(url:String)->String{
        var str = url
        str = str.replacingOccurrences(of: "http://smp.yoedge.com/smp-app/", with: "")
        str = str.replacingOccurrences(of: "/shinmangaplayer/index.html", with: "")
        return str
    }
  
    class func errorAlertControllerString(vc:UIViewController,str:String,text:String){
        let ac:MyAlertController = MyAlertController(title:str, message:text)
        ac.addAction(actionTitle: "确定", handler: { (ac) in})
        MyNewSwift.thePopUpErrorMessageBox(vc: vc, ac: ac)
    }
    // 弹出提示框
    class func thePopUpErrorMessageBox(vc:UIViewController,ac:MyAlertController){
        vc.present(ac, animated: true, completion: nil)
    }
    func transferStringToColor(_ colorStr:String) -> UIColor {
        var color = UIColor.red
        var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = cStr.substring(from: index)
        }
        if cStr.characters.count != 6 {
            return UIColor.black
        }
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = cStr.substring(with: rRange)
        
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = cStr.substring(with: gRange)
        
        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = cStr.substring(from: bIndex)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        return color
    }
}
