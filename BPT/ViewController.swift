//
//  ViewController.swift
//  BPT
//
//  Created by Jovanny Espinal on 11/25/16.
//  Copyright © 2016 Jovanny Espinal. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: BetterSegmentedControl!
    @IBOutlet weak var progressBackgroundView: UIView!
    var popularMemes = [Meme]()
    var newMemes = [Meme]()
    var topMemes = [Meme]()
    let redditEndpoint =  "https://www.reddit.com/r/BlackPeopleTwitter/"
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    var index: Int {
        return Int(segmentedControl.index)
    }
    var segmentedTitle: String {
        return segmentedControl.titles[index]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        segmentedControl.titles = ["Popular", "New", "Top"]
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        
        getMemes(for: .popular)
        
        self.tableView.addSubview(self.refreshControl)
    }
    
    func handleRefresh() {
        switch segmentedTitle {
        case "Popular":
            getMemes(for: .popular)
        case "New":
            getMemes(for: .new)
        case "Top":
            getMemes(for: .top)
        default:
            break
        }
        
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMeme" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let imageURL: URL?
                let imageVC = segue.destination as! ImageViewController
                _ = imageVC.view
                
                switch segmentedTitle {
                case "Popular":
                    imageURL = popularMemes[indexPath.row].imageURL
                case "New":
                    imageURL = newMemes[indexPath.row].imageURL
                case "Top":
                    imageURL = topMemes[indexPath.row].imageURL
                default:
                    imageURL = nil
                }
                
                imageVC.image.sd_setImage(with: imageURL!,
                                          placeholderImage: UIImage(named: "noImageAvailable"))
            }
        }
    }
    
    func segmentedValueChanged() {
        switch segmentedTitle {
        case "Popular":
            popularMemes.isEmpty ? getMemes(for: .popular) : tableView.reloadData()
        case "New":
            newMemes.isEmpty ? getMemes(for: .new) : tableView.reloadData()
        case "Top":
            topMemes.isEmpty ? getMemes(for: .top) : tableView.reloadData()
        default:
            break
        }
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedTitle {
        case "Popular":
            return popularMemes.count
        case "New":
            return newMemes.count
        case "Top":
            return topMemes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath) as! MemeCell
        
        let meme: Meme?
        
        switch segmentedTitle {
        case "Popular":
            meme = popularMemes[indexPath.row]
        case "New":
            meme = newMemes[indexPath.row]
        case "Top":
            meme = topMemes[indexPath.row]
        default:
            meme = nil
        }
        
        guard let unwrappedMeme = meme else { return cell }
        
        cell.configure(with: unwrappedMeme)
        
        return cell
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController {
    func getMemes(for category: Category) {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        self.progressBackgroundView.isHidden = false
        activityView.center = self.progressBackgroundView.center
        activityView.startAnimating()
        
        self.progressBackgroundView.addSubview(activityView)
        
        APIManager.getMemes(from: redditEndpoint, with: category) { (memes) in
            
            guard let memes = memes else { return }
            
            switch category {
            case .popular:
                self.popularMemes = memes
            case .top:
                self.topMemes = memes
            case .new:
                self.newMemes = memes
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                activityView.stopAnimating()
                activityView.removeFromSuperview()
                self.progressBackgroundView.isHidden = true
            }
        }
    }
}


