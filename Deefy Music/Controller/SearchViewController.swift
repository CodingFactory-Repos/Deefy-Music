//
//  SearchViewController.swift
//  Deefy Music
//
//  Created by Ilan Petiot on 11/10/2023.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!

    var search: [Search] = []
    var filteredData: [Search]!
    var helpText = "You can search for artists, albums, playlists or songs."
    var welcomeText = "Listen to your favorite music."


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"


       // Append an empty search
        filteredData = search

        if (filteredData.isEmpty) {
            let welcomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            welcomeLabel.text = welcomeText
            welcomeLabel.textColor = UIColor.black
            welcomeLabel.textAlignment = NSTextAlignment.center
            self.SearchTableView.backgroundView = welcomeLabel

            // Add an help label to explain how to search just below the welcome label
            let helpLabel = UILabel(frame: CGRect(x: 0, y: -30, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            helpLabel.text = helpText
            helpLabel.textColor = UIColor.gray
            helpLabel.textAlignment = NSTextAlignment.center
            self.SearchTableView.backgroundView?.addSubview(helpLabel)

            self.SearchTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        SearchTableView.dataSource = self
        SearchTableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchTableViewCell
        cell.Title.text = filteredData[indexPath.row].title
        cell.Artist.text = filteredData[indexPath.row].artist
        cell.MusicImage.downloaded(from: filteredData[indexPath.row].image)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.row < filteredData.count {
                print(filteredData[indexPath.row])

                switch filteredData[indexPath.row].type {
                case "album":
                    let albumViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "album") as! AlbumViewController
                    albumViewController.album = filteredData[indexPath.row].item as! Album
                    self.navigationController?.pushViewController(albumViewController, animated: true)
                case "artist":
                    let artistViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "artistView") as! ArtistViewController
                    artistViewController.artist = filteredData[indexPath.row].item as! Artist
                    self.navigationController?.pushViewController(artistViewController, animated: true)
                default:
                    if let musicVC = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "Music") as? MusicViewController {
                        musicVC.selectedItem = filteredData[indexPath.row] as? Search
                        self.present(musicVC, animated: true, completion: nil)
                    }
                }
            } else {
                // Handle the case when indexPath.row is out of bounds
                print("Invalid indexPath: \(indexPath.row)")
                // You can show an alert or perform other error-handling logic here
            }
      }

    var searchTask: DispatchWorkItem?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = []
            SearchTableView.reloadData()
            helpText = "You can search for artists, albums, playlists or songs."
            welcomeText = "Listen to your favorite music."
            searchTask?.cancel()
            return
        }
        searchTask?.cancel()

        // Create a new search task
        searchTask = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.filteredData = []

            let spotifyAPIManager = SpotifyAPIManager()
            spotifyAPIManager.searchForItem(query: searchText, offset: 0) { search in
                if (search.count == 0) {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "No Results", message: "No search results were found for \(searchText)", preferredStyle: .alert)

                        // Add an OK button to the alert
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                        // Present the alert on the main thread
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    for item in search {
                        self.makeAppearItem(item["item"]!)

                        // Update the UI on the main queue
                        DispatchQueue.main.async {
                            self.SearchTableView.reloadData()
                        }
                    }
                }
            }
        }

        // Schedule the new search task to execute after 3 seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: searchTask!)
    }

    func makeAppearItem(_ item: Any) {
        if let music = item as? Music {

            let authorAndFeats = music.artists as! [[String: Any]]
            let author = authorAndFeats[0]["name"] as! String

            self.filteredData.append(Search(image: music.album.image, artist: "Music · \(author)", title: music.title, item: music, type: "music"))
        } else if let artist = item as? Artist {
            // Append the artist to the filteredData
            self.filteredData.append(Search(image: artist.image, artist: "Seek profile",  title: artist.name, item: artist, type: "artist"))
        } else if let album = item as? Album {
            // Append the album to the filteredData
            let authorAndFeats = album.artists as! [[String: Any]]
            let author = authorAndFeats[0]["name"] as! String
            self.filteredData.append(Search(image: album.image, artist: "Album · \(author) ", title: album.name, item: album, type: "album"))
        } else if let playlist = item as? Playlist {
            self.filteredData.append(Search(image: playlist.image, artist: "Playlist · \(playlist.owner["display_name"] as! String)", title: playlist.name, item: playlist , type: "playlist"))
        } else if let podcast = item as? Podcast {
            self.filteredData.append(Search(image: podcast.image, artist: "Podcast", title: podcast.title, item: podcast, type: "podcast"))
        } else {
            print("Item is not a valid type.")
        }
    }

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

