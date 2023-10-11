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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Do any additional setup after loading the view.

        if (UserDefaults.standard.bool(forKey: "isLogged")) {
//            if let collectionViewController = storyboard.instantiateViewController(withIdentifier: "homeView") as? HomeCollectionViewController {
//                let flowLayout = UICollectionViewFlowLayout()
//                collectionViewController.collectionView.collectionViewLayout = flowLayout
//                self.navigationController?.pushViewController(collectionViewController, animated: true)
//            }
//           self.navigationController?.pushViewController(HomeCollectionViewController(), animated: true)

//            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as? HomeViewController {
////                self.present(vc, animated:true, completion: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }

             let collectionViewController = storyboard.instantiateViewController(withIdentifier: "tabBar")
                self.navigationController?.pushViewController(collectionViewController, animated: true)

        }
    }


}

