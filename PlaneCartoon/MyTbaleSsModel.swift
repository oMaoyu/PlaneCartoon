//
//  MyTbaleSsModel.swift
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/5.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyTbaleSsModel: UITableViewController ,UISearchResultsUpdating{

    lazy var searchController:UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        search.searchBar.placeholder = "搜索"
        search.searchBar.sizeToFit()
        return search
    }()
    var Source = MyNewSwift.shared().arrayString
    var allSource = NSDictionary() // 排序后的数据源
    var indexDataSource = NSArray() // 索引数据源
    var searchDataSource = NSMutableArray() // 搜索结果数据源
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        navBarTintColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    func getData (){ //处理数据
        allSource = HCSortString.sortAndGroup(for: Source, propertyName: "book")
        indexDataSource = HCSortString.sort(forStringAry: allSource.allKeys)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if !searchController.isActive{
            return indexDataSource.count
        }else{
            return 1
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchController.isActive{
            let value:NSArray = allSource.object(forKey: indexDataSource[section]) as! NSArray
            return value.count
        }else{
            return searchDataSource.count
        }
    }
    // 头部索引
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !searchController.isActive{
            return indexDataSource[section] as! NSString as String
        }else{
            return nil
        }
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !searchController.isActive{
            return indexDataSource as? [String]
        }else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MyListCell! = tableView.dequeueReusableCell(withIdentifier:"MyListCell_id") as! MyListCell!
        if (cell == nil) {
            cell = MyListCell(style: .default, reuseIdentifier: "MyListCell_id")
        }
        if !searchController.isActive{
            let value:NSArray = allSource.object(forKey: indexDataSource[indexPath.section]) as! NSArray
            cell.model = value[indexPath.row] as? MyBookModel
        }else{
            cell.model = searchDataSource[indexPath.row] as? MyBookModel
        }
        return cell

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208/640*www
    }
    // 索引事件
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        tableView.scrollToRow(at:NSIndexPath(row: 0,section: index) as IndexPath, at: .top, animated: true)
        return index
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyListBookVc()
        var model = MyBookModel()
       
        if !searchController.isActive{
            let value:NSArray = allSource.object(forKey: indexDataSource[indexPath.section]) as! NSArray
            model =  (value[indexPath.row] as? MyBookModel)!
//            print(-indexPath.row-1)
            
            vc.numIdx = -10000
        }else{
            model =  (searchDataSource[indexPath.row] as? MyBookModel)!
            vc.numIdx = -10000
//            print(-indexPath.row-1)
        }
        vc.title = model.book
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchDataSource.removeAllObjects()
        // 对排序好的数据进行搜索
        let ary = HCSortString.getAllValues(fromDict: allSource as! [AnyHashable : Any])
        var ay:[Any] = ary as NSArray? as? [Any] ?? []
        if searchController.searchBar.text?.characters.count == 0{
            searchDataSource.addObjects(from: ay)
        }else{
            ay = ZYPinYinSearch.search(withOriginalArray: ay, andSearchText: searchController.searchBar.text, andSearchByPropertyName: "book")
            searchDataSource.addObjects(from: ay)
        }
        tableView.reloadData()
    }
    
}
class MyBookModel: NSObject,NSCoding{
    var img: String? = ""
    var book: String? = ""
    var name: String? = ""
    var text: String? = ""
    var html: [String]?
    var url:String? = ""
    var num:String = "0" // 加载漫画id
    var browsingHistory = "" //历史话
    var page = "0" // 历史页
    func encode(with aCoder: NSCoder) {
        aCoder.encode(img, forKey: "img")
        aCoder.encode(book, forKey: "book")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(text, forKey: "text")
        aCoder.encode(html, forKey: "html")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(browsingHistory, forKey: "browsingHistory")
        aCoder.encode(num, forKey: "num")
        aCoder.encode(page,forKey:"page")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        img = aDecoder.decodeObject(forKey: "img") as! String?
        book = aDecoder.decodeObject(forKey: "book") as! String?
        name = aDecoder.decodeObject(forKey: "name") as! String?
        text = aDecoder.decodeObject(forKey: "text") as! String?
        html = aDecoder.decodeObject(forKey: "html") as! [String]?
        url = aDecoder.decodeObject(forKey: "url") as! String?
        browsingHistory = aDecoder.decodeObject(forKey: "browsingHistory") as! String? ?? ""
        num = aDecoder.decodeObject(forKey: "num") as! String
        page = aDecoder.decodeObject(forKey: "page") as! String? ?? "0"
    }
    override init() {
        
    }
}
