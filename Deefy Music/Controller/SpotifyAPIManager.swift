//
// Created by Guillaume on 10/10/2023.
//

import Foundation


public class SpotifyAPIManager {

    public init() {
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
                        print (album.id)
                    }

                    print(albums.count)

                    completion(albums)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    @objc func retrieveToken() -> String {
        // Retrive token from secrets.json
        let path = Bundle.main.path(forResource: "secrets", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        let dictionary = json as! [String: Any]
        let token = dictionary["SPOTIFY_API"] as! String
        print(token)
        return token
    }
}
