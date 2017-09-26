//
//  TweetTableTableViewController.swift
//  SmashTag
//
//  Created by Jonathan Deng on 9/10/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: this is the data structure that powers the table view
    private var tweets = [Array<Twitter.Tweet>]()
    private var lastTwitterRequest: Twitter.Request?
    
    var searchText: String? {
        didSet {
            // remove all previous tweets
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText {
          return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    func insertTweets(_ newTweets: [Twitter.Tweet]) {
        self.tweets.insert(newTweets, at:0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            // because this request is running on a different thread than the main we need to asynchronously send a message back to
            // to the main queue to execute this action
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchText = "#Harvard"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue a cell created with the same prototype as "Tweet"
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        let tweet = tweets[indexPath.section][indexPath.row]
        cell.textLabel?.text = tweet.text
        cell.detailTextLabel?.text = tweet.user.name
        return cell
    }
    
}
