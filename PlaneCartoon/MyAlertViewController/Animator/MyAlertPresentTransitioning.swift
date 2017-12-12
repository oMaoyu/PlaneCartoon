//
//  MyAlertPresentTransitioning.swift
//  employees
//
//  Created by 高子雄 on 2017/3/29.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

import UIKit

class MyAlertPresentTransitioning: NSObject,UIViewControllerAnimatedTransitioning ,CAAnimationDelegate{
    
    
    //返回动画之行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    //执行动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //动画容器
        let containerView = transitionContext.containerView
        
        //fromView
        let fromView  = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        //toView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        //添加到容器上
        
        if let fromV = fromView {
            fromV.frame = UIScreen.main.bounds
            containerView.addSubview(fromV)
        }
        
        if let toV =  toView{
            toV.frame = UIScreen.main.bounds
            containerView.addSubview(toV)
            //动画
            let animation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = 1
            animation.isRemovedOnCompletion = false
            animation.duration = self.transitionDuration(using: transitionContext)
            animation.fillMode = kCAFillModeForwards
            animation.delegate = self
            animation.setValue(transitionContext, forKey: "transitionContext")
            toV.layer.add(animation, forKey: "opacityAnimator")
            
        }else{
            transitionContext.completeTransition(false)
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let value = anim.value(forKeyPath: "transitionContext"){
            if let transitionContext:UIViewControllerContextTransitioning = value as? UIViewControllerContextTransitioning{
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
}
