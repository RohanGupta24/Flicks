//
//  MovieCell.swift
//  Flix
//
//  Created by Rohan Gupta on 1/14/18.
//  Copyright © 2018 Rohan Gupta. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    
    var movie: Movie! {
        didSet {
            let title = movie.title as! String
            let overview = movie.overview as! String
            
            cell.titleLabel.text = title
            cell.overviewLabel.text = overview
            
            let posterPathString = movie.posterUrl as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
