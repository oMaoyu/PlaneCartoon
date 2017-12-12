//
//  MyListBookVc.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/5.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit
let color = UIColor(red: (250/255.0), green: (217/255.0), blue: (98/255.0), alpha: 1)
class MyListBookVc: UIViewController {
    var model:MyBookModel!
    var bgImage = UIImageView(image: UIImage(named:"bj"))
    // 封面
    var imgCover = UIImageView()
    // 书名
    var book = UILabel()
    // 作者名
    var name = UILabel()
    // 简介
    var introductionToThe = UILabel()
    // 收藏
    var collection = UIButton()
    // 继续阅读
    var continueReading = UIButton()
    var continueText = UILabel()
    // 续看第N话
    var continueNum = 0
    // 九宫格view
    var forInView = UIScrollView()
    // 当前所处模型位置
    var numIdx:NSInteger? = -1000
    var isSkill = false
    var btn:UIButton! = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navBarTintColor =  UIColor.white
        
        imgCover.clipsToBounds = true
        imgCover.layer.cornerRadius = 6
        imgCover.layer.borderWidth = 3
        imgCover.layer.borderColor = UIColor.white.cgColor
        imgCover.image = UIImage(named: "jz")
        imgCover.kf.setImage(with: URL(string:(model?.img!)!))
        imgCover.frame = CGRect(x:24/640*www, y:24/640*www+64,width:192/640*www,height:240/640*www)
        
        book.font = UIFont.systemFont(ofSize: 16)
        book.textColor = UIColor.white
        book.text = model?.book!
        book.frame = CGRect(x: imgCover.frame.maxX+24/640*www, y: imgCover.frame.origin.y, width: www*0.7, height: 40/640*www)

        name.font = UIFont.systemFont(ofSize: 14)
        name.textColor = UIColor.white
        name.text = model?.name!
        name.frame = CGRect(x: book.frame.origin.x, y: book.frame.maxY, width: www*0.7, height: 40/640*www)

        introductionToThe.numberOfLines = 0
        introductionToThe.font = UIFont.systemFont(ofSize: 14)
        introductionToThe.textColor = UIColor.white
        var str:String = model!.text!
        let range = str.startIndex..<str.index((str.startIndex), offsetBy: 1)
        str.removeSubrange(range)
        introductionToThe.text = str
        introductionToThe.frame = CGRect(x: 24/640*www, y: imgCover.frame.maxY+6, width: www-48/640*www, height: str.boundingRect(size:CGSize(width: www-48/640*www, height: hhh), font: introductionToThe.font).height)

        bgImage.frame = CGRect(x: 0, y: 64, width: www, height: hhh)
        
        forInView.backgroundColor = UIColor.white
        forInView.frame = CGRect(x: 0, y: introductionToThe.frame.maxY+12, width: www, height: hhh-introductionToThe.frame.maxY-12)
        forInView.showsVerticalScrollIndicator = false
        forInView.showsHorizontalScrollIndicator = false
        
