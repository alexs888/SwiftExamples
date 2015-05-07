//
//  APIController.swift
//  single
//
//  Created by Alexandra Strugaru on 01/05/15.
//  Copyright (c) 2015 Alexandra Strugaru. All rights reserved.
//

import Foundation

//protocol
protocol APIControllerProtocol {
    func didReceiveResults(results: NSArray)
}

class APIController{
    
    var delegate: APIControllerProtocol?
    
func searchItunesFor(searchTerm: String){
    let iTunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
    
    if let escapeSearchTerm = iTunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
        let urlPath = "http://itunes.apple.com/search?term=\(escapeSearchTerm)&media=software"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            
            println("task completed")
            
            if(error != nil){
                println(error.localizedDescription)
            }
            
            var err :NSError?
            
            if let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    println("JSON Error #\(err?.localizedDescription)")
                }
                
                
                if let results :NSArray = jsonResults["results"] as? NSArray {

                    self.delegate?.didReceiveResults(results)
                }
            }
        })
            task.resume()
        }
    }

}
