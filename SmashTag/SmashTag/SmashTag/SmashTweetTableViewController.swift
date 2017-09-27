//
//  SmashTweet.swift
//  SmashTag
//
//  Created by Jonathan Deng on 9/26/17.
//  Copyright © 2017 Jonathan Deng. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("starting database load")
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                _ = try? Twitter.Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics()
        }
    }

    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                // bad way to count
                if let tweetCount = (try? context.fetch(Twitter.Tweet.fetchRequest()))?.count {
                    print("\(tweetCount) tweets")
                }
                // good way to count
                if let tweeterCount = try? context.count(for: Twitter.TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
            }
        }
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
    }
}
