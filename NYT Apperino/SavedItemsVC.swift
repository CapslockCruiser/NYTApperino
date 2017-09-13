//
//  SavedItemsVC.swift
//  NYT Apperino
//
//  Created by William Choi on 8/11/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class SavedItemsVC: UIViewController, NWCellDelegate, CanShowWebView{
    
    func moreInfoButton(_ sender: NewswireCell) {
        guard let indPath = tableView.indexPath(for: sender) else { return }
        let selectedItem = NYTAPICoordinator.newswireItems[indPath.row]
        guard let url = URL(string: selectedItem.url) else { return }
        showWebview(url: url, newswireItem: selectedItem, saveEnabled: false)
    }

    
    // MARK: Properties
    fileprivate lazy var tableView: UITableView! = {
        let tV = UITableView(frame: self.view.bounds)
        return tV
    }()
    
    fileprivate var items: [NewswireItem] = []
    
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullPageTableView(view: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "NewswireCell", bundle: nil), forCellReuseIdentifier: Constants.newswireCellReuseID)
        tableView.allowsSelection = false
        
        loadSavedItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSavedItems()
    }
    
    // MARK: Methods
    fileprivate func loadSavedItems(){
        items = []
        var realm: Realm?
        do{
            realm = try Realm()
            if let rlmItems = realm?.objects(NewswireItem.self){
                items = Array(rlmItems)
            }
        }catch{
            assertionFailure("Could not get Realm in SavedItemsVC.lodSavedItems.")
            return
        }
        
        reloadTableView()
        
    }
    
    fileprivate func reloadTableView(){
        DispatchQueue.main.async{
//            self.loadSavedItems()
            self.tableView.reloadData()
        }
    }
}

extension SavedItemsVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newswireCellReuseID) as? NewswireCell else { assertionFailure("Couldn't init cell in SavedItemsVC"); return UITableViewCell() }
        let nwItem = items[indexPath.row]
        
        cell.viewModel = NewswireCell.ViewModel(title: nwItem.title, abstract: nwItem.abstract, thumbnailImage: nil)
        
        cell.nwCellDelegate = self
        
        if let url = URL(string: nwItem.thumbnailURL) {
            ImageManager.shared.image(url: url) { (image, retrievedURL) -> Void in
                guard url == retrievedURL else { return }
                cell.viewModel = NewswireCell.ViewModel(title: nwItem.title, abstract: nwItem.abstract, thumbnailImage: image)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteClosure = { (action: UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            var realm: Realm?
            do{
                realm = try Realm()
                if let rlm = realm{
                    try rlm.write(){
                        realm?.delete(self.items[indexPath.row])
                        self.loadSavedItems()
                        self.reloadTableView()
                    }
                }
            }catch{
                assertionFailure("Could not get Realm in SavedItemsVC.lodSavedItems.")
                return
            }
            
            self.reloadTableView()
        }
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: deleteClosure)
        
        return [deleteAction]
    }
}
