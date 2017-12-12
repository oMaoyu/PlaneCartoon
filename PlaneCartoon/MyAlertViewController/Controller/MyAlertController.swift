//
//  MyAlertController.swift
//  employees
//
//  Created by 高子雄 on 2017/3/30.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyAlertController: UIViewController ,UIViewControllerTransitioningDelegate{
    
    
    //蒙版
    private let coverView:UIButton = UIButton()
    //标题
    var text:String? = ""
    private let titleLabel:UILabel = UILabel()
    private var txtColor:UIColor?
    //内容
    var masg:String? = ""
    private let messageLabel:UILabel = UILabel()
    private var msgColor:UIColor?
    //按钮数组
    private var actiontBtnArray:[UIButton] = [UIButton]()
    
    //数组
    private var actions:[MyAlertaction] = [MyAlertaction]()
    
    //具体内容
    var message:String?
    // 设置加载图片
    lazy var img : UIImageView! = {
        let imag = UIImageView()
        
        var array = Array<UIImage>()
        
        for i in 1...12{
            let bundle = Bundle.main.path(forResource: "旋转\(i)", ofType: "png")
            let imag = UIImage(contentsOfFile: bundle!)
            array.append(imag!)
        }
        imag.animationImages = array
        imag.animationRepeatCount = 0
        imag.animationDuration = 12 * 0.05
        imag.startAnimating()
        return imag
    }()
    
    //初始化
    public convenience init(title: String?, message: String?){
        self.init()
        self.modalPresentationStyle  =  .custom
        //标题
        if let t =  title {
            text = t
        }
        txtColor = MyNewSwift.shared().transferStringToColor("#d04c4b")

        //内容
        if let msg  = message{
            masg =  msg
        }
        msgColor = MyNewSwift.shared().transferStringToColor("#ffffff")
        self.transitioningDelegate = self
    }
    
    func hiddenView(isHidden:Bool)  {
        coverView.isUserInteractionEnabled = !isHidden
        titleLabel.isHidden = isHidden
        messageLabel.isHidden = isHidden
        img.isHidden = !isHidden
        img.frame = CGRect(x: 0, y: 0, width: 640/640*www, height: 723/640*www)
        img.center = view.center
        view.addSubview(img)
        messageLabel.text = masg
        titleLabel.text = text
    }
    
    //加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        //蒙版
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.9
        coverView.tag = -1
        coverView.addTarget(self, action: #selector(actionBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        view.addSubview(coverView)
        //标题
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = NSTextAlignment.center
        
        titleLabel.textColor = txtColor
        view.addSubview(titleLabel)
        //内容
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 15)
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.textColor = msgColor
        
        messageLabel.text = masg
        titleLabel.text = text
        view.addSubview(messageLabel)
        
        //移除按钮
        for btn in actiontBtnArray{
            btn.removeFromSuperview()
        }
        actiontBtnArray.removeAll()
        //添加
        for action in actions{
            
            let actionBtn:UIButton = UIButton()
            actionBtn.tag  = actiontBtnArray.count
            actionBtn.setTitle(action.title, for: UIControlState.normal)
            actionBtn.setTitle(action.title, for: UIControlState.selected)
            actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            actionBtn.setTitleColor(action.actionColor, for: .normal)
            actionBtn.layer.borderWidth = 1.5
            actionBtn.layer.cornerRadius = 15
            actionBtn.backgroundColor = UIColor.clear
            actionBtn.layer.borderColor = action.actionColor?.cgColor
            actionBtn.addTarget(self, action: #selector(actionBtnClick(btn:)), for: .touchUpInside)
            view.addSubview(actionBtn)
            actiontBtnArray.append(actionBtn)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        coverView.frame = view.bounds
        titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: www * 0.656), size: (titleLabel.text?.boundingRect(size: CGSize(width: www*0.8, height: hhh), font: titleLabel.font))!)
        titleLabel.center.x = view.center.x
        
        messageLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY + 20, width: www, height: 50)
       
        
        let jg : CGFloat = www * 0.05
        let btnW : CGFloat = (www - (jg * CGFloat((actiontBtnArray.count + 1)))) / CGFloat(actiontBtnArray.count)
        for btn in actiontBtnArray{
            btn.frame = CGRect(x: jg*CGFloat(btn.tag+1)+CGFloat(btn.tag)*btnW, y: messageLabel.frame.maxY+30, width: btnW, height: 40)
        }
    }
    func dismiss(){
        img.stopAnimating()
        img.animationImages = nil
        img.removeFromSuperview()
        view.removeFromSuperview()
        transitioningDelegate = nil
        
    }
    //action按钮点击
    func actionBtnClick(btn:UIButton)  {
        dismiss(animated: true, completion: {
            if btn.tag != -1 {
                let action =  self.actions[btn.tag]
                if let ac =  action.handler{
                    ac(action)
                }
            }
        })
    }
    //添加action
    func addAction(actionTitle:String,handler:@escaping MyAlertaction.MyActionClosure) {
        let alertAction:MyAlertaction = MyAlertaction(title: actionTitle, color: UIColor.white, handler: handler)
        addAction(action: alertAction)
    }
    //添加action
    func  addAction(action:MyAlertaction) {
        actions.append(action)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.modalPresentationStyle  = .custom
        let presentTrasition:MyAlertPresentTransitioning = MyAlertPresentTransitioning()
        return presentTrasition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.modalPresentationStyle  =  .custom
        let dismissTrasition:MyAlertDismissTransitioning = MyAlertDismissTransitioning()
        return dismissTrasition
    }
    
    
    

    
    
}
