//
//  ZBEmoticonLayout.swift
//  Weibo
//
//  Created by 恒信永利 on 2017/11/30.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

import UIKit
//表情集合视图的布局
class ZBEmoticonLayout: UICollectionViewFlowLayout {
    //oc的preparelayout
    override func prepare() {
        super.prepare()
        //在此方法中 CollectionView 大小以及确定
        guard let collectionView = collectionView else {
            return
        }
        //尺寸
        itemSize = collectionView.bounds.size
        //间距
        //设定滚动方向 水平方向滚动，cell垂直方向布局，垂直方向滚动，cell水平方向布局
        scrollDirection = .horizontal
    }
    
}
