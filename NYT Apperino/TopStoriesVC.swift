//
//  TopStoriesVC.swift
//  NYT Apperino
//
//  Created by William Choi on 8/11/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import UIKit

final class TopStoriesVC: UIViewController{
    
    // Properties: Properties
    fileprivate lazy var tableView: UITableView = {
        let tV = UITableView(frame: self.view.bounds)
        return tV
    }()
    
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFullPageTableView(view: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension TopStoriesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell()
        
        return cell
    }
}
