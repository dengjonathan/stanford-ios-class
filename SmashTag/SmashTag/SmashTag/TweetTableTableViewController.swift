//
//  TweetTableTableViewController.swift
//  SmashTag
//
//  Created by Jonathan Deng on 9/10/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit
import Twitter

class TweetTableTableViewController: UITableViewController {
    
    // MARK: this is the data structure that powers the table view
    private var tweets = [Array<Twitter.Tweet>]()
    
    var searchText: String? {
        didSet {
            // remove all previous tweets
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    private func searchForTweets() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "#Harvard"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
