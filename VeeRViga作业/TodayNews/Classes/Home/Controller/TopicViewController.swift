//
//  TopicViewController.swift
//  TodayNews-Swift
//
//  Created by 杨蒙 on 2017/6/11.
//  Copyright © 2017年 杨蒙. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {

    // 记录点击的顶部标题
    var topicTitle: TopicTitle?
    
    // 存放新闻主题的数组
    fileprivate var newsTopics = [WeiTouTiao]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        tableView.tableHeaderView =  noLoginHeaderView
        
        NetworkTool.loadHomeCategoryNewsFeed(category: topicTitle!.category!) { (nowTime, newsTopics) in
            self.newsTopics = newsTopics
            self.tableView.reloadData()
        }
    }
    
    // 头部视图
    fileprivate lazy var noLoginHeaderView: NoLoginHeaderView = {
        let noLoginHeaderView = NoLoginHeaderView.headerView()
        noLoginHeaderView.delegate = self
        noLoginHeaderView.pictureGallery()
        return noLoginHeaderView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 232
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0)

        tableView.backgroundColor = UIColor.globalBackgroundColor()
        return tableView
    }()
    
}

extension TopicViewController: NoLoginHeaderViewDelegate {
    /// 更多登录方式按钮点击
    func noLoginHeaderViewMoreLoginButotnClicked() {
        let storyboard = UIStoryboard(name: "MoreLoginViewController", bundle: nil)
        let moreLoginVC = storyboard.instantiateViewController(withIdentifier: "MoreLoginViewController") as! MoreLoginViewController
        moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - 40)))
        present(moreLoginVC, animated: true, completion: nil)
    }
}

extension TopicViewController {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(view)
        }
    }
}

// MARK: - Table view data source
extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if topicTitle!.category == "video" {
//            return screenHeight * 0.4
//        } else if topicTitle!.category == "subscription" { // 头条号
//            return 68
//        }
//        let weitoutiao = newsTopics[indexPath.row]
//        return weitoutiao.homeCellHeight!
        return 30
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topicTitle!.category == "subscription" {
            return 10
        } else {
            return newsTopics.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if topicTitle!.category == "subscription" { // 头条号
            let cell = Bundle.main.loadNibNamed(String(describing: ToutiaohaoCell.self), owner: nil, options: nil)?.last as! ToutiaohaoCell
//            cell.myConcern = myConcerns[indexPath.row]
            return cell
        }
        let cell = Bundle.main.loadNibNamed(String(describing: HomeTopicCell.self), owner: nil, options: nil)?.last as! HomeTopicCell
        cell.weitoutiao = newsTopics[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if topicTitle!.category == "video" {
//            let videoDetailVC = VideoDetailController()
//            //        videoDetailVC.videoTopic = newsTopics[indexPath.row]
//            navigationController?.pushViewController(videoDetailVC, animated: true)
        } else {
            let topicDetailVC = TopicDetailController()
            navigationController?.pushViewController(topicDetailVC, animated: true)
        }
        
    }
}

