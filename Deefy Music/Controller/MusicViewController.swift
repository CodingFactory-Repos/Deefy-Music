//
//  MusicViewController.swift
//  Deefy Music
//
//  Created by Ilan Petiot on 11/10/2023.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    var audioPlayer = AVPlayer()
    private var player: AVPlayer?
    var playerItem:AVPlayerItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func playVideo(){
        guard let url = URL(string:"url")
        else{
            print("url not found")
            return
        }

        let player = AVPlayer(url:url)
//        let controller = AVPlayerViewController()
//        controller.player = player
//        present(controller, animated: true) {
            player.play()
//        }
    }

    func playAudio(){
        guard let url = URL(string:"https://s3.amazonaws.com/kargopolov/kukushka.mp3")
        else{
            print("url not found")
            return
        }
        print("url found")
        let audioPlayer = AVPlayer(url: url)

        audioPlayer.play()
    }

    @IBAction func Play(_ sender: Any) {
        playAudio()
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
