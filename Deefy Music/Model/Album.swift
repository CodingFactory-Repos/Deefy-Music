//
// Created by Guillaume on 10/10/2023.
//

import Foundation

struct Album {
    // Album should contain -> Name, Artists, Image, Release Date, Total Tracks,
    var id: String
    var name: String
    var artists: Any
    var image: String
    var releaseDate: String
    var totalTracks: Int

    // Init
    init(id: String, name: String, artists: Any, image: String, releaseDate: String, totalTracks: Int) {
        self.id = id
        self.name = name
        self.artists = artists
        self.image = image
        self.releaseDate = releaseDate
        self.totalTracks = totalTracks
    }
}
