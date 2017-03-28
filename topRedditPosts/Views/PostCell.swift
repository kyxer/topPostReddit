//
//  PostCell.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import UIKit
import SDWebImage

class PostCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postImageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(post:Post){
        titleLabel.text = post.title
        authorLabel.text = post.author
        commentLabel.text = "Comments: \(post.comments)"
        postImageView.image = nil
        if let date = post.date as? Date {
            dateLabel.text = Utils.getStringDate(date: date)
        } else {
            dateLabel.text = ""
        }
        
        if let url = post.thumbnail, url != "" {
            postImageViewHeightConstraint.constant = 150
            postImageView.isHidden = false
            let u = URL(string: url)
            postImageView.sd_setImage(with: u)
        } else {
            postImageViewHeightConstraint.constant = 0
            postImageView.isHidden = true
        }
    }
    
    
}
