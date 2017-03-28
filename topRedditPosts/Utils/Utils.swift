//
//  Utils.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import UIKit
import CoreData

class Utils {

    static func startNetworkActivityIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    static func stopNetworkActivityIndicator(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    static func getStringDate(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy h:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func clearData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            do {
                let entities = ["Post"]
                
                for entity in entities {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    for object in objects! {
                        context.delete(object)
                    }
                }
                try(context.save())
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
    static func loadData()->[Post] {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            var posts = [Post]()
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Post")
            do {
                if let p = try(context.fetch(fetchRequest)) as? [Post] {
                    posts = p
                }
            } catch let err {
                print(err)
                return []
            }
            return posts
        }
        return []
    }
    
    
}
