//
//  HomeViewController.swift
//  Deefy Music
//
//  Created by Ilan Petiot on 10/10/2023.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var HomeCollectionView: UICollectionView!
    var album : [Album] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spotifyAPIManager = SpotifyAPIManager()
        
        spotifyAPIManager.retrieveSpotifyNewAlbums { albums in
            self.album = albums
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)as! HomeCollectionViewCell
        print(album[indexPath.row].name)
            cell.ImagesCell.downloaded(from: album[indexPath.row].image)
            cell.ImagesCell.contentMode = .scaleAspectFit
            cell.labelImage.text = album[indexPath.row].name
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
