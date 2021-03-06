//
//  JFHomeViewController.swift
//  JianSan Wallpaper
//
//  Created by zhoujianfeng on 16/4/26.
//  Copyright © 2016年 六阿哥. All rights reserved.
//

import UIKit

class JFHomeViewController: UIViewController, JFCategoriesMenuViewDelegate {
    
    // 上一个分类的下标
    var preIndex: Int = 0

    // 写死的数据
    let itemIcons = ["category_icon_dx", "category_icon_tc", "category_icon_cy", "category_icon_wh", "category_icon_cj", "category_icon_tm", "category_icon_qx", "category_icon_sl", "category_icon_wd", "category_icon_mj", "category_icon_gb", "category_icon_cyun", "category_icon_cg"]
    let itemTitles = ["大侠", "天策", "纯阳", "万花", "藏剑", "唐门", "七秀", "少林", "五毒", "明教", "丐帮", "苍云", "长歌"]
    let itemCategories = ["dx", "tc", "cy", "wh", "cj", "tm", "qx", "sl", "wd", "mj", "gb", "cyun", "cg"]
    
    /// 分类视图
    lazy var categoriesMenuView: JFCategoriesMenuView = {
        let categoriesMenuView = JFCategoriesMenuView(items: self.categoriesModels)
        categoriesMenuView.delegate = self
        return categoriesMenuView
    }()
    
    /// 分类模型数组
    var categoriesModels: [JFCategoryModel] = []
    
    /// 当前分类
    var currentCategoryModel: JFCategoryModel? {
        didSet {
            self.titleButton.setImage(UIImage(named: self.currentCategoryModel!.iconName!), forState: UIControlState.Normal)
            self.titleButton.setTitle(self.currentCategoryModel!.title!, forState: UIControlState.Normal)
            self.titleButton.sizeToFit()
            
            // 将上一个控制器视图移除
            let preTableViewVc = childViewControllers[preIndex] as! JFTableViewController
            preTableViewVc.view.removeFromSuperview()
            
            // 获取需要展示的控制器
            let currentIndex = categoriesModels.indexOf(currentCategoryModel!)!
            let tableViewVc = childViewControllers[currentIndex] as! JFTableViewController
            tableViewVc.view.frame = view.bounds
            view.addSubview(tableViewVc.view)
            
            if preIndex != currentIndex {
                // 切换控制器动画
                let animation = CATransition()
                animation.type = kCATransitionPush
                animation.subtype = currentIndex > preIndex ? kCATransitionFromRight : kCATransitionFromLeft
                animation.duration = 0.5
                view.layer.addAnimation(animation, forKey: nil)
            }
            
            // 传递数据
            tableViewVc.currentCategoryModel = currentCategoryModel
        }
    }
    
    /// 标题按钮
    lazy var titleButton: UIButton! = {
        let titleButton = UIButton(type: UIButtonType.Custom)
        titleButton.setTitleColor(TITLE_COLOR, forState: UIControlState.Normal)
        titleButton.titleLabel?.font = TITLE_FONT
        titleButton.adjustsImageWhenHighlighted = false
        self.navigationItem.titleView = titleButton
        return titleButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 导航栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_category")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(didTappedLeftMenuItem))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigation_setting")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(didTappedRightSettingItem))
        
        // 准备数据
        prepareData()
        
        // 左滑手势
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(_:)))
        leftSwipeGesture.direction = .Left
        view.addGestureRecognizer(leftSwipeGesture)
        
        // 右滑手势
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeView(_:)))
        rightSwipeGesture.direction = .Right
        view.addGestureRecognizer(rightSwipeGesture)
        
    }
    
    /**
     滑动手势
     */
    func swipeView(gestureRecognizer: UISwipeGestureRecognizer) -> Void {
        
        preIndex = categoriesModels.indexOf(currentCategoryModel!)!
        
        if gestureRecognizer.direction == .Right {
            if preIndex > 0 {
                currentCategoryModel = categoriesModels[preIndex - 1]
            }
        } else {
            if preIndex < categoriesModels.count - 1 {
                currentCategoryModel = categoriesModels[preIndex + 1]
            }
        }
    }
    
    /**
     准备数据
     */
    func prepareData() -> Void {
        // 转模型
        for index in 0..<itemIcons.count {
            let categoryModel = JFCategoryModel(dict: ["iconName" : itemIcons[index], "title" : itemTitles[index], "category" : itemCategories[index]])
            categoriesModels.append(categoryModel)
            
            // 添加所有分类控制器
            let tableViewVc = JFTableViewController()
            addChildViewController(tableViewVc)
            
            // 设置默认控制器
            if index == 0 {
                currentCategoryModel = categoryModel
            }
        }
        
    }
    
    /**
     左上角按钮事件
     */
    @objc private func didTappedLeftMenuItem() {
        categoriesMenuView.show()
    }
    
    /**
     右上角按钮事件
     */
    @objc private func didTappedRightSettingItem() {
        navigationController?.pushViewController(JFProfileTableViewController(), animated: true)
    }
    
    // MARK: - JFCategoriesMenuViewDelegate
    func didTappedItem(item: JFCategoryModel) {
        
        // 存储上一个分类下标
        preIndex = categoriesModels.indexOf(currentCategoryModel!)!
        currentCategoryModel = item
    }

}
