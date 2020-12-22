//
//  HistoryTableViewController.swift
//  GooglePlaceFinder
//
//  Created by Sowrirajan S on 22/12/20.
//  Copyright © 2020 com.ssowri1.com All rights reserved.
//

import UIKit

protocol HistoryDelegate: class {
    func DidSelectHistoryResponse(places: Places)
}

class HistoryTableViewController: UITableViewController {
    
    weak var delegate: HistoryDelegate?
    private var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.registerCell(name: HistoryTableViewCell.onlyClassName, bundle: nil)
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension HistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfRows == 0 {
            tableView.setEmptyMessage(AppConstants.noPlaces)
        } else {
            tableView.restore()
        }
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.data = viewModel.getPlace(index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.DidSelectHistoryResponse(places: viewModel.getPlace(index: indexPath.row))
        navigationController?.popViewController(animated: true)
    }
}
