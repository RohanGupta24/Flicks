//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Rohan Gupta on 1/14/18.
//  Copyright © 2018 Rohan Gupta. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var refreshImage: UIActivityIndicatorView!
    
    var movies: [Movie] = []
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var movieSearchBar: UISearchBar!
    
    var filteredMovies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshImage.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .
            valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        fetchMovies()
        
        

        // Do any additional setup after loading the view.
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        refreshImage.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                self.movies = Movie.movies(dictionaries: dataDictionary)
                //self.filteredMovies = self.movies!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie as! [String : Any]
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filter the movies array based on the user's search
        let filtered = searchText.isEmpty ? movies : movies?.filter({ (dataDictionary: NSDictionary) -> Bool in
            let dataString = dataDictionary["title"] as! String
            return dataString.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        //assign the filtered array to filteredMovies
        filteredMovies = filtered ?? []
        
        //reload data
        self.tableView.reloadData()
    }
    
    //function that shows the cancel button when the user is using the search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        movieSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //remove the text and cancel button when the user clicks on the cancel button
        movieSearchBar.showsCancelButton = false
        movieSearchBar.text = ""
        
        //retract keyboard when the cancel button is clicked
        movieSearchBar.resignFirstResponder()
        
        //reload data with all of the movies array content
        filteredMovies = movies ?? []
        self.tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
