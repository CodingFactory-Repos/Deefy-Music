//
// Created by Ilan Petiot on 11/10/2023.
//

import Foundation

struct Search {
    var image: String
    var artist: String
    var title: String

    init(image: String, artist: String, title: String) {
        self.image = image
        self.artist = artist
        self.title = title
    }
}