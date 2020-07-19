//
//  ViewController.swift
//  Countdown
//
//  Created by Juan Ceballos on 7/19/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // enum, int conforms to hashable for datasource
    // 2
    enum Section    {
        case main // one section for table view
    }
    
    private var tableView: UITableView!
    
    // 1
    // define the UITableViewDiffableDataSource instance
    private var dataSource: UITableViewDiffableDataSource<Section, Int>!
    
    private var timer: Timer!
    
    private var startInterval = 10 // seconds
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTableView()
        configureDataSource()
    }

    private func configureTableView()   {
        tableView = UITableView(frame: view.bounds, style: .plain)
        // entire view grows with
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
    }
    
    private func configureDataSource()  {
        dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(value)"
            return cell
        })
        
        // set type of animation on the data source
        dataSource.defaultRowAnimation = .fade // .automatic is default
        
        // setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
        // add sections
        snapshot.appendSections([.main])
        // add items for section
        snapshot.appendItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
        // apply changes to the dataSource
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

