//
//  LoginViewController.swift
//  Deefy Music
//
//  Created by Louis LEFEBVRE on 10/10/2023.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginTextField: UITextField!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If there are email and password in the user defaults
        if let email = UserDefaults.standard.value(forKey: "email") as? String, let password = UserDefaults.standard.value(forKey: "password") as? String {
            // Fill the text fields
            emailTextField.text = email
            loginTextField.text = password
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginAction(_ sender: Any) {
        // Check if the email and password are correct and match the user defaults
        if let email = emailTextField.text, let password = loginTextField.text, email == UserDefaults.standard.value(forKey: "email") as? String, password == UserDefaults.standard.value(forKey: "password") as? String {
            // If it's correct, dismiss the view controller
            self.dismiss(animated: true, completion: nil)
            // Set the user defaults to logged in
            UserDefaults.standard.set(true, forKey: "isLogged")
        } else {
            // If it's not correct, shake the button
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: loginBtn.center.x - 10, y: loginBtn.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: loginBtn.center.x + 10, y: loginBtn.center.y))

            loginBtn.layer.add(animation, forKey: "position")
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
