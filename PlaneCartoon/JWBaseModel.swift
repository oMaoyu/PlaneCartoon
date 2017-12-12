//
//  BaseModel.swift
//  OAManagerSystem
//
//  Created by 朱建伟 on 16/9/30.
//  Copyright © 2016年 zhujianwei. All rights reserved.
//
//import MJExtension
import UIKit

class JWBaseModel: NSObject,NSCoding{
    
    //初始化
    convenience init(keyValues:Any?) {
        
        //初始化
        self.init()
        
        if keyValues != nil {
            let object:NSObject = keyValues as! NSObject
            
            if object.isKind(of: NSDictionary.classForCoder()){
                self.setValuesWithKeys(dict: object as? NSDictionary)
            }else{
                self.setValuesForKeys(object as! [String : Any])
            }
        }else{
            print("初始化失败 init(keyValues：)  \(NSStringFromClass(self.classForCoder))")
        }
       
    }
    
     
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if let v = value{
            //强转
            do {
                let object:NSObject = v as! NSObject
                if object.isKind(of: NSNull.classForCoder()) || (object.isKind(of: NSString.classForCoder())&&object.isEqual("<null>")){
                    return
                }
                
            } catch  {
                //类型转换出现异常
                
            }
            super.setValue(v, forKey: key)
        }
    }
    
    
    //设置数据
    func setValuesWithKeys(dict:NSDictionary?){
    
        if let kvs = dict{
          var otherKeys = self.propertyValueTypeMapping()
          var  otherArrayKeys = self.propertyArrayValueTypeMapping()
            
            for key in kvs.allKeys as! [String]{
                 let value =  kvs[key]
                if let v = value{
                    //模型属性
                    if otherKeys.keys.contains(key){
                          let model = otherKeys[key]
                        
                        model?.setValuesWithKeys(dict: v as? NSDictionary)
                        
                        self.setValue(model, forKeyPath: key)
                    }else if otherArrayKeys.keys.contains(key){
                        let modelCls = otherArrayKeys[key]?.classForCoder
                        let modelArray =  modelCls?.modelsArray(keyValuesArray: v)
                        self.setValue(modelArray, forKeyPath: key)
                    }else{
                        self.setValue(v, forKeyPath: key)
                    }
                    
                }
            }
        }
    }
    
    
    func propertyValueTypeMapping() -> [String:JWBaseModel] {
        return [:]
    }
    
    func propertyArrayValueTypeMapping() -> [String:JWBaseModel] {
        return [:]
    }
    
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("未定义:\(key) \(NSStringFromClass(self.classForCoder))")
    }
    
    
    //返回数组
    class func modelsArray(keyValuesArray:Any?) -> [Any]? {
        var  array:[Any] = [Any]()
        if let kvs =  keyValuesArray{
            
            let object:NSObject = kvs as! NSObject
            if object.isKind(of: NSNull.classForCoder()){ return array}
            //判断
            if object.isKind(of: NSArray.classForCoder()){
                //遍历
                for  ele in object as! NSArray{
                  let model =  self.init()
                  model.setValuesWithKeys(dict: ele as! NSDictionary)
                  array.append(model)
                }
            }else{
                //遍历
                for ele in object as! [[String:Any]]
                {
                    let model =  self.init()
                    model.setValuesForKeys(ele)
                    array.append(model)
                }
            }
        }
        
        return array
        
    }
    
    
    //拷贝值
    func copyValueFromModel(model:NSObject) {
        if model.isKind(of: self.classForCoder){
            var count:UInt32 = 0
            let ivarList = class_copyIvarList(model.classForCoder, &count)
            let ivarCount:UInt32 = numericCast(count)
            for  i in 0..<ivarCount
            {
                let ivar:Ivar =  ivarList![Int(i)]!
                let ivarCName = ivar_getName(ivar)
                let ivarName = String(cString: ivarCName!)
                
                let value =  model.value(forKeyPath: ivarName)
                
                
                
                if let v =  value{
                    self.setValue(v, forKeyPath: ivarName)
                }
                
            }
        }
    }
    
    
    //初始化
    required init?(coder aDecoder: NSCoder) {
        super.init()
        var count:UInt32 = 0
        let ivarList = class_copyIvarList(self.classForCoder, &count)
        let ivarCount:UInt32 = numericCast(count)
         for  i in 0..<ivarCount
         {
            let ivar:Ivar =  ivarList![Int(i)]!
            let ivarCName = ivar_getName(ivar)
            let ivarName = String(cString: ivarCName!)
            let value:Any? =  aDecoder.decodeObject(forKey: ivarName)
            if let v =  value{
                self.setValue(v, forKeyPath: ivarName)
            }
         }
    }
    
    
    //存储
    func encode(with aCoder: NSCoder) {
        var count:UInt32 = 0
        let ivarList = class_copyIvarList(self.classForCoder, &count)
        
        let ivarCount:UInt32 = numericCast(count)
        
        for  i in 0..<ivarCount
        {
            let ivar:Ivar =  ivarList![Int(i)]!
            let ivarCName = ivar_getName(ivar)
            let ivarName = String(cString: ivarCName!)
            let value:Any? =  self.value(forKeyPath: ivarName)
            
            if let v =  value{
                aCoder.encode(v, forKey: ivarName)
            }
        }
    }
    
    required override init() {
        super.init()
    }
}
