//
//  ViewController.swift
//  Hacker Time
//
//  Created by Travis Baker on 1/31/19.
//  Copyright © 2019 Travis Baker. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView

let REUSE_IDENTIFIER = "StoryTableViewCell"

class MainStoriesViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var storiesTableView: UITableView!
    
    var topStoriesIdList: List<Int> = List<Int>()

    let dbManager = DatabaseManager.shared
    
    var itemRequests: [Int: Operation] = [:]
    
    var currentlySelectedRow: Int!
    
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        storiesTableView.dataSource = self
        storiesTableView.delegate = self
        storiesTableView.prefetchDataSource = self
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.isHidden = true
        getTopStories()
        fetchTopStories()
    }

    override func viewDidAppear(_ animated: Bool) {
        if currentlySelectedRow != nil {
            storiesTableView.deselectRow(at: IndexPath(row: currentlySelectedRow, section: 0), animated: true)
            currentlySelectedRow = nil
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.title = "Top Stories"
    }
    
    private func getTopStories() {
        do {
            topStoriesIdList = try dbManager.getTopStories().stories
        } catch {
            showAlert(title: "Data Corruption", message: "The data appears to be corrupted. We cannot retrieve the saved articles currently.")
        }
    }
    
    private func fetchTopStories() {
        startAnimating()
        HackerNewsAPI.getTopStories { (topStories, error) in
            self.stopAnimating()
            guard error == nil else {
                self.showNetworkError(message: "Could not get new top stories.")
                return
            }
            
            do {
                try self.dbManager.setTopStories(topStories)
                self.getTopStories()
                self.storiesTableView.reloadData()
            } catch {
                self.showAlert(title: "Data Save Error", message: "We were unable to save the data retrieved from Hacker News.")
            }
            
        }
    }
    
    private func fetchItemData(index: IndexPath) {
        guard itemRequests[index.row] == nil else {
            return
        }
        
        let operation = BlockOperation(block: {
            let itemId = self.topStoriesIdList[index.row]
            guard self.dbManager.getItem(id: itemId) == nil else {
                return
            }
            HackerNewsAPI.getItem(itemId: "\(itemId)") { (item, error) in
                if let item = item {
                    let newItem = Item()
                    newItem.setFrom(itemResponse: item)
                    try? self.dbManager.addItem(newItem)
                    self.storiesTableView.reloadRows(at: [index], with: .none)
                }
            }
        })
        
        operation.start()
        
        itemRequests[index.row] = operation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let identifier = segue.identifier {
            switch identifier {
            case "showStoryDetails":
                let vc = segue.destination as! StoryDetailViewController
                let story = dbManager.getItem(id: topStoriesIdList[currentlySelectedRow])
                vc.story = story
            default:
                break
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showStoryDetails" {
            if dbManager.getItem(id: topStoriesIdList[currentlySelectedRow]) == nil {
                return false
            }
        }
        
        return true
    }
}

extension MainStoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topStoriesIdList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: REUSE_IDENTIFIER)
        }
        
        let item = dbManager.getItem(id: topStoriesIdList[indexPath.row])
        
        if item == nil {
            fetchItemData(index: indexPath)
        }
        
        if let type = item?.type {
            switch type {
            case ItemType.job.rawValue:
                cell?.imageView?.image = UIImage(imageLiteralResourceName: "Job")
            case ItemType.story.rawValue:
                cell?.imageView?.image = UIImage(imageLiteralResourceName: "Story")
            case ItemType.poll.rawValue:
                cell?.imageView?.image = UIImage(imageLiteralResourceName: "Poll")
            default:
                break
            }
        }
        
        cell?.textLabel?.text = item?.title
        
        return cell!
    }
}

extension MainStoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentlySelectedRow = indexPath.row
        performSegue(withIdentifier: "showStoryDetails", sender: self)
    }
}

extension MainStoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            self.fetchItemData(index: indexPath)
        }
    }
}
