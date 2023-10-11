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

        do {
            audioPlayer = try AVPlayer(url: url as URL)

        } catch let error {
            print(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func Play(_ sender: Any) {

    print(audioPlayer?.rate as Any)
        if audioPlayer?.rate == nil || audioPlayer?.rate == 0{
            audioPlayer?.play()
            print("play")
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            print("pause")
            audioPlayer?.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            print(audioPlayer.currentTime().seconds)
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
