//
//  Movie.swift
//  HM15 (shio andghuladze)
//
//  Created by IMAC on 12.07.22.
//

import Foundation

struct Movie {
    let title: String
    let releaseDate: String
    let imdb: Double
    let mainActor: String
    var seen: Bool
    var isFavourite: Bool
    let description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    let genre: Genre = Genre.getRandom()
}

enum Genre: String{
    case Comedy
    case Action
    case Drama
    
    static func getRandom()-> Genre{
        switch (0..<3).randomElement(){
            case 0: return Genre.Comedy
            case 1: return Genre.Action
            default: return Genre.Drama
        }
    }
}
