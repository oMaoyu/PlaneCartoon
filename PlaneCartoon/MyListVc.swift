//
//  MyListVc.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyListVc: UIViewController,UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate {
    private static let instance:MyListVc  = MyListVc()
    //单例
    class func shared()->MyListVc{
        return  instance
    }
    
    var num = 0
    
    var table:MyMainTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backImage:UIImage = UIImage(named: "ss")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.done, target:self, action: #selector(searchVc))
        table = MyMainTableView(frame: CGRect(x: 0, y: 64, width: www, height: hhh-108), style: .grouped)
        table.delegate = self
        table.dataSource = self
        view.addSubview(UIView())
        view.addSubview(table)
        
        let save:Bool = MyNetOc.unArchiverAnObject(withFileName: "Save") as! Bool? ?? true
        if save {
            MyNewSwift.shared().listOfObjectModel()
        }
        MyNewSwift.shared().collectAry()
        UIUpdate()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyNewSwift.shared().arrayString.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MyListCell! = tableView.dequeueReusableCell(withIdentifier:"MyListCell_id") as! MyListCell!
        if (cell == nil) {
            cell = MyListCell(style: .default, reuseIdentifier: "MyListCell_id")
        }
        if MyNewSwift.shared().arrayString.count < indexPath.item {
            return UITableViewCell()
        }
        
        cell.model = MyNewSwift.shared().arrayString[indexPath.item]
        
        if self.responds(to: #selector(getter: traitCollection)) {
            if #available(iOS 9.0, *) {
                if self.traitCollection.responds(to: #selector(getter: traitCollection.forceTouchCapability)) {
                    if traitCollection.forceTouchCapability == UIForceTouchCapability.available{
                        registerForPreviewing(with: self, sourceView: cell)
                    }
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208/640*www
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyListBookVc()
        vc.title = MyNewSwift.shared().arrayString[indexPath.item].book
        vc.model = MyNewSwift.shared().arrayString[indexPath.item]
        vc.numIdx = indexPath.item
        navigationController?.pushViewController(vc, animated: true)
    }

    
    // 数据缓存结束 开始更新
    func UIUpdate(){
        num = num + 1
        if num % 10 == 0{
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    func searchVc(){
        let search = MyTbaleSsModel()
        search.title = navigationItem.title
        navigationController?.pushViewController(search, animated: true)
    }
    
    //UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            let indx = table.indexPath(for: previewingContext.sourceView as! MyListCell)
            let vc = MyListBookVc()
            vc.title = MyNewSwift.shared().arrayString[(indx?.item)!].book
            vc.model = MyNewSwift.shared().arrayString[(indx?.item)!]
            vc.numIdx = indx?.item
            previewingContext.sourceRect = CGRect(x: 0, y: 0, width: previewingContext.sourceView.frame.size.width, height: previewingContext.sourceView.frame.size.height)
            return vc
        }
        return UIViewController()
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class jsonModel:JWBaseModel{

    var pages: MyPages! = MyPages()
    override func propertyValueTypeMapping() -> [String : JWBaseModel] {
        return ["pages":MyPages()];
    }

}

class MyPages: JWBaseModel{
    var page:[String:String]?
    var order: [String]?

}
