//
//  MyNavigationController.swift
//  shoppers
//
//  Created by 高子雄 on 2017/2/16.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {
    let FontGrayColor:UIColor = UIColor(red: (51/255.0), green: (51/255.0), blue: (51/255.0), alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar:UINavigationBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName:FontGrayColor]
        let barItemButton = UIBarButtonItem.appearance()
        barItemButton.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.normal)
        barItemButton.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState.highlighted)
        self.navigationBar.barTintColor = UIColor(red: (255/255.0), green: (215/255.0), blue: (5/255.0), alpha: 1)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:UIBarButtonItemStyle.done, target: nil, action: nil)
        if self.viewControllers.count == 0 {
            viewController.hidesBottomBarWhenPushed = false
            super.pushViewController(viewController, animated: animated)
        }else{
            viewController.hidesBottomBarWhenPushed = true
            super.pushViewController(viewController, animated: animated)
        }
    }
    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
