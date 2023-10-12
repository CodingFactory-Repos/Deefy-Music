//
//  MusicViewController.swift
//  Deefy Music
//
//  Created by Ilan Petiot on 11/10/2023.
//

import UIKit
import AVFoundation
import AVKit

class MusicViewController: UIViewController {

    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var audioPlayer: AVPlayer!
    var selectedItem: Search?

    override func viewDidLoad() {
        super.viewDidLoad()

        for subview in self.view.subviews {
            if subview is UILikeButton || subview is UIShareButton {
                subview.removeFromSuperview()
            }
        }

        //        hide the slider and labels
        musicSlider.isHidden = true
        currentLabel.isHidden = true
        durationLabel.isHidden = true
        playButton.isHidden = true
        //        replace with activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        // Check if there is a selected item and if it's a music
        if let item = selectedItem?.item as? Music {
            // Get the item title
            let title = item.title
            // Get the item artist
            let artists = item.artists as? [[String: Any]] ?? []
            // Get the artists' names
            var artistNames: [String] = []
            for artist in artists {
                if let name = artist["name"] as? String {
                    artistNames.append(name)
                }
            }

            let artistsParam = artistNames.joined(separator: ", ") // Join the artist names with a comma
            // Get the item album
            let album = item.album.name

            // Create params for the Youtube API
            let params = "\(title) — \(artistsParam) — \(album)"

            let youtubeApiManager = YoutubeAPIManager()


            // Create an image view
            let imageView = UIImageView()
            imageView.downloaded(from: item.album.image)
            imageView.contentMode = .scaleAspectFit

            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300) // Adjust the size as needed
            imageView.center.x = self.view.center.x
            imageView.center.y = self.view.center.y - imageView.frame.height / 1.2

            self.view.addSubview(imageView)

            titleLabel.text = title
            titleLabel.numberOfLines = 0 // Allows multiple lines
            titleLabel.adjustsFontSizeToFitWidth = true // Reduce font size to fit width

            youtubeApiManager.launchMusic(params: params) { [weak self] result in
                guard let self = self, let url = URL(string: result) else {
                    print("URL not found")
                    return
                }

                print("URL found")

                DispatchQueue.main.async {
                    // Initialize the AVPlayer and set up the UI
                    self.initializeAudioPlayer(with: url)
                    print("loaded")
//                    show the slider and labels
                    self.musicSlider.isHidden = false
                    self.currentLabel.isHidden = false
                    self.durationLabel.isHidden = false
                    self.playButton.isHidden = false
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()

                    var icon = "heart"
                    if let liked = UserDefaults.standard.array(forKey: "liked") as? [[String: String]] {
                        if liked.contains(where: { ($0["id"] ?? "") == item.id }) {
                            icon = "heart.fill"
                        } else {
                            icon = "heart"
                        }
                    } else {
                        icon = "heart"
                    }

                    let likeButton = UILikeButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    likeButton.setImage(UIImage(systemName: icon), for: .normal)
                    likeButton.tintColor = UIColor.black
                    likeButton.center.x = self.view.center.x - 40
                    likeButton.center.y = self.musicSlider.frame.maxY + 12

                    likeButton.addTarget(self, action: #selector(self.likeFunction), for: .touchUpInside)

                    self.view.addSubview(likeButton)


                    let shareButton = UIShareButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
                    shareButton.tintColor = UIColor.black
                    shareButton.center.x = self.view.center.x + 40
                    shareButton.center.y = self.musicSlider.frame.maxY + 10
                    shareButton.id = url.absoluteString
                    shareButton.addTarget(self, action: #selector(self.shareFunction), for: .touchUpInside)

                    self.view.addSubview(shareButton)
                }
            }
        } else if let item = selectedItem?.item as? Podcast {
            // Get the item title
            let title = item.title

            let artist = ""

            let album = "podcast"

            // Create params for the Youtube API
            let params = "\(title) — \(artist) — \(album)"

            let youtubeApiManager = YoutubeAPIManager()

            let imageView = UIImageView()
            imageView.downloaded(from: item.image)
            imageView.contentMode = .scaleAspectFit

            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300) // Adjust the size as needed
            imageView.center.x = self.view.center.x
            imageView.center.y = self.view.center.y - imageView.frame.height / 1.2

            self.view.addSubview(imageView)

            titleLabel.text = title
            titleLabel.numberOfLines = 0 // Allows multiple lines
            titleLabel.adjustsFontSizeToFitWidth = true // Reduce font size to fit width

            youtubeApiManager.launchMusic(params: params) { [weak self] result in
                guard let self = self, let url = URL(string: result) else {
                    print("URL not found")
                    return
                }

                print("URL found")
                DispatchQueue.main.async {
                    self.initializeAudioPlayer(with: url)

                    //                    show the slider and labels
                    self.musicSlider.isHidden = false
                    self.currentLabel.isHidden = false
                    self.durationLabel.isHidden = false
                    self.playButton.isHidden = false
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()

                    var icon = "heart"
                    if let liked = UserDefaults.standard.array(forKey: "liked") as? [[String: String]] {
                        if liked.contains(where: { ($0["id"] ?? "") == item.id }) {
                            icon = "heart.fill"
                        } else {
                            icon = "heart"
                        }
                    } else {
                        icon = "heart"
                    }

                    let likeButton = UILikeButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    likeButton.setImage(UIImage(systemName: icon), for: .normal)
                    likeButton.tintColor = UIColor.black
                    likeButton.center.x = self.view.center.x - 40
                    likeButton.center.y = self.musicSlider.frame.maxY + 12
                    likeButton.addTarget(self, action: #selector(self.likeFunction), for: .touchUpInside)

                    self.view.addSubview(likeButton)

                    let shareButton = UIShareButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
                    shareButton.tintColor = UIColor.black
                    shareButton.center.x = self.view.center.x + 40
                    shareButton.center.y = self.musicSlider.frame.maxY + 10
                    shareButton.id = url.absoluteString
                    shareButton.addTarget(self, action: #selector(self.shareFunction), for: .touchUpInside)

                    self.view.addSubview(shareButton)
                }
            }
        } else {
            print("Selected item is not a valid item.")
        }
    }

    @objc func likeFunction() {
        // Get the item id
        var icon = "heart.fill"

        if let item = selectedItem?.item as? Music {
            let id = item.id
            let type = selectedItem?.type ?? "music"
            // Get the liked items
            if var liked = UserDefaults.standard.array(forKey: "liked") as? [[String: String]] {
                if liked.contains(where: { ($0["id"] ?? "") == id }) {
                    // Remove the item from the liked items
                    liked.removeAll(where: { ($0["id"] ?? "") == id })
                    icon = "heart"
                } else {
                    // Add the item to the liked items
                    liked.append(["id": id, "type": type])
                    icon = "heart.fill"
                }
                UserDefaults.standard.set(liked, forKey: "liked")
            } else {
                UserDefaults.standard.set([["id": id, "type": type]], forKey: "liked")
            }
        } else if let item = selectedItem?.item as? Podcast {
            let id = item.id
            let type = selectedItem?.type ?? "podcast"
            // Get the liked items
            if var liked = UserDefaults.standard.array(forKey: "liked") as? [[String: String]] {
                if liked.contains(where: { ($0["id"] ?? "") == id }) {
                    // Remove the item from the liked items
                    liked.removeAll(where: { ($0["id"] ?? "") == id })
                } else {
                    // Add the item to the liked items
                    liked.append(["id": id, "type": type])
                    icon = "heart.fill"
                }
                UserDefaults.standard.set(liked, forKey: "liked")
            } else {
                UserDefaults.standard.set([["id": id, "type": type]], forKey: "liked")
            }
        } else {
            print("Selected item is not a valid item.")
        }

        // Get rid of the old button
        for subview in self.view.subviews {
            if subview is UILikeButton {
                subview.removeFromSuperview()
            }
        }

        let likeButton = UILikeButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        likeButton.setImage(UIImage(systemName: icon), for: .normal)
        likeButton.tintColor = UIColor.black
        likeButton.center.x = self.view.center.x - 40
        likeButton.center.y = self.musicSlider.frame.maxY + 12
        likeButton.addTarget(self, action: #selector(likeFunction), for: .touchUpInside)

        self.view.addSubview(likeButton)

    }

    @objc func shareFunction() {
        // Get the id of the button clicked
        let url = (self.view.subviews.first(where: { $0 is UIShareButton }) as? UIShareButton)?.id ?? ""
        UIPasteboard.general.string = url
    }

    func initializeAudioPlayer(with url: URL) {
        // Initialize the AVPlayer
        do {
            audioPlayer = AVPlayer(url: url)
            musicSlider.maximumValue = Float(audioPlayer.currentItem?.asset.duration.seconds ?? 0)
            updateDurationLabel()
            setupAudioSession()
        } catch {
            print("AVPlayer initialization error: \(error)")
        }

        // Schedule the slider update timer
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }

    func updateDurationLabel() {
        let duration = Int(audioPlayer.currentItem?.asset.duration.seconds ?? 0)
        let minutes = duration / 60
        let seconds = duration % 60
        durationLabel.text = String(format: "%02i:%02i", minutes, seconds)
    }

    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            print("Playback category set successfully")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session is active")
        } catch {
            print("Audio session setup error: \(error)")
        }
    }

    @IBAction func Play(_ sender: Any) {
        let tolerance = 0.1 // Tolérance en secondes
        if let currentTime = audioPlayer.currentItem?.currentTime().seconds,
           let duration = audioPlayer.currentItem?.asset.duration.seconds {
            if abs(currentTime - duration) <= tolerance {
                // La lecture est considérée comme terminée
                audioPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            }
        }
        if audioPlayer.rate == 0 {
            // Play the audio
            audioPlayer.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            // Pause the audio
            audioPlayer.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @IBAction func ChangeAudioTime(_ sender: Any) {
        audioPlayer.seek(to: CMTime(seconds: Double(musicSlider.value), preferredTimescale: 1))
    }

    @objc func updateSlider() {
        musicSlider.value = Float(audioPlayer.currentTime().seconds)
        currentLabel.text = String(format: "%02i:%02i", Int(audioPlayer.currentTime().seconds) / 60 % 60, Int(audioPlayer.currentTime().seconds) % 60)

        let tolerance = 0.1 // Tolerance in seconds
        if let currentTime = audioPlayer.currentItem?.currentTime().seconds,
           let duration = audioPlayer.currentItem?.asset.duration.seconds {
            if abs(currentTime - duration) <= tolerance {
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
}


// Extend UIButton to create UILikeButton
class UILikeButton: UIButton {
    var id: String?
    var type: String?
}

class UIShareButton: UIButton {
    var id: String?
    var type: String?
}
