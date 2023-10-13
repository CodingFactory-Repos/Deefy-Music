//
//  ViewController.swift
//  Deefy Music
//
//  Created by Louis LEFEBVRE on 10/10/2023.
//

import UIKit
import AVFoundation

protocol ModalDelegate: class {
    func login()
}
class ViewController: UIViewController, ModalDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("APPEARD")
        if (UserDefaults.standard.bool(forKey: "isLogged")) {
            let tabBarController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
        // Retrieve the tracks from the API
    }
    func login(){
        if (UserDefaults.standard.bool(forKey: "isLogged")) {
            let tabBarController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "tabBar")
            self.navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    @IBAction func createAccount(_ sender: Any) {
        let createAccount = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createAccount")
        self.present(createAccount, animated: true, completion: nil)
    }
    @IBAction func loginAccount(_ sender: Any) {
        let loginAccount = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginAccount") as? LoginViewController
        loginAccount?.delegate = self
        self.present(loginAccount!, animated: true, completion: nil)

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

