//
//  Post+Extension.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import Foundation
import UIKit

extension Post {
    
    func fillFrom(dictionary:[String:AnyObject]){
        for (key,value) in dictionary {
            
            if key == "title" {
                if let unwrappedValue = value as? String{
                    title = unwrappedValue
                }
            } else if key == "author" {
                if let unwrappedValue = value as? String {
                    author = unwrappedValue
                }
            } else if key == "num_comments" {
                if let unwrappedValue = value as? Int32 {
                    comments = unwrappedValue
                }
            } else if key == "thumbnail" {
                
                if let unwrappedValue = value as? String {
                    if let url = URL(string: unwrappedValue),
                        UIApplication.shared.canOpenURL(url) {
                        thumbnail = unwrappedValue
                    } else {
                        thumbnail = ""
                    }
                }
            } else if key == "subreddit" {
                if let unwrappedValue = value as? String {
                    subreddit = unwrappedValue
                }
            } else if key == "created" {
                if let unwrappedValue = value as? Int {
                    date = Date(timeIntervalSince1970: TimeInterval(unwrappedValue)) as NSDate?
                }
            }
        }
    }
    
}
