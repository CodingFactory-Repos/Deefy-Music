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
//                print(albums)

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
                    for album in albums.prefix(9) {
                        let imageView = UIImageView(frame: CGRect(x: x, y: y, width: Int(imageViewWidth), height: Int(imageViewHeight)))
                        imageView.downloaded(from: album.image)

                        // Associate album data with the image view using a custom property
                        imageView.accessibilityIdentifier = album.id

                        self.view.addSubview(imageView)

                        x += Int(imageViewWidth)
                        if x == Int(imageViewWidth) * 3 {
                            x = 0
                            y += Int(imageViewHeight)
                        }

                        // Add a tap gesture recognizer to each image view
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
                        imageView.isUserInteractionEnabled = true
                        imageView.addGestureRecognizer(tapGestureRecognizer)
                    }
                }
            }
        }

    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let tappedImageView = tapGestureRecognizer.view as? UIImageView {
            // Identify which album was tapped based on the image view's tag or custom property
            if let album = tappedImageView.accessibilityIdentifier {
                // You can access album details here and display them
                print("Album tapped: \(album)")

                let spotifyAPIManager = SpotifyAPIManager()
                spotifyAPIManager.getTracksFromAlbum(albumId: album) { tracks in
//                     Handle the retrieved tracks here
//                     This code block will execute when the data is ready
//                     You can use 'tracks' to update your UI or perform other tasks
                    DispatchQueue.main.async {
                        // Clear the page
                        for subview in self.view.subviews {
                            subview.removeFromSuperview()
                        }

                        print(tracks)

                        // Display the tracks as a list
                        var y = 0
                        for track in tracks {
                            let label = UILabel(frame: CGRect(x: 0, y: y, width: Int(self.view.frame.width), height: 20))
                            label.text = track.title
                            self.view.addSubview(label)
                            y += 20
                        }
                    }

                }
                // Fetch and display album details (e.g., tracks) here
                // Call your SpotifyAPIManager's method to fetch album details
                // Example:
                // spotifyAPIManager.getTracksFromAlbum(albumId: album.id) { tracks in
                //     // Handle the retrieved tracks and display album details
                // }
            }
        }
        // Retrieve the tracks from the API
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

