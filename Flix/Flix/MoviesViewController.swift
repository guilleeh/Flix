//
//  ViewController.swift
//  Flix
//
//  Created by Guillermo Hernandez on 10/14/19.
//  Copyright © 2019 Guillermo Hernandez. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    //properties - available for the lifestyle of the screen
    var movies = [[String: Any]]() // creation of array of dictionaries
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.movies = dataDictionary["results"] as! [[String: Any]] //type casting to array of dict
            
            
              
            
              

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }


}

