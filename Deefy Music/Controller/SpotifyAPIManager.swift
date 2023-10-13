//
// Created by Guillaume on 10/10/2023.
//

import Foundation

public class SpotifyAPIManager {

    public init() {
    }

    func searchForItem(query: String, offset: Int, completion: @escaping ([[String: Any]]) -> Void) {
        // Results will be item + popularity as [item, popularity]
        var results: [[String: Any]] = []

        let url = URL(string: "https://api.spotify.com/v1/search?q=\(query)&type=album,artist,playlist,track,episode&offset=\(offset)&limit=20")!
        let token = retrieveToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if (200...299).contains(response.statusCode) {
                // Successful response
                print("Request was successful with status code: \(response.statusCode)")
            } else {
                // Error response
                print("Server error with status code: \(response.statusCode)")
                print("Error reason: \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
            }



            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let resultAlbums = (json as! [String: Any])["albums"] as! [String: Any]
                    let resultTracks = (json as! [String: Any])["tracks"] as! [String: Any]
                    let resultArtists = (json as! [String: Any])["artists"] as! [String: Any]
                    let resultPlaylists = (json as! [String: Any])["playlists"] as! [String: Any]
                    let resultPodcasts = (json as! [String: Any])["episodes"] as! [String: Any]
                    // For each item in albums print their name
                    let itemsAlbums = resultAlbums["items"] as! [[String: Any]]
                    let itemsTracks = resultTracks["items"] as! [[String: Any]]
                    let itemsArtists = resultArtists["items"] as! [[String: Any]]
                    let itemsPlaylists = resultPlaylists["items"] as! [[String: Any]]
                    let itemsPodcasts = resultPodcasts["items"] as! [[String: Any]]

                    for albums in itemsAlbums {
                        var imageUrl = ""
                        if let images = albums["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        var albumPopularity = 0 as! Int
                        let artists = albums["artists"] as! [[String: Any]]
                        // Put in lowercase
                        let artist_name = artists[0]["name"] as! String
                        let query_lowercased = query.lowercased()

                        if (artist_name.lowercased() == query_lowercased) {
                            if let release_date = albums["release_date"] as? String {
                                // Decay popularity by 10 each year and 2 each month in the current year
                                let date = Date()
                                let calendar = Calendar.current
                                let currentYear = calendar.component(.year, from: date)
                                let currentMonth = calendar.component(.month, from: date)
                                let releaseYear = Int(release_date.prefix(4))!
                                let releaseMonth = Int(release_date.prefix(7).suffix(2))!
                                let years = currentYear - releaseYear
                                let months = currentMonth - releaseMonth
                                albumPopularity = 80 - (years * 12) - (months * 2)
                            }
                        }

                        let album_name = albums["name"] as! String
                        if (album_name.lowercased() == query_lowercased) {
                            albumPopularity = 100
                        }

                        // If albums.tracks.total <= 1 then make the popularity to -2
                        let tracks = albums["total_tracks"] as! Int
                        if (tracks <= 1) {
                            albumPopularity = -2
                        }

                        let album = Album(id: albums["id"] as! String, name: albums["name"] as! String, artists: albums["artists"] as Any, image: imageUrl as String, releaseDate: albums["release_date"] as! String, totalTracks: albums["total_tracks"] as! Int)
                        let albumItem = ["item": album, "popularity": albumPopularity as! Int]
                        results.append(albumItem)
                    }

                    for tracks in itemsTracks {
                        let album = tracks["album"] as! [String: Any]
                        var imageUrl = ""
                        if let images = album["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        var popularity = tracks["popularity"] as! Int
                        let artists = tracks["artists"] as! [[String: Any]]
                        let artist_name = artists[0]["name"] as! String
                        let query_lowercased = query.lowercased()
                        if (!query_lowercased.contains(artist_name.lowercased())) {
                            popularity = popularity / 2
                        } else if (artist_name.lowercased() == query_lowercased || query_lowercased.contains(artist_name.lowercased())) {
                            popularity = popularity * 2
                        }

                        let track_name = tracks["name"] as! String
                        if (track_name.lowercased() == query_lowercased) {
                            popularity *= 3/2
                        } else if (query_lowercased.contains(track_name.lowercased()) && query_lowercased.contains(artist_name.lowercased())) {
                            popularity *= 2
                        }

                        let track = Music(id: tracks["id"] as! String, title: tracks["name"] as! String, artists: tracks["artists"] as Any, album: Album(id: album["id"] as! String, name: album["name"] as! String, artists: album["artists"] as Any, image: imageUrl as String, releaseDate: album["release_date"] as! String, totalTracks: album["total_tracks"] as! Int), duration: tracks["duration_ms"] as! Int)
                        let trackItem = ["item": track, "popularity": popularity as! Int]
                        results.append(trackItem)
                    }

                    for artists in itemsArtists {
                        var imageUrl = ""
                        if let images = artists["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        var popularity = artists["popularity"] as! Int
                        let artist_name = artists["name"] as! String
                        let query_lowercased = query.lowercased()
                        if (artist_name.lowercased() != query_lowercased) {
                            popularity /= 2
                        } else if (artist_name.lowercased() == query_lowercased) {
                            popularity *= 1000
                        } else if (artist_name.lowercased().contains(query_lowercased)) {
                            popularity *= 3/2
                        } else  {
                            popularity *= 2
                        }

                        let followersArray = artists["followers"] as! [String: Any]
                        let followers = followersArray["total"] as! Int

                        let artist = Artist(id: artists["id"] as! String, name: artists["name"] as! String, image: imageUrl as String, followers: followers as! Int, genres: artists["genres"] as! [String], popularity: artists["popularity"] as! Int)
                        let artistItem = ["item": artist, "popularity": popularity as! Int]
                        results.append(artistItem)
                    }

                    for playlists in itemsPlaylists {
                        var imageUrl = ""
                        if let images = playlists["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        var playlistPopularity = -1 as! Int
                        let query_lowercased = query.lowercased()
                        if query_lowercased.contains("playlist") || query_lowercased.contains("playlists") {
                            playlistPopularity = 80
                        }

                        let playlist = Playlist(id: playlists["id"] as! String, name: playlists["name"] as! String, image: imageUrl as String, description: playlists["description"] as! String,owner: playlists["owner"] as! [String: Any], tracks: playlists["tracks"] as! [String: Any])
                        let playlistItem = ["item": playlist, "popularity": playlistPopularity]
                        results.append(playlistItem)
                    }

                    for podcasts in itemsPodcasts {
                        var imageUrl = ""
                        if let images = podcasts["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        var podcastPopularity = 0 as! Int
                        // If it matches the query then popularity = 1000
                        let podcast_name = podcasts["name"] as! String
                        let query_lowercased = query.lowercased()
                        if (podcast_name.lowercased() == query_lowercased) {
                            podcastPopularity = 1000
                        } else if (podcast_name.lowercased().contains(query_lowercased)) {
                            podcastPopularity = 80
                        }

                        let podcast = Podcast(id: podcasts["id"] as! String, title: podcasts["name"] as! String, description: podcasts["description"] as! String, image: imageUrl  as String, release_date: podcasts["release_date"] as! String, duration: podcasts["duration_ms"] as! Int)
                        let podcastItem = ["item": podcast, "popularity": podcastPopularity]

                        results.append(podcastItem)
                    }

                    let resultSorted = self.sortResults(results: results)

                    completion(resultSorted)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    func sortResults(results: [[String: Any]]) -> [[String: Any]] {
        // Filter items with popularity = -1
        let itemsWithPopularityMinus1 = results.filter { ($0["popularity"] as! Int) == -1 }

        // Sort items with popularity >= 0 by popularity in descending order
        let sortedByPopularity = results.filter { ($0["popularity"] as! Int) >= 0 }
                .sorted { ($0["popularity"] as! Int) > ($1["popularity"] as! Int) }

        var sortedResults: [[String: Any]] = []

        for result in sortedByPopularity {
            sortedResults.append(result)
        }

        for result in itemsWithPopularityMinus1 {
            var randomIndex = Int.random(in: 0...sortedResults.count)
            if (sortedResults.count > 30) {
                randomIndex = Int.random(in: 30...sortedResults.count)
            } else if (sortedResults.count > 20) {
                randomIndex = Int.random(in: 20...sortedResults.count)
            } else if (sortedResults.count > 10) {
                randomIndex = Int.random(in: 10...sortedResults.count)
            }
            sortedResults.insert(result, at: randomIndex)
        }

        return sortedResults
    }


    func retrieveSpotifyNewAlbums(completion: @escaping ([Album]) -> Void) {
        var albums = [] as [Album]
        let url = URL(string: "https://api.spotify.com/v1/browse/new-releases")!
        let token = retrieveToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  // If response.statusCode is different than 200...299 then print the status code
                  (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let items = (json as! [String: Any])["albums"] as! [String: Any]
                    let items2 = items["items"] as! [[String: Any]]
                    for item in items2 {
                        var imageUrl = ""
                        if let images = item["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        let album = Album(id: item["id"] as! String, name: item["name"] as! String, artists: item["artists"] as Any, image: imageUrl as String, releaseDate: item["release_date"] as! String, totalTracks: item["total_tracks"] as! Int)
                        albums.append(album)
                    }
                    completion(albums)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    func getTracksFromAlbum(albumId: String, completion: @escaping ([Music]) -> Void) {
        var tracks = [] as [Music]
        let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)/tracks")!
        let token = retrieveToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  // If response.statusCode is different than 200...299 then print the status code
                  (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let items = (json as! [String: Any]) as! [String: Any]

                    let items2 = items["items"] as! [[String: Any]]
                    for item in items2 {
                        self.getAlbumFromId(albumId: albumId) { album in
                            let titleAlbum = album
                            let track = Music(id: item["id"] as! String, title: item["name"] as! String, artists: item["artists"] as Any, album: titleAlbum as Album, duration: item["duration_ms"] as! Int)
                            tracks.append(track)

                            if tracks.count == items2.count {
                                completion(tracks)
                            }
                        }
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    func getAlbumFromId(albumId: String, completion: @escaping (Album) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/albums/\(albumId)")!
        let token = retrieveToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  // If response.statusCode is different than 200...299 then print the status code
                  (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let items = (json as! [String: Any])as! [String: Any]
                    var imageUrl = ""

                    if let images = items["images"] as? [[String: Any]] {
                        if let image = images.first {
                            if let url = image["url"] as? String {
                                imageUrl = url
                            }
                        }
                    }

                    let album = Album(id: items["id"] as! String, name: items["name"] as! String, artists: items["artists"] as Any, image: imageUrl as! String, releaseDate: items["release_date"] as! String, totalTracks: items["total_tracks"] as! Int)
                    completion(album)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    func getTopTracksFromArtist(artistId: String, completion: @escaping ([Music]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/artists/\(artistId)/top-tracks?market=FR")!
        let token = retrieveToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  // If response.statusCode is different than 200...299 then print the status code
                  (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let items = json as? [String: Any], let items2 = items["tracks"] as? [[String: Any]] {
                        var topMusics = [Music]()
                        let group = DispatchGroup() // Pour suivre le nombre de requêtes en cours
                        
                        for item in items2 {
                            if let albumId = (item["album"] as? [String: Any])?["id"] as? String {
                                group.enter() // Déclarez l'entrée dans le groupe avant la requête asynchrone
                                self.getAlbumFromId(albumId: albumId) { album in
                                    let titleAlbum = album
                                    let track = Music(id: item["id"] as? String ?? "",
                                                      title: item["name"] as? String ?? "",
                                                      artists: item["artists"] as Any,
                                                      album: titleAlbum as Album,
                                                      duration: item["duration_ms"] as? Int ?? 0)
                                    topMusics.append(track)
                                    group.leave() // Signalez la sortie du groupe après avoir traité la réponse
                                }
                            }
                        }
                        
                        // À ce stade, nous attendons que toutes les requêtes asynchrones se terminent
                        group.notify(queue: .main) {
                            completion(topMusics) // Une fois que tout est terminé, appelez la complétion
                        }
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    func getAlbumsFromArtist(artistId: String, completion: @escaping ([Album]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/artists/\(artistId)/albums")!
        let token = retrieveToken()
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                  // If response.statusCode is different than 200...299 then print the status code
                  (200...299).contains(response.statusCode) else {
                print("Server error")
                return
            }

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let items = (json as! [String: Any])as! [String: Any]
                    let items2 = items["items"] as! [[String: Any]]
                    var albums = [] as [Album]
                    for item in items2 {
                        var imageUrl = ""
                        if let images = item["images"] as? [[String: Any]] {
                            if let image = images.first {
                                if let url = image["url"] as? String {
                                    imageUrl = url
                                }
                            }
                        }

                        let album = Album(id: item["id"] as! String, name: item["name"] as! String, artists: item["artists"] as Any, image: imageUrl as! String, releaseDate: item["release_date"] as! String, totalTracks: item["total_tracks"] as! Int)
                        if (album.totalTracks > 2) {
                            albums.append(album)
                        }
                        completion(albums)
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    @objc func retrieveToken() -> String {
        // Retrieve token from secrets.json
        let path = Bundle.main.path(forResource: "secrets", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String: Any]
        let token = dictionary["SPOTIFY_API"] as! String
        return token
    }

}
