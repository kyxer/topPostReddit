//
//  ApiServices.swift
//  topRedditPosts
//
//  Created by IT-German on 3/28/17.
//  Copyright © 2017 GermanMendoza. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class ApiService: NSObject {
    
    override init(){
        super.init()
    }
    
    class var sharedInstance: ApiService {
        struct Singleton {
            static let instance = ApiService()
        }
        return Singleton.instance
    }
    
    static func headers()->[String:String]{
        let array:[String:String] = [:]
        //if let accessToken = Global.getAccessToken() {
        //    array["Authorization"] = "Bearer \(accessToken)"
        //}
        return array
    }
    
    func fetchTopPosts(nextPage:String?, completion:@escaping ([Post], String?)->(), error:@escaping (AnyObject?)->()) {
        var url = "https://www.reddit.com/top/.json"
        if let n = nextPage {
            url = "\(url)?after=\(n)"
        }
        doRequest(url, method: .get, parameters: nil, result: { (response) in
            if let unwrappedResponse = response as? [String:AnyObject],
                let children = unwrappedResponse["children"] as? [AnyObject],
                let after = unwrappedResponse["after"] as? String {
                
                let delegate = UIApplication.shared.delegate as? AppDelegate
                if let context = delegate?.persistentContainer.viewContext {
                    if nextPage == nil {
                        Utils.clearData()
                    }
                    let posts = children.map({ dictionary -> Post in
                        let post = NSEntityDescription.insertNewObject(forEntityName: "Post", into: context) as! Post
                        post.fillFrom(dictionary: dictionary["data"] as! [String:AnyObject])
                        return post
                    })
                    do {
                        if nextPage == nil {
                            try context.save()
                        }
                    } catch let err {
                        error("Error when save data" as AnyObject?)
                        return
                    }
                    completion(posts, after)
                    return
                }
            }  else {
                error("Invalid response" as AnyObject?)
            }
        }, errorHandler: error)
    }
    
    
    func doRequest(_ url: String,
                   method:Alamofire.HTTPMethod,
                   parameters: [String: AnyObject]?,
                   headers:[String:String] = ApiService.headers(),
                   result:@escaping (_ response:AnyObject?) -> Void,
                   errorHandler:((AnyObject?)->Void)?) -> Void {
        
        print(url)
        print(parameters ?? "params nil")
        print(headers)
        
        Utils.startNetworkActivityIndicator()
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            Utils.stopNetworkActivityIndicator()
            switch response.result{
            case .success( _):
                
                guard let unwrappedData = response.data else {
                    if let unwrappedErrorHandler = errorHandler {
                        unwrappedErrorHandler("Data is nil" as AnyObject?)
                    }
                    return
                }
                
                
                let json = try? JSONSerialization.jsonObject(with: unwrappedData)
                
                if let dictionary = json as? [String:AnyObject] {
                    if let data = dictionary["data"] {
                        result(data as AnyObject?)
                    } else {
                        result(dictionary as AnyObject?)
                    }
                    return
                } else {
                    result(nil)
                }
                
                break
                
            case .failure(let error):
                if let unwrappedErrorHandler = errorHandler {
                    unwrappedErrorHandler(error as AnyObject?)
                }
                break
                
            }
        }
    }
}
