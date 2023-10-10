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

        if (UserDefaults.standard.bool(forKey: "isLogged")) {
            print("JE SUIS LOGGED")
        }
    }


}

