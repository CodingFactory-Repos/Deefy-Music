//
// Created by Guillaume on 12/10/2023.
//

import Foundation

struct Podcast {
    var id: String
    var title: String
    var description: String
    var image: String
    var release_date: String
    var duration: Int


    init(id: String, title: String, description: String, image: String, release_date: String, duration: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.release_date = release_date
        self.duration = duration
    }
}
