//
// Created by Guillaume on 11/10/2023.
//

import Foundation

struct Artist {
    // Artist should contain -> Name, Image, Followers, Genres, Popularity, Albums, Top Tracks
    var name: String
    var image: String
    var followers: Int
    var genres: [String]
    var popularity: Int

    // Init
    init(name: String, image: String, followers: Int, genres: [String], popularity: Int) {
        self.name = name
        self.image = image
        self.followers = followers
        self.genres = genres
        self.popularity = popularity
    }
}
