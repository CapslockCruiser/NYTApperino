//
//  NewswireVC.swift
//  NYT Apperino
//
//  Created by William Choi on 8/11/17.
//  Copyright © 2017 choiw. All rights reserved.
//

import Foundation
import UIKit

final class NewswireVC: UIViewController, CanShowWebView{
    
    // Properties: Properties
    lazy var tableView: UITableView = {
        let tV = UITableView(frame: self.view.bounds)
        return tV
    }()
    
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
        
        //Decided to just use xibs for cell views to use auto layouts rather than programatically creating all UI elements
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(Constants.newswireNotificationName), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: TableView extension

extension NewswireVC: UITableViewDelegate, UITableViewDataSource, NWCellDelegate{
    
    func moreInfoButton(_ sender: NewswireCell) {
        guard let indPath = tableView.indexPath(for: sender) else { return }
        let selectedItem = NYTAPICoordinator.newswireItems[indPath.row]
        guard let url = URL(string: selectedItem.url) else { return }
        showWebview(url: url, newswireItem: selectedItem, saveEnabled: true)
    }
    
    func reloadTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return NYTAPICoordinator.newswireItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.newswireCellReuseID) as? NewswireCell else { assertionFailure("Couldn't init cell in NewswireVC"); return UITableViewCell() }
        let nwItem = NYTAPICoordinator.newswireItems[indexPath.row]
        
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
}

    // MARK: NewswireCell

protocol NWCellDelegate: class{
    func moreInfoButton(_ sender: NewswireCell)
}

class NewswireCell: UITableViewCell{
    
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var abstractLabel: UILabel!
    
    weak var nwCellDelegate: NWCellDelegate?
    
    @IBAction func moreInfoButtonPressed(_ sender: Any) {
        if let delegate = nwCellDelegate{
            delegate.moreInfoButton(self)
        }
    }
    
    var viewModel: ViewModel?{
        didSet{
            self.thumbnailImageView.image = viewModel?.thumbnailImage
            self.titleLabel.text = viewModel?.title
            self.abstractLabel.text = viewModel?.abstract
        }
    }
    
    struct ViewModel{
        let title: String
        let abstract: String
        var thumbnailImage: UIImage?
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell(){
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.height / 4
        thumbnailImageView.layer.masksToBounds = true
    }
}
