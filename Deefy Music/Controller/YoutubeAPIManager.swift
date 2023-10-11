import Foundation

class YoutubeAPIManager {

    // Main function to launch music based on the given parameters
    func launchMusic(params: String) {
        // Retrieve the best match
        let bestMatch = retrieveBestMatch(params: params)

        if let music = bestMatch {
            // Start the music with the found match
            downloadMusic(music: music)
        } else {
            print("No match found")
        }
    }

    // Function to retrieve the best match based on the parameters
    func retrieveBestMatch(params: String) -> [String: Any]? {
        // Create the request and get JSON data
        if let responseData = fetchDataWithParameters(params: params) {
            // Parse JSON data
            if let items = parseJSONData(data: responseData) {
                // Find the best match
                let bestMatch = findBestMatch(params: params, items: items)
                return bestMatch
            }
        }

        return nil // No match found or an error occurred
    }

    // Function to retrieve JSON data based on parameters
    func fetchDataWithParameters(params: String) -> Data? {
        let parameters: [String: String] = [
            "q": params,
            "vt": "mp3"
        ]

        // Create the HTTP request
        if let request = createURLMusicRequestWithParameters(parameters: parameters) {
            // Execute the request and get data
            return executeRequest(request: request)
        }

        return nil
    }

    // Function to parse JSON data
    func parseJSONData(data: Data) -> [[String: Any]]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return json?["items"] as? [[String: Any]]
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            return nil
        }
    }

    // Function to find the best match among the items
    func findBestMatch(params: String, items: [[String: Any]]) -> [String: Any]? {
        var bestMatch: (item: [String: Any], distance: Int)? = nil

        for item in items {
            if let title = item["t"] as? String {
                // Calculate the Levenshtein distance between the params and the title
                let distance = levenshteinDistance(params: params, title: title)

                // Check if this title is a better match
                if bestMatch == nil || distance < bestMatch!.distance {
                    bestMatch = (item, distance)
                }
            }
        }

        return bestMatch?.item
    }

    // Function to create the URLRequest
    func createURLMusicRequestWithParameters(parameters: [String: String]) -> URLRequest? {
        let url = URL(string: "https://yt1s.com/api/ajaxSearch/index")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Create the query string from parameters
        if let query = createQueryWithParameters(parameters: parameters) {
            let parameterData = Data(query.utf8)
            request.httpBody = parameterData
            return request
        }

        return nil
    }

    // Function to create the query string from parameters
    func createQueryWithParameters(parameters: [String: String]) -> String? {
        var components = URLComponents()
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url?.query
    }

    // Function to execute the URLRequest and get data
    func executeRequest(request: URLRequest) -> Data? {
        let session = URLSession.shared
        var responseData: Data?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = session.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                responseData = data
            }
            semaphore.signal()
        }

        dataTask.resume()
        semaphore.wait()

        return responseData
    }

    func levenshteinDistance(params: String, title: String) -> Int {
        let paramsArray = Array(params)
        let titleArray = Array(title)
        let paramsLength = paramsArray.count
        let titleLength = titleArray.count
        var distanceMatrix = [[Int]]()


        // Initialize the matrix
        for _ in 0...paramsLength {
            var row = [Int]()
            for _ in 0...titleLength {
                row.append(0)
            }
            distanceMatrix.append(row)
        }

        // Initialize the first row
        for i in 0...paramsLength {
            distanceMatrix[i][0] = i
        }

        // Initialize the first column
        for j in 0...titleLength {
            distanceMatrix[0][j] = j
        }

        // Calculate the distance
        for i in 1...paramsLength {
            for j in 1...titleLength {
                if paramsArray[i - 1] == titleArray[j - 1] {
                    distanceMatrix[i][j] = distanceMatrix[i - 1][j - 1]
                } else {
                    distanceMatrix[i][j] = min(distanceMatrix[i - 1][j] + 1, distanceMatrix[i][j - 1] + 1, distanceMatrix[i - 1][j - 1] + 1)
                }
            }
        }

        return distanceMatrix[paramsLength][titleLength]
    }

    func downloadMusic(music: [String: Any]) {
        print("Attempting to download music...")
        let parameters: [String: String] = [
            "q": "https://www.youtube.com/watch?v=\(music["v"]!)",
            "vt": "mp3"
        ]

        // Create the HTTP request to https://yt1s.com/api/ajaxConvert/convert on post
        if let request = createURLDownloadMusicParameters(parameters: parameters) {
            // Execute the request and get data
            if let data = executeRequest(request: request) {
                if let json = parseDLData(data: data) {
                    // Get the highest quality from the available ones in json["mp3"]
                    if let mp3 = json["mp3"] as? [String: Any] {
                        // Check the keys and get the highest number (128, 256, 320)
                        var highestQuality = 0
                        var highestQualityKey = ""
                        for (key, music) in mp3 {
                            if let keyInt = Int(key) {
                                if keyInt > highestQuality {
                                    highestQuality = keyInt
                                    if let musicDictionary = music as? [String: Any] {
                                        highestQualityKey = musicDictionary["k"] as! String
                                    }
                                }
                            }
                        }
                        self.downloadMusicFromKey(key: highestQualityKey, musicId: music["v"] as! String)
                    }
                }
            }
        }
    }

    func downloadMusicFromKey(key: String, musicId: String) {
//        print(musicId)
//        print(key)
    print("Attempting to download music from key...")
        let parameters: [String: String] = [
            "vid": musicId,
            "k": key
        ]
        // Url https://yt1s.com/api/ajaxConvert/convert to post
        if let request = createURLDownloadMusicFromKeyParameters(params: parameters) {
            if let data = executeRequest(request: request) {
                if let json = parseDLFromKeyData(data: data) {
                    print(json)
                    // Get the download link
                    if let downloadLink = json["dlink"] as? String {
                        // Download the music
//                        downloadMusicFromLink(link: downloadLink)
                    }
                }
            }
        }
    }

    func createURLDownloadMusicFromKeyParameters(params: [String: String]) -> URLRequest? {
        let url = URL(string: "https://yt1s.com/api/ajaxConvert/convert")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Create the query string from parameters
        if let query = createQueryWithParameters(parameters: params) {
            let parameterData = Data(query.utf8)
            request.httpBody = parameterData
            return request
        }

        return nil
    }

    func parseDLFromKeyData(data: Data) -> [String: Any]? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(json)
                if let dlink = json["dlink"] as? String {
                    return ["dlink": dlink]
                } else {
                    print("The 'dlink' key is not a valid String.")
                    return nil
                }
            } else {
                print("Invalid JSON format in response.")
                return nil
            }
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            return nil
        }
    }



    func parseDLData(data: Data) -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return json?["links"] as Any as? [String: Any]
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            return nil
        }
    }

    func createURLDownloadMusicParameters(parameters: [String: String]) -> URLRequest? {
//        print(parameters)
        let url = URL(string: "https://yt1s.com/api/ajaxSearch/index")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Create the query string from parameters
        if let query = createQueryWithParameters(parameters: parameters) {
            let parameterData = Data(query.utf8)
            request.httpBody = parameterData
            return request
        }

        return nil
    }
}
