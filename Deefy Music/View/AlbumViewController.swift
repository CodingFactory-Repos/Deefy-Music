//
//  AlbumViewController.swift
//  Deefy Music
//
//  Created by Louis LEFEBVRE on 12/10/2023.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var album : Album!
    var tracks : [Music] = []
    var artistName: [String] = []



    @IBOutlet weak var trackList: UITableView!
    @IBOutlet weak var albumPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = album.name
        let artists = album.artists as? [[String: Any]] ?? []
        for artist in artists {
            if let name = artist["name"] as? String {
                artistName.append(name)
            }
        }

        albumPicture.downloaded(from: album.image)

        let spotifyAPIManager = SpotifyAPIManager()
        spotifyAPIManager.getTracksFromAlbum(albumId: album.id) { track in
            //CHeck if track are in the type Music
            if let track = track as? [Music] {
                self.tracks = track
                DispatchQueue.main.async {
                    self.trackList.reloadData()
                }
            }

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.tracks.count)
        return self.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
            cell.trackLAbel.text = self.tracks[indexPath.row].title
            cell.artistLabel.text = artistName[0]
        return cell
    }
    //func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    print("salut")
      //  let track = tracks[indexPath.row]
        //let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        //cell.trackLAbel.text = track.title
      //  cell.artistLabel.text = artistName[0]
      //  return cell
   // }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
