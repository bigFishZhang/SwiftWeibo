//
//  WBStatusViewModel.swift
//  Weibo
//
//  Created by zhangzb on 2017/11/2.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

import Foundation
//单条微博视图模型

//没有继承任何父类 遵守 CustomStringConvertible协议 实现description计算型属性 输出调试信息
/*
1,尽量少计算，所有需要显示的控件提前准备好
2，控件上不要设置设置圆角半径，所有的图像渲染的属性要注意
3，不要动态创建控件，要体检创建好，在显示的时候判断 隐藏还是显示
4，cell中控件的层次越少越好
 
 */



class WBStatusViewModel:CustomStringConvertible {
    //微博模型
    var status = WBStatus()
    var memberIcon:UIImage?
    var vipIcon:UIImage?
    //按钮文字
    var retweetStr:String?
    var commentStr:String?
    var likeStr:String?
    //图片尺寸
    var pictureViewSize = CGSize()
    //如果是被转发的微博，原创微博没有图
    var picURLs : [WBStatusPicture]?{
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    //被转发微博文字
    var retweetedText : String?
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model:WBStatus) {
        self.status = model
        if (model.user?.mbrank) ?? 0 > 0 && ((model.user?.mbrank)) ?? 0 < 7{
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
      //verified_type
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named:"avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named:"avatar_enterprise_vip")
        case 200:
            vipIcon = UIImage(named:"avatar_grassroot")
        default:
            break
            
        }
        
        retweetStr = countStr(count: status.reposts_count, defaultStr: "转发")
        
        commentStr = countStr(count: status.comment_count, defaultStr: "评论")
     
        likeStr = countStr(count: status.attitudes_count, defaultStr: "赞")
        
        //计算配图视图大小
        pictureViewSize = calcPictureViewSize(count: picURLs?.count ?? 0)
        

        let screen_name = status.retweeted_status?.user?.screen_name ?? ""
        
        let retweeted_Text = status.retweeted_status?.text ?? ""
        
        //被转发微博文字
        retweetedText = "@" + screen_name + ":" + retweeted_Text
        
        
    }
    
    
    var description: String{
        return status.description
    }
    /// 一个数字 给描述结果
    ///
    /// - Returns: 结果
    private func countStr(count:Int,defaultStr:String)->String{
        
        if count == 0{
            return defaultStr
        }
        
        if count < 10000{
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    
    private func calcPictureViewSize(count:Int?) -> CGSize {
        
        if count == 0 || count == nil{
            return CGSize()
        }
    
        let row = ((count! - 1)  / 3) + 1
        
        let height = WBStatusPictureOutterMargin + (CGFloat(row)  * WBStatusPictureViewItemWidth) + CGFloat(row-1) * WBStatusPictureInnerMargin
        
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    
}
