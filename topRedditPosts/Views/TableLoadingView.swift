//
//  TableLoadingView.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import UIKit

class TableLoadingView: UITableViewHeaderFooterView {
    
    let activityIndicator:UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func startAnimating(){
        activityIndicator.startAnimating()
    }
    
}