        collection.setImage(UIImage(named:"jgz"), for: .normal)
        collection.setImage(UIImage(named:"ygz"), for: .selected)
        collection.addTarget(self, action: #selector(clickGz), for: .touchUpInside)
        collection.frame = CGRect(x: book.frame.origin.x, y: imgCover.frame.maxY-60/640*www, width:120/640*www, height: 60/640*www)
        collection.isSelected = collectComic(isBool: true,N:true)
        continueReading.setImage(UIImage(named:"bjImage"), for: .normal)
        continueReading.setImage(UIImage(named:"bjImage"), for: .selected)
        continueReading.addTarget(self, action: #selector(clickYd), for: .touchUpInside)
        continueReading.frame = CGRect(x: collection.frame.maxX+12, y: collection.frame.origin.y, width: 180/640*www, height: 60/640*www)
        continueReading.imageEdgeInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 0.0, right: 0.0)
        continueText.font = UIFont.systemFont(ofSize: 12)
        continueText.textColor = UIColor.black
        continueText.textAlignment = .center
        continueText.frame = continueReading.frame
        
        forInView(num: (model.html?.count)!)
        numIdxDemo()
        
        view.addSubview(UIView())
        view.addSubview(bgImage)
        view.addSubview(imgCover)
        view.addSubview(book)
        view.addSubview(name)
        view.addSubview(introductionToThe)
        view.addSubview(collection)
        view.addSubview(continueReading)
        view.addSubview(continueText)
        view.addSubview(forInView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.25, animations: {
            if self.navigationController?.navigationBar.wr_getTranslationY() == -64 {
                self.navigationController?.navigationBar.wr_setTranslationY(translationY: 0)
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isContinueText()
    }
    
    func isContinueText(){
        btn.backgroundColor = color
        let isBar:Bool =  (model.html?.contains(model.browsingHistory))!
        if isBar {
            continueNum = (model.html?.index(of: model.browsingHistory))!
            continueText.text = "继续阅读"
            let btn:UIButton = forInView.viewWithTag(continueNum+1000) as! UIButton
            btn.backgroundColor = MyNewSwift.shared().transferStringToColor("#aaaaaa")
            self.btn = btn
            bookModelDemo(mode: model)
        }else{
            continueText.text = "开始阅读"
        }
    }
    
    // 更新模型数组替换
    func numIdxDemo(){
        let mode = MyNewSwift.shared().listOfObject(url: model.url!)
        if (mode.html?.count ?? 0) > (model.html?.count)!{
            bookModelDemo(mode: mode)
        }
    }
    func bookModelDemo(mode:MyBookModel){
        if numIdx! >= 0{
            if !isSkill{
                MyNewSwift.shared().arrayString[numIdx!] = mode
                MyNewSwift.shared().ArchiverAnArray()
//                print("普通")
            }else{
                if collection.isSelected == isSkill{
                    MyNewSwift.shared().collectComicArray[numIdx!] = mode
                    MyNewSwift.shared().ArchiverComic()
//                    print("喜欢")
                }
            }
        }
    }

    func forInView(num:NSInteger){
        var x:CGFloat = 0
        var y:CGFloat = 0
        let jg:CGFloat = 12
        let w:CGFloat = (www-5*jg)/4
        let h:CGFloat = 50/640*www
        for i in 1...num{
            let btn = UIButton(frame: CGRect(x: x+jg, y: y+jg, width: w, height: h))
            btn.tag = i + 999
            btn.addTarget(self, action: #selector(clickTag(btn:)), for: .touchUpInside)
            btn.setTitle("第\(i.cn)话", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.backgroundColor = color
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.isExclusiveTouch = true
            forInView.addSubview(btn)
            x = btn.frame.maxX
            if x + jg >= www-2{
                x = 0
                y = btn.frame.maxY
            }
            forInView.contentSize = CGSize(width: www, height: btn.frame.maxY+12)
        }
        isContinueText()
    }
    func clickTag(btn:UIButton){
       numView(num: btn.tag-1000,isBool: false)
    }
    // 收藏
    func clickGz(){
        if collection.isSelected == false {
            let ac:MyAlertController = MyAlertController(title: "加入收藏的漫画将会进行本地判断是否更新", message:"这是一个来自开发者的提醒")
            ac.addAction(actionTitle: "加入朕的收藏", handler: { (ac) in
                self.collection.isSelected = true
                _ = self.collectComic(isBool: true,N:false)
            })
            ac.addAction(actionTitle: "这本书不要也罢", handler: { (ac) in
                self.collection.isSelected = false
                _ = self.collectComic(isBool: false,N:false)
            })
            MyNewSwift.thePopUpErrorMessageBox(vc: self, ac: ac)
        }else{
            let ac:MyAlertController = MyAlertController(title: "你即将抛弃你的小黄本，放轻松，我不会说出去的", message:"闭眼玩家微笑的转过头")
            ac.addAction(actionTitle: "不了不了", handler: { (ac) in
                self.collection.isSelected = true
                _ = self.collectComic(isBool: true,N:false)
            })
            ac.addAction(actionTitle: "我选择抛弃", handler: { (ac) in
                self.collection.isSelected = false
                _ = self.collectComic(isBool: false,N:false)
            })
            MyNewSwift.thePopUpErrorMessageBox(vc: self, ac: ac)
        }
    }
    // 继续阅读
    func clickYd(){
        numView(num: continueNum,isBool: true)
    }
    // 收藏漫画 true 收藏  false 不收藏
    func collectComic(isBool:Bool,N:Bool)->Bool{
        var ary = [String]()
        for y in MyNewSwift.shared().collectComicArray{
            ary.append(y.book!)
        }
        let isBar =  ary.contains(model.book!)
        if isBar {
            let idx = ary.index(of: model.book!)
            if !isBool{
                MyNewSwift.shared().collectComicArray.remove(at: idx!)
                MyNewSwift.shared().ArchiverComic()
            }
            return true
        }else{
            if isBool{
                if N {
                    return false
                }
                MyNewSwift.shared().collectComicArray.append(model)
                MyNewSwift.shared().ArchiverComic()
                return false
            }
            return false
        }
    }
    // 从第N话开始阅读
    func numView(num:NSInteger,isBool:Bool){
        continueNum = num
        let id = MyNewSwift.accessToComicsId(url: (model.html?[num])!)
        netWebJson(id:id,isBool:isBool)
    }
    func netWebJson(id:String,isBool:Bool){
        let url = "http://smp.yoedge.com/smp-app/" + id + "/shinmangaplayer/"
        let str = url + "smp_cfg.json"
//        print(str)
        HYBNetworking.getWithUrl(str, refreshCache: false, success: { (str) in
            let mode = jsonModel(keyValues: str)
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width:www,height:hhh-64)
            layout.scrollDirection = UICollectionViewScrollDirection.horizontal
            layout.minimumLineSpacing = 0
            let vc = MyComicCV(collectionViewLayout: layout)
            vc.title = self.navigationItem.title
            vc.url = url
            vc.pageArray = mode.pages.order
            vc.pageDict = mode.pages.page
            vc.page = NSInteger(self.model.page)!
            vc.isContinue = isBool
            if mode.pages.order == nil && mode.pages.page == nil{ return }
            vc.html = self.model.html
            vc.num = self.continueNum
            vc.handler = { (num,page) in
                self.model.browsingHistory = (self.model.html?[num])!
                self.model.page = "\(page)"
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (error) in

        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension String {
    func boundingRect(size:CGSize,font:UIFont)  ->  CGSize {
        let size:CGSize =  NSString(string: self).boundingRect(with:size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
        if size.height < 20{
            return CGSize(width: size.width+5, height: 20)
        }
        return CGSize(width: size.width+5, height:size.height+2)
    }
}
extension Int {
    var cn: String {
        get {
            if self == 0 {
                return "零"
            }
            var zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
            var units = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十","百","千"]
            var cn = ""
            var currentNum = 0
            var beforeNum = 0
            let intLength = Int(floor(log10(Double(self))))
            for index in 0...intLength {
                currentNum = self/Int(pow(10.0,Double(index)))%10
                if index == 0{
                    if currentNum != 0 {
                        cn = zhNumbers[currentNum]
                        continue
                    }
                } else {
                    beforeNum = self/Int(pow(10.0,Double(index-1)))%10
                }
                if [1,2,3,5,6,7,9,10,11].contains(index) {
                    if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                        cn = units[index] + cn
                    } else if currentNum != 0 {
                        cn = zhNumbers[currentNum] + units[index] + cn
                    } else if beforeNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                    continue
                }
                if [4,8,12].contains(index) {
                    cn = units[index] + cn
                    if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                }
            }
            return cn
        }
    }
}
