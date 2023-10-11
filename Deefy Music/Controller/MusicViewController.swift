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
    var audioPlayer: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string:"https://youtube-api.loule.me/tmp/zBh3QWU6Ynw.mp3")
        else{
            print("url not found")
            return
        }
        print("url found")

//        update slider every second
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)

        do {
            audioPlayer = try AVPlayer(url: url as URL)
            print(audioPlayer.currentItem!.asset.duration.seconds)
            musicSlider.maximumValue = Float(audioPlayer.currentItem!.asset.duration.seconds)
            durationLabel.text = String(format:"%02i:%02i", Int(audioPlayer.currentItem!.asset.duration.seconds) / 60 % 60, Int(audioPlayer.currentItem!.asset.duration.seconds) % 60)

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
        let tolerance = 0.1 // tolerance in seconds
        if let currentTime = audioPlayer.currentItem?.currentTime().seconds,
           let duration = audioPlayer.currentItem?.asset.duration.seconds {
            if abs(currentTime - duration) <= tolerance {
                audioPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            }
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

    @IBAction func ChangeAudioTime(_ sender: Any) {
        audioPlayer.seek(to: CMTime(seconds: Double(musicSlider.value), preferredTimescale: 1))
    }

    @objc func updateSlider(){
        musicSlider.value = Float(audioPlayer.currentTime().seconds)
        currentLabel.text = String(format:"%02i:%02i", Int(audioPlayer.currentTime().seconds) / 60 % 60, Int(audioPlayer.currentTime().seconds) % 60)

        let tolerance = 0.1 // tolerance in seconds
        if let currentTime = audioPlayer.currentItem?.currentTime().seconds,
           let duration = audioPlayer.currentItem?.asset.duration.seconds {
            if abs(currentTime - duration) <= tolerance {
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
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
