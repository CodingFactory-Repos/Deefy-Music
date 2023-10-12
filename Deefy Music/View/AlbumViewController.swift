//
//  AlbumViewController.swift
//  Deefy Music
//
//  Created by Louis LEFEBVRE on 12/10/2023.
//

import UIKit

class AlbumViewController: UIViewController {
    var album : Album!


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)

        print(album)

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
