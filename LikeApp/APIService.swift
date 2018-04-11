//
//  APIService.swift
//  LikeApp
//
//  Created by Sukumar Anup Sukumaran on 11/04/18.
//  Copyright © 2018 AssaRadviewTech. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


enum Result <T> {
    case Success(T)
    case Error(String)
}

class baseUrl {
    //http://mobiroidtec.in/laundry/Webservice/
    static let link = "https://rss.itunes.apple.com/api/v1/in/ios-apps/top-free/all/10/explicit.json"
}

class APIService: NSObject {
    
    static var sharedInstance = APIService()
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> ()) {
        Alamofire.request(baseUrl.link, method: .get, parameters: ["":""], encoding: JSONEncoding.default, headers: [:]).validate().responseJSON { (response) in
            switch response.result {
                
            case .success:
                print(":validi success")
                let json = response.result.value as AnyObject
                
                guard let itemsJsonArray = json.value(forKeyPath: "feed.results") as?  [[String: AnyObject]] else {
                    completion(.Error("missing"))
                    return
                }
                
                completion(.Success(itemsJsonArray))
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
                 completion(.Error("regi"))
                
            }
        }
    }
    
    
    
    
}
