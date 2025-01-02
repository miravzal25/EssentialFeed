//
//  FeedViewController.swift
//  Prototype
//
//  Created by Miravzal Sultonov on 1/2/25.
//

import UIKit

final class FeedViewController: UITableViewController {
    
    private let feed = FeedImageViewModel.prototypeFeed
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        navigationItem.title = "Feed"
        
        tableView.register(ImageFeedTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 580
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ImageFeedTableViewCell
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}
