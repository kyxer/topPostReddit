//
//  HomeController.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import UIKit

enum TableState:String {
    case loading = "loading"
    case error = "error"
    case success = "success"
}

class HomeController: UIViewController {
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.register(UINib(nibName:"PostCell", bundle:nil), forCellReuseIdentifier: self.cellIdentifier)
        table.register(TableLoadingView.self, forHeaderFooterViewReuseIdentifier: self.footerIdentifier)
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 140
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var refreshControl:UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshValueChanged), for: .valueChanged)
        return refresh
    }()
    
    var posts:[Post] = []
    let cellIdentifier = "cellIdentifier"
    let footerIdentifier = "footerIdentifier"
    let generalIdentifier = "generalIdentifier"
    var after:String?
    var state:TableState = .loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func refreshValueChanged(){
        if state != .loading {
            state = .loading
            fetchPost(nextPage: nil)
        }
    }
    
    func loadMore(after:String?){
        if state != .loading {
            state = .loading
            tableView.reloadData()
            fetchPost(nextPage: after)
        }
    }
    
    func fetchPost(nextPage:String?){
        ApiService.sharedInstance.fetchTopPosts(nextPage:nextPage, completion: { posts, after in
            self.after = after
            if nextPage == nil {
                self.posts = posts
            } else {
                self.posts = self.posts + posts
            }
            self.state = .success
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }, error: { error in
            print(error ?? "Error is nil")
            if self.posts.count == 0 {
                self.posts = Utils.loadData()
            }
            self.state = .error
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func setup(){
        navigationItem.title = "Top Post Reddit"
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view.backgroundColor = .white
        fetchPost(nextPage: nil)
        
    }
}

extension HomeController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if state == .loading {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if state == .loading {
            let cell =  tableView.dequeueReusableHeaderFooterView(withIdentifier: footerIdentifier) as! TableLoadingView
            cell.startAnimating()
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostCell
        cell.configure(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = posts.count
        if total - indexPath.row <= 2 && state == .success {
            loadMore(after: after)
        }
    }
}

