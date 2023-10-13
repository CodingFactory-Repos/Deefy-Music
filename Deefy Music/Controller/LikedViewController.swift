//
//  LikedViewController.swift
//  Deefy Music
//
//  Created by lucas on 11/10/2023.
//

import UIKit

class LikedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var likedTableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likedMusic.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "likedCell") as! LikedTableViewCell
        cell.titleLabel.text = self.likedMusic[indexPath.row].title
        cell.artistLabel.text = self.likedMusic[indexPath.row].artist
        cell.albumImage.downloaded(from: self.likedMusic[indexPath.row].image)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicVC = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "Music") as! MusicViewController
        musicVC.selectedItem = likedMusic[indexPath.row] as? Search
        self.present(musicVC, animated: true, completion: nil)
    }

    var liked: [[String: String]] = []
    var likedMusic: [Search] = []
    var theArtist: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        likedTableView.dataSource = self
        likedTableView.delegate = self


        if let liked = UserDefaults.standard.array(forKey: "liked") as? [[String: String]] {
            self.liked = liked
        }

        print(liked)

        let spotifyAPIManager = SpotifyAPIManager()

        for id in liked {
            spotifyAPIManager.searchForMusicWithID(id: id["id"]!) { track in
                if let music = track as? Music {
                    let authorAndFeats = music.artists as! [[String: Any]]
                    let author = authorAndFeats[0]["name"] as! String

                    self.likedMusic.append(Search(image: music.album.image, artist: "Music · \(author)", title: music.title, item: music, type: "music"))

                    // Refresh the tableView
                    DispatchQueue.main.async {
                        self.likedTableView.reloadData()
                    }
                }
            }
        }

        // Do any additional setup after loading the view.
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
