//
// Created by Guillaume on 10/10/2023.
//

import Foundation

struct Music {
    // Music composed of -> Title, Artists, Album, Image, Duration
    var title: String
    var artists: [String]
    var album: String
    var image: String
    var duration: Int


    // Init
    init(title: String, artists: [String], album: String, image: String, duration: Int) {
        self.title = title
        self.artists = artists
        self.album = album
        self.image = image
        self.duration = duration
    }
}
