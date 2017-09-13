//
//  CWRootViewController.swift
//  NYT Apperino
//
//  Created by William Choi on 8/10/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import UIKit

final class CWRootViewController: UITabBarController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let newswireCompletionClosure: (() -> Void) = { () in
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.newswireNotificationName)))
        }
//        let topStoriesCompletionClosure: (() -> Void) = { () in
//            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: Constants.topStoriesNotificationName)))
//        }
        
        NYTAPICoordinator.shared.getNewswire(completion: newswireCompletionClosure)
//        NYTAPICoordinator.shared.getTopStories(completion: topStoriesCompletionClosure)

        let newswireVC = NewswireVC()
//        let topStoriesVC = TopStoriesVC() //Took out topStoriesVC, as it the functionalities of topStories and newsWire seemed similar
        let savedItemsVC = SavedItemsVC()
        
        //Decided to programatically create views, as none of them were too complex and Storyboards just increase compile times
//        guard let newswireVC = UIStoryboard.init(name: "NewswireStoryboard", bundle: nil).instantiateInitialViewController() else { assertionFailure("Failed instantiating newswireVC"); return }
//        guard let topStoriesVC = UIStoryboard.init(name: "TopStoriesStoryboard", bundle: nil).instantiateInitialViewController() else { assertionFailure("Failed instantiating topStoriesVC"); return }
//        guard let savedItemsVC = UIStoryboard.init(name: "SavedItemsStoryboard", bundle: nil).instantiateInitialViewController() else { assertionFailure("Failed instantiating savedItemsVC"); return }
        
        let tabVCs: [UIViewController] = [newswireVC, savedItemsVC]
        
        self.setViewControllers(tabVCs, animated: false)
        
//        topStoriesVC.tabBarItem = UITabBarItem.init(title: "Top Stories", image: UIImage(named: "TopStoriesTabIcon"), tag: 1)
        newswireVC.tabBarItem = UITabBarItem.init(title: "Newswire", image: UIImage(named: "NewswireTabIcon"), tag: 2)
        savedItemsVC.tabBarItem = UITabBarItem.init(title: "Saved Items", image: UIImage(named: "SavedItemsTabIcon"), tag: 3)
    }
}
