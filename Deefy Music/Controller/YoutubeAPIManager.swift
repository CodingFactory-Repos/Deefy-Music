import Foundation
import AVFoundation

class YoutubeAPIManager {

    // Main function to launch music based on the given parameters
    func launchMusic(params: String) {
        // Retrieve the best match
        print(params)

        let query = params.split(separator: "-")
        let paramsToSend = [
            "title": query[0],
            "artists": query[1],
            "album": query[2]
        ] as [String: Any]

        print(paramsToSend)

        // get to https://youtube-api.loule.me/?title=\(paramsToSend["title"]!)&artists=\(paramsToSend["artists"]!)&album=\(paramsToSend["album"]!)
        let url = URL(string: "https://youtube-api.loule.me/?title=\(paramsToSend["title"]!)&artist=\(paramsToSend["artists"]!)&album=\(paramsToSend["album"]!)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        print(url)

        URLSession.shared.dataTask(with: request) { data, response, error in
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
                    if let link = (json as? [String: Any])?["mp3"] as? String {
                        print(link)

                        // Listen to the sound using MP3 link
                        let player = AVPlayer(url: URL(string: link)!)
                        player.play()

                        print("AAAA")


                    } else {
                        print("No 'dlink' key found in JSON")
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        }.resume()
        }

}
