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

    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var trackList: UITableView!
    @IBOutlet weak var albumPicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = album.name
        let artists = album.artists as? [[String: Any]] ?? []
        for artist in artists {
            if let name = artist["name"] as? String {
                artistLabel.text = name
            }
        }
        trackList.dataSource = self
        trackList.delegate = self

        albumPicture.downloaded(from: album.image)

        let spotifyAPIManager = SpotifyAPIManager()
        spotifyAPIManager.getTracksFromAlbum(albumId: album.id) { track in
            self.tracks = track
            DispatchQueue.main.async {
                self.trackList.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
            cell.trackLAbel.text = self.tracks[indexPath.row].title
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let player = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "player") as! MusicViewController
//        player.track = self.tracks[indexPath.row]
//        self.navigationController?.pushViewController(player, animated: true)
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
