//
//  MyComicCV.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/22.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyComicCell"
private let reuseId = "MySwitchCell"

class MyComicCV: UICollectionViewController {
    typealias MyBlock = (_ i:NSInteger,_ page:NSInteger)->Void
    var handler:MyBlock?
    // 图片地址拼接
    var url:String!
    // 图片url字典
    var pageDict:[String:String]!
    // 图片页数
    var pageArray:[String]!
    // 当前话数
    var num = 0
    // 当前页数
    var page = 0
    // html合集
    var html:[String]!
    // 上一话
    var onBtn = UIButton()
    // 下一话
    var underBtn = UIButton()
    // text
    var text = UILabel()
    // 是否继续阅读
    var isContinue:Bool!
    var isClickBtn = true
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(UIView())
        let vv = UIView(frame: CGRect(x: 0, y: 0, width: www, height: 25))
        vv.backgroundColor = UIColor.white
        view.addSubview(vv)

        onBtn.frame = CGRect(x: 0, y: 20, width: www*0.3, height: 44)
        onBtn.setTitle("上一话", for: .normal)
        onBtn.setTitleColor(.white, for: .normal)
        onBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        onBtn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        view.addSubview(onBtn)
        
        underBtn.frame = CGRect(x: www-www*0.3, y: 20, width: www*0.3, height: 44)
        underBtn.setTitle("下一话", for: .normal)
        underBtn.setTitleColor(.white, for: .normal)
        underBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        underBtn.addTarget(self, action: #selector(underClick), for: .touchUpInside)
        view.addSubview(underBtn)
        
        text.frame = CGRect(x: 0, y: 20, width: www, height: 44)
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = .white
        view.addSubview(text)
        collectionView?.allowsSelection = false
        collectionView!.register(MyComicCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.isPagingEnabled = true // 分页
        collectionView?.showsHorizontalScrollIndicator = false // 弹性
        navBarTintColor =  UIColor.white

        if isContinue ?? false {
            history(num: page)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if pageArray == nil {
            return pageDict.count
        }
        return pageArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var ary = Array(pageDict.keys)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyComicCell
        ary.sort(by: {$0 < $1})
        let imgUrl = url+pageDict[ary[indexPath.section]]!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        cell.img.kf.setImage(with: URL(string:strReplacing(Str: imgUrl)), placeholder: UIImage(named:"jz"))
        cell.handler = {
            UIView.animate(withDuration: 0.25, animations: { 
                if self.navigationController?.navigationBar.wr_getTranslationY() == 0 {
                    self.navigationController?.navigationBar.wr_setTranslationY(translationY: -64)
                }else{
                    self.navigationController?.navigationBar.wr_setTranslationY(translationY: 0)
                }
            })
        }
        return cell
    }
    // 切换上一话
    func onClick(){
        if num == 0 {
            let ac:MyAlertController = MyAlertController(title: "上面没有了，你还在点击什么？", message:"这可是第一话啊，醒醒吧大兄弟")
            ac.addAction(actionTitle: "不了，我要回主界面", handler: { (ac) in
                self.navigationController?.popViewController(animated: true)
            })
            ac.addAction(actionTitle: "手贱手贱", handler: { (ac) in})
            MyNewSwift.thePopUpErrorMessageBox(vc: self, ac: ac)
        }else{
            if isClickBtn {
                isClickBtn = false
                num = num - 1
                netWebJson(id:MyNewSwift.accessToComicsId(url: (html?[num])!),isBool: true)
            }
        }
    }
    // 切换下一话
    func underClick(){
        if num == html.count-1 {
            let ac:MyAlertController = MyAlertController(title: "已经到本漫画的最后一话", message:"请等待汉化组大佬的更新")
            ac.addAction(actionTitle: "好的，我要跳回去", handler: { (ac) in
                self.navigationController?.popViewController(animated: true)
            })
            MyNewSwift.thePopUpErrorMessageBox(vc: self, ac: ac)
        }else{
            if isClickBtn {
                isClickBtn = false
                num = num + 1
                netWebJson(id:MyNewSwift.accessToComicsId(url: (html?[num])!),isBool: false)
            }
        }
    }
    func netWebJson(id:String,isBool:Bool){
        let url = "http://smp.yoedge.com/smp-app/" + id + "/shinmangaplayer/"
        let str = url + "smp_cfg.json"
        HYBNetworking.getWithUrl(str, refreshCache: false, success: { (str) in
            let mode = jsonModel(keyValues: str)
            self.pageDict = mode.pages.page
            self.pageArray = mode.pages.order
            self.page = isBool ? (mode.pages.page?.count)!-1 : 0
            self.text.text = "\(self.page+1)/\(self.pageDict.count)页  \(self.num+1)/\(self.html.count)话"
            self.url = url
            self.collectionView?.reloadData()
            self.history(num:self.page)
        }) { (error) in
            let ac:MyAlertController = MyAlertController(title: "不好了，夭折了，你家网炸了", message:"哈哈哈，反正不是我的事情，app有bug？不存在的")
            ac.addAction(actionTitle: "没错，我网炸了", handler: { (ac) in})
            MyNewSwift.thePopUpErrorMessageBox(vc: self, ac: ac)

        }
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let poin = view.convert((collectionView?.center)!, to: collectionView)
        let idx = collectionView?.indexPathForItem(at: poin)
        page = (idx?.section)!
        text.text = "\((idx?.section)!+1)/\(pageDict.count)页  \(num+1)/\(html.count)话"
    }
    
    //切换到历史浏览界面
    func history(num:NSInteger){
        isClickBtn = true
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: num), at: .left, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        handler!(num, page)
    }
    
    func strReplacing(Str:String)->String{
        var string = Str
        string = string.replacingOccurrences(of: "smp.yoedge.com", with: "smp3.yoedge.com")
        return string
    }
}
extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
