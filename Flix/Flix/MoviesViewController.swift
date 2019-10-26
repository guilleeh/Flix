//
//  ViewController.swift
//  Flix
//
//  Created by Guillermo Hernandez on 10/14/19.
//  Copyright © 2019 Guillermo Hernandez. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    //properties - available for the lifestyle of the screen
    var movies = [[String: Any]]() // creation of array of dictionaries
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
                
                self.tableView.reloadData() // We will call the below 2 functions again
            
           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //asking for a number of rows
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for a specific row, give me the cell
        //indexPath is the current row number
        //dequeue: if another cell is offscreen, give me the recycled cell, else create new one.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //casting to MovieCell class
        
        let movie = self.movies[indexPath.row]
        let title = movie["title"] as! String //casting as a string
        let synopsis = movie["overview"] as! String //casting as a string

        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        //Give me the url, ill download and set the image
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //When you are leaving your screen and
        //you want to prepare the next one
        
        //find selected movie
        let cell = sender as! UITableViewCell //We are saying the cell is actually a uitableviewcell
        
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = movies[indexPath.row]
        
        //pass selected movie details to view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        
        detailsViewController.movie = movie // we are referring to the movie we got from our array
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

