//
//  MyLikeVc.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyLikeVc: UIViewController,UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate {
    private static let instance:MyLikeVc  = MyLikeVc()
    //单例
    class func shared()->MyLikeVc{
        return  instance
    }
    var table:MyMainTableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table = MyMainTableView(frame: CGRect(x: 0, y: 64, width: www, height: hhh-108), style: .grouped)
        table.delegate = self
        table.dataSource = self
        view.addSubview(UIView())
        view.addSubview(table)
    }
    override func viewWillAppear(_ animated: Bool) {
        table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyNewSwift.shared().collectComicArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MyListCell! = tableView.dequeueReusableCell(withIdentifier:"MyListCell_id") as! MyListCell!
        if (cell == nil) {
            cell = MyListCell(style: .default, reuseIdentifier: "MyListCell_id")
        }
        cell.model = MyNewSwift.shared().collectComicArray[indexPath.item]
        
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
        vc.title = MyNewSwift.shared().collectComicArray[indexPath.item].book
        vc.model = MyNewSwift.shared().collectComicArray[indexPath.item]
        vc.numIdx = indexPath.item
        vc.isSkill = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            let indx = table.indexPath(for: previewingContext.sourceView as! MyListCell)
            let vc = MyListBookVc()
            vc.title = MyNewSwift.shared().collectComicArray[(indx?.item)!].book
            vc.model = MyNewSwift.shared().collectComicArray[(indx?.item)!]
            vc.numIdx = indx?.item
            vc.isSkill = true
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
