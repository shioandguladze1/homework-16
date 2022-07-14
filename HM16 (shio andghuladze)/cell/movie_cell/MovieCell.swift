//
//  MovieCell.swift
//  HM15 (shio andghuladze)
//
//  Created by IMAC on 12.07.22.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImdbLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var onActionClick: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onActionButtonClick(_ sender: Any) {
        onActionClick?()
    }
    
    func setUp(movie: Movie?){
        if movie?.seen == true{
            actionButton.setTitle("Unwatch", for: UIControl.State.normal)
        }else{
            actionButton.setTitle("Watch", for: UIControl.State.normal)
        }
        movieTitleLabel.text = movie?.title
        movieImdbLabel.text = String(movie?.imdb ?? 0)
    }
}
