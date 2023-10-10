//
//  ViewController.swift
//  Deefy Music
//
//  Created by Louis LEFEBVRE on 10/10/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Inside your viewDidLoad method
        if (UserDefaults.standard.bool(forKey: "isLogged")) {
            let spotifyAPIManager = SpotifyAPIManager()

            // Call retrieveSpotifyNewAlbums with a completion handler
            spotifyAPIManager.retrieveSpotifyNewAlbums { albums in
                // Handle the retrieved albums here
                // This code block will execute when the data is ready
                // You can use 'albums' to update your UI or perform other tasks
                print(albums)

                // Clear the page
                DispatchQueue.main.async {
                    // Calculate the dimensions for each image view in the 3x3 grid
                    let gridWidth = self.view.frame.width
                    let gridHeight = self.view.frame.height
                    let imageViewWidth = gridWidth / 3
                    let imageViewHeight = gridHeight / 3

                    // Clear the page
                    for subview in self.view.subviews {
                        subview.removeFromSuperview()
                    }

                    // Display the images as a grid of 3x3
                    var x = 0
                    var y = 0
                    for album in albums.prefix(9) { // Display up to 9 albums
                        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: Int(imageViewWidth), height: Int(imageViewHeight)))
                        imageView.downloaded(from: album.image)
                        self.view.addSubview(imageView)
                        x += Int(imageViewWidth)
                        if x == Int(imageViewWidth) * 3 {
                            x = 0
                            y += Int(imageViewHeight)
                        }
                    }
                }

            }
        }

    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                            let data = data, error == nil,
                            let image = UIImage(data: data)
                    else { return }
                    DispatchQueue.main.async() { [weak self] in
                        self?.image = image
                    }
                }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

