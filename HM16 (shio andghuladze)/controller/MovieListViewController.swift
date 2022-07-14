//
//  MovieListController.swift
//  HM15 (shio andghuladze)
//
//  Created by IMAC on 12.07.22.
//

import UIKit
import SwiftUI

class MovieListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var data = (0...15).map { i in
        Movie(title: "movie\(i)", releaseDate: "200\(i)", imdb: Double(Int.random(in: 0...10)), mainActor: "actor \(i)", seen: Bool.random(), isFavourite: Bool.random())
    }
    
    private var genres = ["All", "Comedy", "Action", "Drama"]
    
    private var seenMovies: Array<Movie>?
    private var notSeenMovies: Array<Movie>?

    override func viewDidLoad() {
        super.viewDidLoad()
        seenMovies = data.filter{ $0.seen }
        notSeenMovies = data.filter{ !$0.seen }
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.register(UINib(nibName: "SeenMovieCell", bundle: nil), forCellReuseIdentifier: "SeenMovieCell")
    }
    

}

extension MovieListController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return notSeenMovies?.count ?? 0
        }else{
            return seenMovies?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell
        if indexPath.section == 0{
            cell?.setUp(movie: notSeenMovies?[indexPath.row])
            cell?.onActionClick = {
                if var movie = self.notSeenMovies?.remove(at: indexPath.row){
                    movie.seen = true
                    self.seenMovies?.append(movie)
                }
                self.tableView.reloadData()
            }
        }else{
            cell?.setUp(movie: seenMovies?[indexPath.row])
            cell?.onActionClick = {
                if var movie = self.seenMovies?.remove(at: indexPath.row){
                    movie.seen = false
                    self.notSeenMovies?.append(movie)
                }
                self.tableView.reloadData()
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movie: Movie?
        if indexPath.section == 0 {
            movie = notSeenMovies?[indexPath.row]
        }else{
            movie = seenMovies?[indexPath.row]
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "MovieDetailsController") as? MovieDetailsController{
            controller.movie = movie
            controller.otherMovies = data.filter{ $0.genre == movie?.genre }
            controller.onMovieChange = { m in
                self.seenMovies?.findAndUpdateMovie(movie: m)
                self.notSeenMovies?.findAndUpdateMovie(movie: m)
                self.data.findAndUpdateMovie(movie: m)
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel()
        view.backgroundColor = .blue
        if section == 0{
            view.text = "Seen"
        }else{
            view.text = "Not Seen"
        }
        return view
    }
    
    
}

extension MovieListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell{
            cell.titleLabel.text = genres[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seenMovies = data.filter{ $0.seen }
        notSeenMovies = data.filter{ !$0.seen }
        if let genre = Genre.init(rawValue: genres[indexPath.row]){
            seenMovies = seenMovies?.filter{ $0.genre == genre }
            notSeenMovies = notSeenMovies?.filter{ $0.genre == genre }
        }
        tableView.reloadData()
        
    }
    
    
}

extension Array where Element == Movie{
    
    mutating func findAndUpdateMovie(movie: Movie){
        for i in 0..<self.count{
            if self[i].title == movie.title{
                self[i] = movie
            }
        }
    }
    
}
