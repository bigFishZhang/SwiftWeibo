//
//  MainViewController.swift
//  Weibo
//
//  Created by zhangzb on 2017/7/28.
//  Copyright © 2017年 zhangzb. All rights reserved.
//  private当前类当前代码块访问 fileprivate当前文件内访问 @objc 允许函数在“运行时”通过OC的消息机制 被调用

import UIKit

class MainViewController: UITabBarController {
    //定时器
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildController()
        setupComposeButton()
        setupTimer()
    
    }
    //销毁
    deinit {
        timer?.invalidate()
    }
    
    //修改横竖设置 portrait 竖屏 landscape 横屏 在需要横屏的时候单独处理
    //设置支持的方向后，当前控制器以及子控制器都会遵守这个方向
    //视频播放 用modal来展示，旋转
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return UIInterfaceOrientationMask.portrait
    
    }
    
    
    //私用控件
    fileprivate lazy var composeButton : UIButton = UIButton.cz_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    //撰写微博
    @objc fileprivate func composeStatus() -> () {
        print("撰写微博")
        //测试方向旋转
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.cz_random()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true) {
        }
        
    }
    
}
// MARK: -时钟
extension MainViewController{
    func setupTimer() -> () {
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector:#selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    // 时钟触发方法
    @objc private func updateTimer(){
        NetWorkManager.shared.unreadCount { (count) in
            print("检测到\(count)条新微博")
            //设置首页tab bageNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            //ios8.0后要用户授权后才能显示
            UIApplication.shared.applicationIconBadgeNumber =  count
            
        }
        
        
    }
    
    
    
    
}


/* extension类似oc分类，切分代码块
   可以把相近功能的函数放在一个extension中便于维护
   extension扩展只能添加些的计算属性，但不能添加存储属性，也不能像已有属性添加属性观察
 */
 extension MainViewController {
    //设置添加按钮
   fileprivate func setupComposeButton(){
        tabBar.addSubview(composeButton)
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count - 1//向内缩进的宽度减少，让按钮的宽度变大，盖住容错点，防止点击穿透
        composeButton.frame = tabBar.bounds.insetBy(dx: 2*w, dy: 0)
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    
    }
    //设置所有子控制器
   fileprivate  func setupChildController(){
    //0.获取沙盒的路径
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let jsonPath = (docDir as NSString).appendingPathComponent("MainVC.json")
    var data  = NSData(contentsOfFile: jsonPath)
    if data == nil{
        //从Bundle 加载data
        let path =  Bundle.main.path(forResource: "MainVC.json", ofType: nil)
        data  = NSData(contentsOfFile: path!)
    }
    //从bundle 中加载 json  1 路径 2 加载data 3 反序列化
    //3.将Data转成数组
    guard  let anyObject = try? JSONSerialization.jsonObject(with: data! as Data, options: .mutableContainers)
        else {
        return
    }
    guard let array = anyObject as? [[String : AnyObject]] else{
        return
    }
    //遍历数组，循环创建控制器数组
        var arrarM = [UIViewController]()
        for dict in array {
            //把生成的控制器加入数组
            arrarM.append(controller(dict: dict))
        }
       //设置控制器子控制器
        viewControllers = arrarM
    
    }
    
    //使用字典创建一个子控制器
    // dict: clsName titile imageName

   fileprivate  func controller(dict:[String:AnyObject])->UIViewController{
        //1，取得字典内容
        guard let clsName =   dict["clsName"] as AnyObject?,
            let title =     dict["title"] as AnyObject?,
            let imageName =  dict["imageName"] as AnyObject?,
            let cls = NSClassFromString(Bundle.main.namespace+"."+(clsName as! String)) as? BaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String:String]
            else{
                return UIViewController()
        }
        //2，创建视图控制器
        let vc = cls.init()
        vc.title = title as? String
        //访客视图的数组赋值
        vc.visitorInfoDic = visitorDict
        //3, 设置图标
        vc.tabBarItem.image = UIImage(named: "tabbar_"+(imageName as! String))
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+(imageName as! String)+"_selected")?.withRenderingMode(.alwaysOriginal)
        //4,设置标题样式
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.orange],
                                             for: .selected)
         //系统默认12号字 ，要设置normal 字体大小
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 12)],
                                             for: UIControlState.normal)
        
        //实例化导航控制器的时候，会调用push方法将rootVC压栈
        let nav = MainNavigationController(rootViewController: vc)
        return nav
        
        
    }
    

    
}

