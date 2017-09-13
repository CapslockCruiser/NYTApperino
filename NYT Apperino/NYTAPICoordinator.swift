//
//  NYTAPICoordinator.swift
//  NYT Apperino
//
//  Created by William Choi on 8/11/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import SwiftyJSON

final class NYTAPICoordinator{
    
    static let shared = NYTAPICoordinator()
    
    // MARK: Newswire
    static var newswireItems: [NewswireItem] = []
    
    func getNewswire(completion: (() -> Void)?){
        let url = URL(string: ("https://api.nytimes.com/svc/news/v3/content/all/all/json?api-key=\(NYTAPIKeys.newswireAPIKey)"))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET" //Documentation says to use POST, but the API actually only accetped GET.
//        let postBody = "api-key=\(NYTAPIKeys.newswireAPIKey)"
//        request.httpBody = postBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard error == nil else{ assertionFailure("Error while getting data in NYTAPICoordinator.getNewswire"); return }
            let json = JSON(data!)
            
            
            for result in json["results"].arrayValue{
                if let nwItem = NewswireItem(result: result){
                    NYTAPICoordinator.newswireItems.append(nwItem)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.newswireNotificationName), object: nil)
                }
            }

            completion?()
        }.resume()
    }
    
    // MARK: Top Stories
    static var topStoriesItems: [TopStoriesItem] = []
    
    func getTopStories(completion: (() -> Void)?){
        
    }
}
