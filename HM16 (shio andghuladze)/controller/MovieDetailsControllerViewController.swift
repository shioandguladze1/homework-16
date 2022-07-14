//
//  MovieDetailsController.swift
//  HM15 (shio andghuladze)
//
//  Created by IMAC on 12.07.22.
//

import UIKit

class MovieDetailsController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ImdbLabel: UILabel!
    @IBOutlet weak var mainActorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    var onMovieChange: ((Movie)-> Void)?
    var movie: Movie?
    var otherMovies: [Movie]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            configureUI(movie: movie)
        }
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureButtonText(){
        if movie?.isFavourite ?? false {
            actionButton.setTitle("Remove from favorites", for: .normal)
        }else{
            actionButton.setTitle("Save to favorites", for: .normal)
        }
    }
    
    private func configureUI(movie: Movie){
        self.movie = movie
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        ImdbLabel.text = String(movie.imdb)
        mainActorLabel.text = movie.mainActor
        descriptionTextView.text = movie.description
        configureButtonText()
    }
    
    // ძალიან ცუდად გამოვიდა ამის ლოგიკა იმის გამო რომ Movie სტრაქტია, მაგრამ კლასზე არ შევცვალე
    @IBAction func onActionButtonClick(_ sender: Any) {
        if var movie = movie {
            let isFavorite = movie.isFavourite
            movie.isFavourite = !isFavorite
            self.movie = movie
            configureButtonText()
            onMovieChange?(movie)
        }
    }
    
}

extension MovieDetailsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell{
            cell.movieNameLabel.text = otherMovies?[indexPath.row].title
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = otherMovies?[indexPath.row]{
            configureUI(movie: movie)
        }
    }
    
}
