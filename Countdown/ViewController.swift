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
        configureNavBar()
        configureTableView()
        configureDataSource()
    }
    
    private func configureNavBar()  {
        navigationItem.title = "Countdown with diffable data source"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startCountdown))
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
            if value == -1 {
                cell.textLabel?.text = "App Launched 🚀. All lookd good so far with Crashlytics. 👍🏽"
                cell.textLabel?.numberOfLines = 0
            } else {
                cell.textLabel?.text = "\(value)"

            }
            return cell
        })
        
        // set type of animation on the data source
        dataSource.defaultRowAnimation = .fade // .automatic is default
        
        // setup snapshot
//        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
//        // add sections
//        snapshot.appendSections([.main])
//        // add items for section
//        snapshot.appendItems([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
//        // apply changes to the dataSource
//        dataSource.apply(snapshot, animatingDifferences: true)
        startCountdown()
    }
    
    @objc private func startCountdown()   {
        if timer != nil {
            timer.invalidate()
        }
        
        // configure the timer
        // set interval for countdown
        // assign a method that gets called every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
        // reset our startingInterval
        startInterval = 10 // seconds
        
        // setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<ViewController.Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems([startInterval]) // start at 10
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func decrementCounter() {
        // get access to the snapshot to manipulate data
        // snapshot is the "source of truth" for the table view's data
        var snapshot = dataSource.snapshot()
        
        guard startInterval > 0 else {
            timer.invalidate()
            ship()
            return
        }
        // 1 to 10
        startInterval -= 1 // 10, 9, 8 ...0
        snapshot.appendItems([startInterval]) // 9 is inserted in tv
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func ship() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([-1])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

