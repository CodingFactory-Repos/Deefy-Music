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
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (UserDefaults.standard.bool(forKey: "isLogged")) {
            let tabBarController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }


}

