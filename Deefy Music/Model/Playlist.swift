//
// Created by Guillaume on 11/10/2023.
//

import Foundation

struct Playlist {
    // Playlist should contain -> Name, Image, Description, Owner, Tracks
    var id: String
    var name: String
    var image: String
    var description: String
    var owner: [String: Any]
    var tracks: [String: Any]

    // Init
    init(id: String, name: String, image: String, description: String, owner: [String: Any], tracks: [String: Any]) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.owner = owner
        self.tracks = tracks
    }
}
