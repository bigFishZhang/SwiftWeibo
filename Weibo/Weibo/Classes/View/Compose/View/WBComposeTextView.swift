//
//  WBComposeTextView.swift
//  Weibo
//
//  Created by 恒信永利 on 2017/11/29.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

import UIKit
 //撰写微博的文本视图
class WBComposeTextView: UITextView {
    private lazy var placeholderlabel = UILabel()
    override func awakeFromNib() {
        setupUI()
    }
  

}

private extension WBComposeTextView{
   func setupUI(){
     // 1 设置占位标签
    placeholderlabel.text = "分享新鲜事..."
    placeholderlabel.font = self.font
    placeholderlabel.textColor = UIColor.lightGray
    placeholderlabel.frame.origin = CGPoint(x: 5, y: 8)
    placeholderlabel.sizeToFit()
    
    
    
    }
    
    
}