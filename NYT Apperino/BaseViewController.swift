//
//  BaseViewController.swift
//  NYT Apperino
//
//  Created by William Choi on 8/12/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import UIKit
import WebKit

protocol CanShowWebView{
    func showWebview(url: URL, newswireItem: NewswireItem, saveEnabled: Bool)
}

extension UIViewController{
    
    fileprivate func adjustForLayoutGuides(view: UITableView){
        
        var bottomOffset: CGFloat = 0.0
        
        if let tbController = self.tabBarController{
            bottomOffset = bottomOffset + tbController.tabBar.frame.height
        }
        
        if let navController = self.navigationController{
            bottomOffset = bottomOffset + navController.navigationBar.frame.height
        }
        
        view.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
        
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - (bottomOffset))
    }
    
    //Note to self: private access modifier to be changed in Swift 4.
    //        https://cocoacasts.com/what-is-the-difference-between-private-and-fileprivate-in-swift-4/

    
    func setupFullPageTableView(view: UITableView){
        adjustForLayoutGuides(view: view)
        self.view.addSubview(view)
    }
}

extension CanShowWebView where Self: UIViewController{
    
    func showWebview(url: URL, newswireItem: NewswireItem, saveEnabled: Bool){
        DispatchQueue.main.async {
            guard let webViewVC = UIStoryboard(name: "WebView", bundle: nil).instantiateInitialViewController() as? WebViewViewController else {
                assertionFailure("Could not init webViewVC in BaseVC.showWebView"); return }
            
            webViewVC.nwItem = newswireItem
            
            self.present(webViewVC, animated: true, completion: nil)
            webViewVC.enableSave(bool: saveEnabled)
            webViewVC.loadWebView(url: url)
        }
    }
}
