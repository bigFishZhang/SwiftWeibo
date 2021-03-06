//
//  WBStatus.swift
//  Weibo
//
//  Created by zhangzb on 2017/10/20.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

import UIKit
import YYModel
//新浪数据模型
class WBStatus: NSObject {
  //微博ID int类型在ipad2 iphone 5 /5c/4s/4 这些32位机器都无法正常使用 会溢出
  @objc  var id:Int64 = 0
  //微博信息
  @objc  var text:String?
  //转发数
  @objc  var reposts_count:Int = 0
  // 评论数
  @objc  var comment_count:Int = 0
  //点赞数
  @objc  var attitudes_count:Int = 0
  //来源
  @objc  var source:String?{
        didSet{
            //在didSet中给source赋值不会再调用didSet
            source = "来自于 " + (source?.zb_href()?.text ?? "微博")
        }
    }
    
    //微博创建日期
    @objc var  creatDate:Date?
  //创建时间
    @objc  var created_at:String?{
        didSet{
            creatDate = Date.zb_sinaDate(string: created_at ?? "")
        }
    }
  //创建
  @objc  var pic_urls:[WBStatusPicture]?
    
  //微博用户
  @objc  var user:WBUser?
    
  //被转发的微博
  @objc  var retweeted_status:WBStatus?
    
  //重写 description的计算型属性
  override var description: String{
        return yy_modelDescription()
  }
  //类函数，告诉YY_Model 如果遇到数组类型的属性，数组中存放的对象是什么类
  //运行时 YY_Model字典转模型，发现数组属性 尝试调用类方法modelContainerPropertyGenericClass，实例化数组中的对象
  //NSArray中保存对象的类型是'id'类型 OC中的泛型是Swift退出后为了兼容添加的，在运行时的角度，并不知道数组中存放的什么类型的对象
  @objc class func modelContainerPropertyGenericClass() -> [String:AnyClass] {
    return ["pic_urls":WBStatusPicture.self]
  }
    
    
    
    

}
