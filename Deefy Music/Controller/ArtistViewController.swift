//
//  ArtistViewController.swift
//  Deefy Music
//
//  Created by Loucassoulet on 12/10/2023.
//

import UIKit

class ArtistViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {

    var artist : Artist!
    var albums : [Album] = []
    var tracks : [Music] = []

    @IBOutlet weak var tracksCollections: UITableView!
    @IBOutlet weak var albumCollection: UICollectionView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(artist)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = artist.name
        self.artistImage.downloaded(from: artist.image)
        self.artistName.text = artist.name
//        self.artistImage.layer.cornerRadius = 10
//        self.artistImage.clipsToBounds = true

        albumCollection.dataSource = self
        albumCollection.delegate = self
        tracksCollections.dataSource = self
        tracksCollections.delegate = self

        let spotifyManager = SpotifyAPIManager()
        spotifyManager.getAlbumsFromArtist(artistId: artist.id) { album in
            if let album = album as? [Album] {
                self.albums = album
            }
        }
        spotifyManager.getTopTracksFromArtist(artistId: artist.id){ track in
            print("AHAHAHAHAHAHAHAHAH")
            if let music = track as? [Music] {
                self.tracks = music
            }
        }
        DispatchQueue.main.async {
            self.tracksCollections.reloadData()
            self.albumCollection.reloadData()
        }
    }

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistAlbumCell", for: indexPath)as! ArtistAlbumCollectionViewCell
        cell.albumTitle.text = self.albums[indexPath.row].name
        cell.albumCover.downloaded(from: self.albums[indexPath.row].image)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumViewController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "album") as! AlbumViewController
        albumViewController.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(albumViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistTrackCell") as! ArtistTrackTableViewCell
        cell.trackName.text = self.tracks[indexPath.row].title
        return cell
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
