//
//  WebViewViewController.swift
//  NYT Apperino
//
//  Created by William Choi on 8/27/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class WebViewViewController: UIViewController{
    
    // MARK: UI actions
    
    @IBAction func dismissButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let item = nwItem else { assertionFailure("NwItem nil in WebViewVC.saveButtonPressed"); return }
        var realm: Realm? = nil
        do{
            realm = try Realm()
        }catch{
            assertionFailure("Could not get Realm in WebViewVC.saveButtonPressed.")
            return
        }
        do{
            guard let rlm = realm else { return }
            try rlm.write{
                rlm.add(item)
            }
        }catch{
            assertionFailure("Could not get save item in WebViewVC.saveButtonPressed.")
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UI propertes
    
    @IBOutlet weak var wView: UIWebView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    // MARK: Properties
    
    var nwItem: NewswireItem?
    
    // MARK: Methods
    
    func loadWebView(url: URL){
        let request = URLRequest(url: url)
        wView.loadRequest(request)
    }
    
    func enableSave(bool: Bool){
        saveButton.isEnabled = bool
    }
}
