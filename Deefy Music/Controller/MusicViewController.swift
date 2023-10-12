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

    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    var audioPlayer: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

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
            let params = "\(title) - \(artistsParam) - \(album)"

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
                }
            }
        } else {
            print("Selected item is not a valid Music item.")
        }
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
        print("url found")

//        update slider every second
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)

        do {
            audioPlayer = try AVPlayer(url: url as URL)
            print(audioPlayer.currentItem!.asset.duration.seconds)
            musicSlider.maximumValue = Float(audioPlayer.currentItem!.asset.duration.seconds)

        } catch let error {
            print(error)
        }

//        keep playing when leaving the app
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func Play(_ sender: Any) {
        print(audioPlayer?.rate)
        if audioPlayer.currentItem?.currentTime().seconds == audioPlayer.currentItem?.asset.duration.seconds{
            audioPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        }
        if audioPlayer?.rate == 0{
            audioPlayer?.play()
            print("play")
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            print("pause")
            audioPlayer?.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    
    // MARK: - Navigation

    @objc func updateSlider(){
        musicSlider.value = Float(audioPlayer.currentTime().seconds)
        if audioPlayer.currentItem?.currentTime().seconds == audioPlayer.currentItem?.asset.duration.seconds{
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
