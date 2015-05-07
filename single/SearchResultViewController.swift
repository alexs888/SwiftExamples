//
//  ViewController.swift
//  single
//
//  Created by Alexandra Strugaru on 01/05/15.
//  Copyright (c) 2015 Alexandra Strugaru. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol{

    @IBOutlet weak var tableView: UITableView!
    var tableData = []
    let api = APIController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        api.delegate = self
        
        api.searchItunesFor("puzzle")
        // Do any additional setup after loading the view, typically from a nib.
    }

    func didReceiveResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.tableView!.reloadData()
        })
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Identifier")
//        cell.textLabel?.text = "Row #\(indexPath.row)"
//        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"

        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
            trackName = rowData["trackName"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(data: imgData)
                // Update the textLabel text to use the trackName from the API
                cell.textLabel?.text = trackName
        
            }
        
        return cell
        
    }
    
}

