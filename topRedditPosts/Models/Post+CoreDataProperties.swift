//
//  Post+CoreDataProperties.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post");
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var subreddit: String?
    @NSManaged public var comments: Int32
    @NSManaged public var thumbnail: String?

}
