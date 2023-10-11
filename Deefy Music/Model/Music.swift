//
// Created by Guillaume on 10/10/2023.
//

import Foundation

struct Music {
    // Music composed of -> Title, Artists, Album, Image, Duration
    var title: String
    var artists: Any
    var album: Album
    var duration: Int


    // Init
    init(title: String, artists: Any, album: Album, duration: Int) {
        self.title = title
        self.artists = artists
        self.album = album
        self.duration = duration
    }
}
