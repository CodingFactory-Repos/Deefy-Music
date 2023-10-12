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

        guard let url = URL(string:"https://cdns-preview-d.dzcdn.net/stream/c-deda7fa9316d9e9e880d2c6207e92260-10.mp3")
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

    @IBAction func ChangeAudioTime(_ sender: Any) {
        audioPlayer.seek(to: CMTime(seconds: Double(musicSlider.value), preferredTimescale: 1))
    }

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
